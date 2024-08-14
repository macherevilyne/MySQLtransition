import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL
from fibas.helpers.conversion.conversion import read_config
logger = logging.getLogger(__name__)


# Run macros Generate Monet Inputs Term
class GenerateMonetInputs:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'TERM'

    def execute_generate_monet_inputs(self, folder_name: str,  file_name: str,
                                           date_data_extract: str, val_dat: str, default_date: str, fib_reinsured: str, db_name: str,new_db_name:str, base_path:str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, db_name=db_name, base_path=base_path, new_db_name=new_db_name)
        for command in sql_commands:
            command = command.format(ValDat=val_dat,default_date=default_date, date_data_extract=date_data_extract,
                                     fib_reinsured=fib_reinsured,new_db_name=new_db_name)
            logger.info(f'Executing SQL command: {command}')
            self.sql.connection(db_name).execute(command)

    def run(self, db_name, date_data_extract, fib_reinsured, val_dat,new_db_name):
        config = read_config()
        base_path = config['client'].get('base_path')
        folder_name = 'monet_inputs'
        file_names = [
            'Generate monet inputs FIBAS.sql',
            'Generate monet inputs Term.sql',
            'Generate Monet inputs ExpDeath.sql'
        ]
        logger.info(f'Start macros "Monet Inputs " for {db_name}')
        default_date = '01-01-1901'
        for file in file_names:
            logger.info(f'Run file {file}')
            self.execute_generate_monet_inputs(folder_name=folder_name,
                                                    file_name=file, date_data_extract=date_data_extract, val_dat=val_dat,
                                                    default_date=default_date, fib_reinsured=fib_reinsured,
                                                    db_name=db_name,new_db_name=new_db_name, base_path=base_path)
        logger.info(f'End macros "Monet Inputs" for {db_name}')
