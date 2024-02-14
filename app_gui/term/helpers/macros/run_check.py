import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros Run check
class RunCheck:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'TERM'

    def run_check(self, folder_name: str, file_name: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            self.sql.connection(db_name).execute(command)

    def run(self, db_name):
        folder_name = 'run_check'
        file_names = [
            '00 Delete error table.sql',
            '01 Age of Life 1 check.sql',
            '02 Gender of Life 1 check.sql',
            '03 Smoker Status of Life 1 check.sql',
            '04 SA of Life 1 check.sql',
            '05 Type of cover Life 1 check.sql',
            '06 Annuity rate Life 1 check.sql',
            '07 Age of Life 2 check.sql',
            '08 Gender of Life 2 check.sql',
            '09 Smoker Status of Life 2 check.sql',
            '10 SA of Life 2 check.sql',
            '11 Type of cover Life 2 check.sql',
            '12 Annuity rate Life 2 check.sql',
            '13 Term of cover check.sql',
            '14 Payment freq check.sql',
            '15 Recurring premium check.sql',
            '16 Single premium check.sql',
            '17 Recurring premium in Single premium Policy.sql',
        ]
        logger.info(f'Start macros "Run check" for {db_name}')
        for file in file_names:
            logger.info(f'Run file {file}')
            self.run_check(folder_name=folder_name, file_name=file, db_name=db_name)
        logger.info(f'End macros "Run check" for {db_name}')

