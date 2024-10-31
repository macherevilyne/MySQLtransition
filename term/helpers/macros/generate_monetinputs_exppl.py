import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL
from main.helpers.conversion.helpers import read_config

logger = logging.getLogger(__name__)


# Run macros Generate Monet Inputs ExpPL
class GenerateMonetInputsExpPL:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'TERM'

    def generate_monet_inputs_exppl(self, folder_name: str, file_name: str, date_data_extract: str,
                                    val_dat: str, fib_reinsured: str, db_name: str, monet_inputs_previous_year: str, base_path:str, new_db_name:str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, base_path=base_path, db_name=db_name, new_db_name=new_db_name)
        for command in sql_commands:
            command = command.format(ValDat=val_dat, date_data_extract=date_data_extract,
                                     fib_reinsured=fib_reinsured, monet_inputs_previous_year=monet_inputs_previous_year)
            self.sql.connection(db_name).execute(command)

    def run(self, db_name, date_data_extract, val_dat, fib_reinsured, monet_inputs_previous_year, new_db_name):
        config = read_config()
        base_path = config['client'].get('base_path')

        folder_name = 'monet_inputs'
        file_names = [
            'Generate Monet Inputs Previous year.sql',
            'Generate MonetInputs (newBiz).sql',
            'Generate MonetInputs (ExpectedPL).sql',
            'Append NB MonetInputs (ExpectedPL).sql',
            'Update MonetInputs (ExpectedPL).sql',
        ]
        logger.info(f'Start macros "Generate Monet Inputs ExpPL" for {db_name}')
        for file in file_names:

            logger.info(f'Run file {file}')
            self.generate_monet_inputs_exppl(folder_name=folder_name, file_name=file,
                                             date_data_extract=date_data_extract, val_dat=val_dat,
                                             fib_reinsured=fib_reinsured, db_name=db_name,
                                             monet_inputs_previous_year=monet_inputs_previous_year, base_path=base_path,new_db_name=new_db_name)
        logger.info(f'End macros "Generate Monet Inputs ExpPL" for {db_name}')

