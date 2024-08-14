import logging

from main.helpers.sql_connection.helpers import HelpersSQL
from main.helpers.conversion.helpers import HelpersConversion
from main.helpers.sql_connection.sql_connection import Connector
import configparser


logger = logging.getLogger(__name__)


# converters CSV files to MySQL, tables: "ClaimsBasic", "Claims", "ClaimsPolicy", "Policies"
# creates SQL functions "CheckList" and "ClaimsStatus"
# creates additional table "SpecialPartialTable"
def read_config(config_file='config.ini'):
    config = configparser.ConfigParser()
    config.read(config_file)
    return config

class Conversion:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.helpers_conversion = HelpersConversion()
        self.provider_name = 'FIBAS'
        self.config = read_config()
        self.base_path = self.config['client'].get('base_path')

    def claims_basic(self, db_name: str):
        file_folder_name = 'claims_basic'
        file_name = 'ClaimBasisOverzicht'
        name_new_table = 'claimsbasic'

        logger.info(f'Creating {name_new_table}')
        self.helpers_conversion.transfer_csv_to_mysql(file_folder_name=file_folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, base_path=self.base_path)

        logger.info(f'Created {name_new_table}')

    def claims(self, db_name: str):
        file_folder_name = 'claims'
        file_name = 'Reserveringen'
        name_new_table = 'claims'

        logger.info(f'Creating {name_new_table}')
        self.helpers_conversion.transfer_csv_to_mysql(file_folder_name=file_folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, base_path=self.base_path)
        logger.info(f'Created {name_new_table}')

    def claims_policy(self, db_name: str):
        file_folder_name = 'claims_policy'
        file_name = 'PolisnummerPerClaim'
        name_new_table = 'claimspolicy'
        logger.info(f'Creating {name_new_table}')
        self.helpers_conversion.transfer_csv_to_mysql(file_folder_name=file_folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, base_path=self.base_path)
        logger.info(f'Created {name_new_table}')

    def policies(self, db_name: str):
        file_folder_name = 'policies'
        file_name = 'PremieVerzekeraar'
        name_new_table = 'policies'

        logger.info(f'Creating {name_new_table}')
        self.helpers_conversion.transfer_csv_to_mysql(file_folder_name=file_folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, base_path=self.base_path)
        logger.info(f'Created {name_new_table}')

    def create_func(self, db_name: str, func_name: str):
        folder_name = 'functions'
        connection = self.sql.connection(db_name)

        connection.execute('SET GLOBAL log_bin_trust_function_creators = 1;')
        connection.execute(f'DROP FUNCTION IF EXISTS {func_name};')
        self.helpers_sql.execute_requests_funcs(connection=connection, folder_name=folder_name,
                                                provider_name=self.provider_name, file_name=func_name, base_path=self.base_path)
        logger.info(f'Created function {func_name}')

    def create_special_partal_table(self, db_name: str, new_db_name:str):
        folder_name = 'q_requests'
        file_name = 'Generate SpecialPartialTable.sql'

        logger.info(f'Creating SpecialPartialTable')
        connection = self.sql.connection(db_name)
        connection.execute('DROP TABLE IF EXISTS `SpecialPartialTable`;')
        self.helpers_sql.execute_requests(connection=connection, provider_name=self.provider_name,
                                          folder_name=folder_name, file_name=file_name,db_name=db_name,base_path=self.base_path, new_db_name=new_db_name)
        logger.info(f'Created SpecialPartialTable')


    def run(self, db_name: str, new_db_name:str):
        logger.info('Сonversion start')
        self.sql.create_database(db_name)
        self.create_func(db_name=db_name, func_name='CheckList')  # create CheckList function
        self.create_func(db_name=db_name, func_name='ClaimsStatus')  # create ClaimsStatus function
        self.claims(db_name)
        self.claims_basic(db_name)
        self.create_special_partal_table(db_name, new_db_name=new_db_name)
        self.claims_policy(db_name)
        self.policies(db_name)
        logger.info('Сonversion end')
