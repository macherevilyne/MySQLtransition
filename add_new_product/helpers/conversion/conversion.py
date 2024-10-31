import logging

from main.helpers.sql_connection.helpers import HelpersSQL
from main.helpers.conversion.helpers import HelpersConversion, read_config
from main.helpers.sql_connection.sql_connection import Connector


logger = logging.getLogger(__name__)


# converters CSV files to MySQL, tables

class Conversion:

    def __init__(self, provider_name:str):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.helpers_conversion = HelpersConversion()
        self.provider_name = provider_name
        self.config = read_config()
        self.base_path = self.config['client'].get('base_path')

    def table1(self, db_name: str):
        file_folder_name = 'conversion'
        file_name = 'Reserveringen'
        name_new_table = 'table1'

        logger.info(f'Creating {name_new_table}')

        logger.info(f" Finding table {name_new_table} in data base {db_name}")

        if self.sql.check_table(db_name=db_name, table_name=name_new_table):
            logger.info(f" Table {name_new_table} exist, creating back up.")
        else:
            logger.info(f" Table {name_new_table} dont exist, creating new table.")


        self.helpers_conversion.transfer_csv_to_mysql(file_folder_name=file_folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, base_path=self.base_path)

        logger.info(f'Created {name_new_table}')



    def run(self, db_name: str):
        logger.info('Сonversion start')
        self.sql.create_database(db_name)
        self.table1(db_name)
        logger.info('Сonversion end')
