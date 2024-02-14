import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros "Run check"
class Check:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'FIBAS'

    # executes macros "Run check" with arguments "MaxDisable"
    def execute_run_check(self, folder_name: str, file_name: str, max_disable: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            command = command.format(MaxDisable=max_disable)
            self.sql.connection(db_name).execute(command)

    def delete_table(self, db_name):
        folder_name = 'delete'
        file_name = '00 - Delete error table.sql'
        self.sql.execute_macros(folder_name=folder_name, provider_name=self.provider_name,
                                file_name=file_name, db_name=db_name)

    def check(self, max_disable, db_name):
        folder_name = 'checks'
        file_name = [
            '01 - FIBAS status check.sql',
            '02 - Status check.sql',
            '03 - Product check.sql',
            '04 - Book check.sql',
            '05 - Age check.sql',
            '06 - Term check.sql',
            '07 - Waiting time check.sql',
            '08 - Benefit duration check.sql',
            '09 - Premium frequency check.sql',
            '10 - Sum assured check.sql',
            '11 - Start time monthly premium check.sql',
            '12 - Single premium check.sql',
            '13 - Monthly premium check.sql',
            '14 - Disability definition check.sql',
            '15 - Benefit definition check.sql',
            '16 - Period disable check.sql',
            '17 - Percentage disable check.sql',
            '18 - Monthly benefit check.sql',
            '19 - Occurrence year check.sql'
        ]
        for file in file_name:
            logger.info(f'Run file {file}')
            self.execute_run_check(folder_name=folder_name, file_name=file, max_disable=max_disable, db_name=db_name)

    def run(self, max_disable, db_name):
        self.delete_table(db_name=db_name)
        self.check(max_disable=max_disable, db_name=db_name)
        logger.info(f'End macros "Run Check" for {db_name}')
