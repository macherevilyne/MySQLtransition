import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros DB_CheckData
class DBCheckData:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.provider_name = 'TERM'

    def db_check_data(self, folder_name: str, file_name: str, db_name: str):
        sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name)
        for command in sql_commands:
            self.sql.connection(db_name).execute(command)

    def run(self, db_name):
        folder_name = 'db_check_data'
        file_names = [
            'DB - Delete DBErrorTable.sql',
            'DB01 - Check policy number.sql',
            'DB02 - Status check.sql',
            'DB03 - Check DOB1.sql',
            'DB05 - Check smoker status 1.sql',
            'DB06 - Check joined lives.sql',
            'DB07 - Check application type.sql',
            'DB08 - Check DOC.sql',
            'DB09 - Check Term (years).sql',
            'DB09a - Check Term Cover.sql',
            'DB10 - Check CalcEngine.sql',
            'DB11 - Check sum assured 1.sql',
            'DB12 - Check type SA1.sql',
            'DB13 - Check annuity 1.sql',
            'DB14 - Check DOB2.sql',
            'DB15 - Check Gender2.sql',
            'DB16 - Check smoker status 2.sql',
            'DB17 - Check sum assured 2.sql',
            'DB18 - Check type SA2.sql',
            'DB19 - Check annuity 2.sql',
            'DB20 - Check TAF premium.sql',
            'DB21 - Check Frequency.sql',
            'DB22 - Check TAF SP.sql',
            'DB23 - Check Quantum premium.sql',
            'DB24 - Check Term Cover.sql',
            'DB26 - Check Quantum SP.sql',
            'DB27 - Check benefit term.sql',
            'DB28 - Check cancel date.sql',
            'DB29 - Check Terminal Illness.sql',
            'DB30 - Check guaranteed loading.sql',
            'DB31 - Check terminal SA1.sql',
            'DB32 - Check option child.sql',
            'DB33 - Check waiver of premium.sql',
            'DB34 - Check option accident.sql',
            'DB35 - Check option surrender.sql',
            'DB99 - Check vanished policies.sql',
        ]
        logger.info(f'Start macros "DB_CheckData" for {db_name}')
        for file in file_names:
            logger.info(f'Run file {file}')
            self.db_check_data(folder_name=folder_name, file_name=file, db_name=db_name)
        logger.info(f'End macros "DB_CheckData" for {db_name}')

