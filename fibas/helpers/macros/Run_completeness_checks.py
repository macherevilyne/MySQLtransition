import logging

from main.helpers.sql_connection.sql_connection import Connector

logger = logging.getLogger(__name__)
from fibas.helpers.conversion.conversion import read_config

# Run macros Run completeness checks
class CompletenessChecks:

    def __init__(self):
        self.sql = Connector()
        self.provider_name = 'FIBAS'

    def delete_table(self, db_name):
        folder_name = 'delete'
        file = 'C0 - Delete completeness table.sql'
        config = read_config()
        base_path = config['client'].get('base_path')

        self.sql.execute_macros(folder_name=folder_name, provider_name=self.provider_name,
                                file_name=file, db_name=db_name, base_path=base_path)

    def check(self, db_name):
        folder_name = 'checks'
        file_name = [
            'C1 - FIBAS completeness regular.sql',
            'C3 - FIBAS completeness claims.sql',
            'C4 - FIBAS completeness payments.sql'
        ]
        for file in file_name:
            config = read_config()
            base_path = config['client'].get('base_path')

            logger.info(f'Run file {file}')
            self.sql.execute_macros(folder_name=folder_name, provider_name=self.provider_name,
                                    file_name=file, db_name=db_name, base_path=base_path)

    def run(self, db_name):
        self.delete_table(db_name=db_name)
        self.check(db_name=db_name)

