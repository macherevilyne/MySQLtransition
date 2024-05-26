import os
import logging
from sqlalchemy import create_engine
import configparser

from .helpers import HelpersSQL

logger = logging.getLogger(__name__)


class Connector:

    def __init__(self):
        config = configparser.ConfigParser()
        file_config = os.path.join(os.getcwd(), 'config.ini')
        config.read(file_config)
        self.created_database_name = None
        self.username = config["client"]["user"]
        self.password = config["client"]["password"]
        self.host = config["client"]["host"]
        self.port = config["client"]["port"]
        self.helpers_sql = HelpersSQL()
        self.db_url = f'mysql+mysqlconnector://{self.username}:{self.password}@{self.host}:{self.port}'

    # open connections with database
    def connection(self, db_name=''):
        engine = create_engine(
            f'{self.db_url}/{db_name}?charset=utf8',
            pool_pre_ping=True,
            echo=False,
            connect_args={'auth_plugin': 'mysql_native_password'}  # need for simple password
        )
        return engine.connect()
    # creates database "database_YYMM"
    def create_database(self, db_name: str):
        connection = self.connection()
        sql = f'CREATE DATABASE IF NOT EXISTS {db_name}'
        print(f"Executing SQL query: {sql}")
        connection.execute(sql)
        print(f"Database '{db_name}' created successfully.")




    def check_database(self, db_name: str):
        connection = self.connection()
        sql = f'SHOW DATABASES LIKE "{db_name}";'
        result = connection.execute(sql)
        for _ in result:
            return True
        return False

    def check_table(self, db_name: str, table_name: str):
        connection = self.connection(db_name)
        sql = f'SHOW TABLES LIKE "{table_name}";'
        result = connection.execute(sql)
        for _ in result:
            return True
        return False
    #
    # def get_all_tables(self, db_name: str):
    #     connection = self.connection(db_name)
    #     sql = 'SHOW TABLES;'
    #     result = connection.execute(sql)
    #     tables = [row[0] for row in result]
    #     return tables


    def check_tables(self, db_name: str, table_name: str):
        connection = self.connection(db_name)
        sql = f'SHOW TABLES LIKE "%{table_name}%";'
        result = connection.execute(sql)
        for _ in result:
            return True
        return False

    def delete_table(self, db_name: str, table_name: str):
        connection = self.connection(db_name)
        sql = f'DROP TABLE IF EXISTS `{table_name}`;'
        connection.execute(sql)

    def backup_table(self, db_name: str, table_name: str, date):
        year = date.year
        month = date.month
        day = date.day
        hour = date.hour
        minute = date.minute
        second = date.second
        date_format = f'{year}{month}{day}_{hour}{minute}{second}'
        connection = self.connection(db_name)
        backup_table_name = f'{table_name}_{date_format}'
        sqls = [f'DROP TABLE IF EXISTS `{backup_table_name}`;',
                f'CREATE TABLE IF NOT EXISTS `{backup_table_name}` LIKE `{table_name}`;',
                f'INSERT INTO `{backup_table_name}` SELECT * FROM `{table_name}`;']
        for sql in sqls:
            try:
                connection.execute(sql)
            except Exception as e:
                logger.error(str(e))

    # executes other macros
    def execute_macros(self, folder_name: str, provider_name: str, file_name: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            self.connection(db_name).execute(command)
