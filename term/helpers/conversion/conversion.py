import logging
import os

from main.helpers.sql_connection.helpers import HelpersSQL
from main.helpers.conversion.helpers import HelpersConversion
from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.utils.get_file import Files

logger = logging.getLogger(__name__)


# converters CSV files to MySQL, tables: "Policydata_NewReport", "DeHoopData", 'C_CalcEngine', 'C_CoverType',
# 'C_Education', 'C_Flags', 'C_Freq', 'C_Occupation', 'C_Status'
# creates SQL functions "PremWoOptions"
class Conversion:

    def __init__(self):
        self.sql = Connector()
        self.files = Files()
        self.helpers_sql = HelpersSQL()
        self.helpers_conversion = HelpersConversion()
        self.provider_name = 'TERM'

    def policydata_new_report(self, db_name: str):
        folder_name = 'policydata_new_report'
        file_name = 'Policydata'
        name_new_table = 'Policydata_NewReport'
        self.helpers_conversion.transfer_csv_to_mysql(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name)
        logger.info(f'Created {name_new_table}')

    def de_hoop_data(self, db_name: str):
        folder_name = 'de_hoop_data'
        file_name = 'PolicydataDeHoop'
        name_new_table = 'DeHoopData'
        self.helpers_conversion.transfer_csv_to_mysql(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name)
        logger.info(f'Created {name_new_table}')

    def create_func(self, db_name: str, func_name: str):
        folder_name = 'functions'
        connection = self.sql.connection(db_name)
        connection.execute('SET GLOBAL log_bin_trust_function_creators = 1;')
        connection.execute(f'DROP FUNCTION IF EXISTS {func_name};')
        self.helpers_sql.execute_requests_funcs(connection=connection, folder_name=folder_name,
                                                provider_name=self.provider_name, file_name=func_name)
        logger.info(f'Created function {func_name}')

    def create_c_tables(self, db_name: str):
        folder_name = 'create_C_tables'
        file_names = ('C_CalcEngine', 'C_CoverType', 'C_Education', 'C_Flags', 'C_Freq', 'C_Occupation', 'C_Status')
        connection = self.sql.connection(db_name)
        for file_name in file_names:
            logger.info(f'Creating {file_name}')
            self.helpers_sql.execute_requests(connection=connection, provider_name=self.provider_name,
                                              folder_name=folder_name, file_name=file_name)
            logger.info(f'Created {file_name}')

    def c_converter(self, db_name: str, db_name_previous_year: str):
        folder_name = 'policydata'

        check_db_term = self.sql.check_database(db_name_previous_year)
        if check_db_term:
            file_names = ('C CONVERTER', 'Generate Policydata_to_Quantum_ORIGINAL_PrevY')
        else:
            file_names = ('C CONVERTER',)

        for file_name in file_names:
            logger.info(f'Creating {file_name}')
            sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                          file_name=file_name)
            for command in sql_commands:
                command = command.format(db_name_previous_year=db_name_previous_year)
                self.sql.connection(db_name).execute(command)
            logger.info(f'Created {file_name}')

    def run(self, db_name: str, db_name_previous_year: str):
        logger.info('Сonversion start')
        self.sql.create_database(db_name)
        self.create_func(db_name=db_name, func_name='PremWoOptions')  # create PremWoOptions function
        self.create_func(db_name=db_name, func_name='AgeNearest')  # create AgeNearest function
        self.create_func(db_name=db_name, func_name='AgeLast')  # create AgeLast function
        self.create_func(db_name=db_name, func_name='AgeNext')  # create AgeNext function
        self.create_func(db_name=db_name, func_name='CalcBeneDur')  # create CalcBeneDur function
        self.create_func(db_name=db_name, func_name='QuantumStatus')  # create QuantumStatus function
        self.create_c_tables(db_name)
        self.de_hoop_data(db_name)
        self.policydata_new_report(db_name)
        self.c_converter(db_name=db_name, db_name_previous_year=db_name_previous_year)
        logger.info('Сonversion end')


