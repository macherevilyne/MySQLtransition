import datetime
import logging
import os

import chardet as chardet
import pandas as pd

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.utils.get_file import Files
import configparser

logger = logging.getLogger(__name__)


def read_config(config_file='config.ini'):
    config = configparser.ConfigParser()
    config.read(config_file)
    return config


class HelpersConversion:
    def __init__(self):
        self.sql = Connector()
        self.files = Files()


    def csv_read(self, path_file: str, skiprows=None):
        with open(path_file, 'rb') as f:
            rawdata = f.read()
        encoding = chardet.detect(rawdata)['encoding']

        df = pd.read_csv(path_file, low_memory=False, on_bad_lines='skip', sep=';', encoding=encoding,
                         skiprows=skiprows)
        df.columns = df.columns.str.strip()

        return df

    def excel_read(self, path_file: str, skiprows=None):
        df = pd.read_excel(path_file, index_col=0, skiprows=skiprows)
        df.columns = df.columns.str.strip()

        return df

    def transfer_csv_to_mysql(self, file_folder_name: str, provider_name: str, file_name: str, name_new_table: str,
                              base_path: str, db_name: str, skiprows=None, dtype: dict = None):

        logger.info(f'Creating {name_new_table} table')

        path_folder = self.files.get_input_folder(file_folder_name=file_folder_name, provider_name=provider_name, base_path=base_path,db_name=db_name)

        logger.info(f'Path folder: {path_folder}')
        try:

            csv_file = self.files.get_file(file_name, path_folder)
        except Exception as e:
            logger.error(f'{e}', 'A SUDA PRIHODIT')
            logger.info(f'path_folder: {path_folder} \n'
                        f'file_name: {file_name}')
            raise e




        connection = self.sql.connection(db_name)
        path_file = os.path.join(path_folder, csv_file)
        csv_read = self.csv_read(path_file=path_file, skiprows=skiprows)
        self.write_in_mysql(conn=connection, df=csv_read, db_name=db_name, name_new_table=name_new_table, dtype=dtype)
        logger.info(f'Created {name_new_table} table')

    def transfer_excel_to_mysql(self, file_folder_name: str, provider_name: str, bath_path:str,file_name: str,
                                name_new_table: str, db_name: str, skiprows=None):
        logger.info(f'Creating {name_new_table} table')
        path_folder = self.files.get_input_folder(file_folder_name=file_folder_name,base_path=bath_path, provider_name=provider_name, db_name=db_name)
        excel_file = self.files.get_file(file_name, path_folder)
        connection = self.sql.connection(db_name)
        path_file = os.path.join(path_folder, excel_file)
        excel_read = self.excel_read(path_file=path_file, skiprows=skiprows)
        self.write_in_mysql(conn=connection, df=excel_read, db_name=db_name, name_new_table=name_new_table)
        logger.info(f'Created {name_new_table} table')


    # writes data from file in tables to MySQL
    def write_in_mysql(self, conn, df, db_name, name_new_table: str, dtype: dict = None):
        if self.sql.check_table(db_name=db_name, table_name=name_new_table):
            print(name_new_table, 'name_new_table')
            # Получение текущей даты и времени
            current_datetime = datetime.datetime.now()

            # Передаем текущую дату и время в метод backup_table
            self.sql.backup_table(db_name=db_name, table_name=name_new_table, date=current_datetime)



        self.sql.delete_table(db_name=db_name, table_name=name_new_table)
        chunk_size = 10000
        df.to_sql(name=name_new_table, con=conn, if_exists='append', index=False, chunksize=chunk_size, dtype=dtype)

