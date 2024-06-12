import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros Generate Monet Inputs Term
class GenerateMonetInputsTerm:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()

    def execute_generate_monet_inputs_term(self, folder_name: str, provider_name: str, file_name: str,
                                           date_data_extract: str, default_date: str, fib_reinsured: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            command = command.format(default_date=default_date, date_data_extract=date_data_extract,
                                     fib_reinsured=fib_reinsured)
            self.sql.connection(db_name).execute(command)

    def run(self, db_name, date_data_extract, fib_reinsured):
        folder_name = 'monet_inputs'
        provider_name = 'TERM'
        file_names = [
            'Generate monet inputs Term.sql',
        ]
        logger.info(f'Start macros "Monet Inputs Term" for {db_name}')
        default_date = '01-01-1901'
        for file in file_names:
            logger.info(f'Run file {file}')
            self.execute_generate_monet_inputs_term(folder_name=folder_name, provider_name=provider_name,
                                                    file_name=file, date_data_extract=date_data_extract,
                                                    default_date=default_date, fib_reinsured=fib_reinsured,
                                                    db_name=db_name)
        logger.info(f'End macros "Monet Inputs Term" for {db_name}')
