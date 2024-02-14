import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros "Run check new"
class CheckNew:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'LIFEWARE'

    # executes macros "Run check new" with arguments "ValDate"
    def execute_run_check_new(self, folder_name: str, file_name: str, val_date: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            command = command.format(ValDate=val_date)
            self.sql.connection(db_name).execute(command)

    def check_new(self, db_name, val_date):
        folder_name = 'checks'
        file_name = [
            '01 Branch check.sql',
            '02 Gender check.sql',
            '03 Start check.sql',
            '04 Birthdate check.sql',
            '05 Contract term check.sql',
            '06 Contribution term check.sql',
            '07 Regular premium check.sql',
            '08 Pay frequency check.sql',
            '09 Single premium check.sql',
            '10 Coverage check.sql',
            '11 Fund reserve check.sql',
            '12 Surrender value check.sql',
            '13 Clawback check.sql',
        ]
        for file in file_name:
            logger.info(f'Run file {file}')
            self.execute_run_check_new(folder_name=folder_name, file_name=file, val_date=val_date, db_name=db_name)

    def run(self, db_name, val_date):
        self.check_new(db_name=db_name, val_date=val_date)
        logger.info(f'End macros "Run check new" for {db_name}')
