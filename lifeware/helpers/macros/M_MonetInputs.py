import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# # Run macros M MonetInputs
# class MMonetInputs:
#
#     def __init__(self):
#         self.sql = Connector()
#         self.helpers_sql = HelpersSQL()
#         self.provider_name = 'LIFEWARE'
#
#     # executes macros M MonetInputs with arguments "ValDat" and "producttype"
#     def execute_monet_inputs(self, folder_name: str, file_name: str, val_dat: str, product_type: str, db_name: str):
#         sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
#                                                       file_name=file_name)
#         if not self.check_special_column(db_name):
#             for command in sql_commands:
#                 command = command.format(ValDat=val_dat, producttype=product_type)
#                 self.sql.connection(db_name).execute(command)
#         else:
#             logger.info(f'Special column condition met in {db_name}. Skipping execution of macros.')
#
#
#
#     def check_special_column(self, db_name):
#         command = f"SELECT COUNT(*) FROM SpecialPartialTable WHERE Special = 'Yes';"
#         check_result = self.sql.connection(db_name).execute(command)
#         result = list(check_result)[0][0]
#         return result > 1
#
#     def check_discount_column(self, db_name):
#         command = f"SELECT COUNT(*) " \
#                   f"FROM information_schema.columns " \
#                   f"WHERE table_schema = '{db_name}' " \
#                   f"AND table_name = 'Policies' " \
#                   f"AND column_name = 'discount';"
#         check_result = self.sql.connection(db_name).execute(command)
#         result = list(check_result)[0][0]
#         if result > 0:
#             return True
#         else:
#             return False
#
#     def run(self, db_name, val_dat, product_type):
#         folder_name = 'mo_net_tables_generate'
#         file_names = [
#             'Generate Monet Inputs Claims Updated.sql',
#             'Generate Monet Inputs PossClaims.sql',
#             'Generate Monet Inputs ExpDisable.sql'
#         ]
#
#         check_discount = self.check_discount_column(db_name=db_name)
#         if check_discount:
#             add_file = 'Generate Monet Inputs (with RI) Updated with DiscountType.sql'
#             file_names.insert(1, add_file)
#         else:
#             add_file = 'Generate Monet Inputs (with RI) Updated.sql'
#             file_names.insert(1, add_file)
#
#         for file in file_names:
#             logger.info(f'Run file {file}')
#             self.execute_monet_inputs(folder_name=folder_name, file_name=file, val_dat=val_dat,
#                                       product_type=product_type, db_name=db_name)
#         logger.info(f'End macros "M MonetInputs" for {db_name}')
