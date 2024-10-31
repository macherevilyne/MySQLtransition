import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL
from main.helpers.conversion.helpers import read_config
logger = logging.getLogger(__name__)


# Run macros M MonetInputs
class MMonetInputs:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'FIBAS'

    # executes macros M MonetInputs with arguments "ValDat" and "producttype"
    def execute_monet_inputs(self, folder_name: str,base_path:str, file_name: str, val_dat: str, product_type: str, db_name: str, new_db_name:str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name, db_name=db_name,
                                                 base_path=base_path, file_name=file_name, new_db_name=new_db_name)
        if not self.check_special_column(db_name):
            for command in sql_commands:
                try:
                    logger.info(f'Original command: {command}')

                    command = command.format(ValDat=val_dat, producttype=product_type, new_db_name=new_db_name)
                    logger.info(f'VALDAT: {val_dat}, productType: {product_type}, newDbName: {new_db_name}')
                except KeyError as e:
                    logger.error(f'Missing key in SQL command formatting: {e}')
                    raise
                logger.info(f'Executing SQL command: {command}')
                self.sql.connection(db_name).execute(command)
        else:
            logger.info(f'Special column condition met in {db_name}. Skipping execution of macros.')

    def check_special_column(self, db_name):
        command = f"SELECT COUNT(*) FROM SpecialPartialTable WHERE Special = 'Yes';"
        check_result = self.sql.connection(db_name).execute(command)
        result = list(check_result)[0][0]
        return result > 1

    def check_discount_column(self, db_name):
        command = f"SELECT COUNT(*) " \
                  f"FROM information_schema.columns " \
                  f"WHERE table_schema = '{db_name}' " \
                  f"AND table_name = 'Policies' " \
                  f"AND column_name = 'discount';"
        check_result = self.sql.connection(db_name).execute(command)
        result = list(check_result)[0][0]
        if result > 0:
            return True
        else:
            return False

    def run(self, db_name, val_dat, product_type, new_db_name):
        folder_name = 'mo_net_tables_generate'
        config = read_config()
        base_path = config['client'].get('base_path')
        file_names = [
            'Generate Monet Inputs Claims Updated.sql',
            'Generate Monet Inputs PossClaims.sql',
            'Generate Monet Inputs ExpDisable.sql'
        ]

        check_discount = self.check_discount_column(db_name=db_name)
        if check_discount:
            add_file = 'Generate Monet Inputs (with RI) Updated with DiscountType.sql'
            file_names.insert(1, add_file)
        else:
            add_file = 'Generate Monet Inputs (with RI) Updated.sql'
            file_names.insert(1, add_file)

        for file in file_names:
            logger.info(f'Run file {file}')
            self.execute_monet_inputs(folder_name=folder_name, file_name=file, val_dat=val_dat,
                                      product_type=product_type, db_name=db_name,base_path=base_path, new_db_name=new_db_name )
        logger.info(f'End macros "M MonetInputs" for {db_name}')
