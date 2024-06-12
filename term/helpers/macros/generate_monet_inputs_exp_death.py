import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros Generate Monet Inputs Exp Death
class GenerateMonetInputsExpDeath:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'TERM'

    def execute_generate_monet_inputs_exp_death(self, folder_name: str, file_name: str, date_data_extract: str,
                                                val_dat: str, fib_reinsured: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            command = command.format(ValDat=val_dat, date_data_extract=date_data_extract, fib_reinsured=fib_reinsured)
            self.sql.connection(db_name).execute(command)

    def run(self, db_name, date_data_extract, val_dat, fib_reinsured):
        folder_name = 'monet_inputs'
        file_names = [
            'Generate Monet inputs ExpDeath.sql',
        ]
        logger.info(f'Start macros "Generate Monet Inputs Exp Death" for {db_name}')
        for file in file_names:
            logger.info(f'Run file {file}')
            self.execute_generate_monet_inputs_exp_death(folder_name=folder_name, file_name=file,
                                                         date_data_extract=date_data_extract, val_dat=val_dat,
                                                         fib_reinsured=fib_reinsured, db_name=db_name)
        logger.info(f'End macros "Generate Monet Inputs Exp Death" for {db_name}')
