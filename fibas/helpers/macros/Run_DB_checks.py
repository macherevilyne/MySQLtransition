import logging

from main.helpers.sql_connection.sql_connection import Connector
from fibas.helpers.conversion.conversion import read_config
logger = logging.getLogger(__name__)


# Run macros Run DB checks
class DBchecks:

    def __init__(self):
        self.sql = Connector()
        self.provider_name = 'FIBAS'

    def delete_table(self, db_name, new_db_name):
        config = read_config()
        base_path = config['client'].get('base_path')
        folder_name = 'delete'
        file = 'DBP00 - Delete DBP error table.sql'
        self.sql.execute_macros(folder_name=folder_name, provider_name=self.provider_name,
                                file_name=file, db_name=db_name, base_path=base_path, new_db_name=new_db_name)

    def check(self, db_name, new_db_name):
        folder_name = 'checks'
        file_name = [
            'DBP01 - Check policy number.sql',
            'DBP02 - Check Quantum status.sql',
            'DBP03 - Check Premium payment.sql',
            'DBP04 - Check commencement date.sql',
            'DBP05 - Check product.sql',
            'DBP06 - Check date of birth.sql',
            'DBP07 - Check sex.sql',
            'DBP08 - Check mental diseases.sql',
            'DBP09 - Check professional class.sql',
            'DBP10 - Check waiting time.sql',
            'DBP11 - Check benefit_duration.sql',
            'DBP12 - Check benefit_duration_term_life.sql',
            'DBP13 - Check total_term.sql',
            'DBP14 - Check insurance_amount.sql',
            'DBP15 - Check RP_commencement_date.sql',
            'DBP16 - Check RP insurance amount.sql',
            'DBP17 - Check RP premium.sql',
            'DBP18 - Check RP net premium.sql',
            'DBP19 - Check RP premium FIB.sql',
            'DBP20 - Check RP net premium FIB.sql',
            'DBP21 - Check SP term.sql',
            'DBP22 - Check SP premium.sql',
            'DBP23 - Check SP net premium.sql',
            'DBP24 - Check SP premium FIB.sql',
            'DBP25 - Check SP net premium FIB.sql',
            'DBP26 - Check SP insurance amount.sql',
            'DBP27 - Check En Block 2011.sql',
            'DBP28 - Check cover code.sql',
            'DBP29 - Check cancellation date.sql',
            'DBP30 - Check policy terms.sql',
            'DBP31 - Check product group.sql',
            'DBP32 - Check indexation type.sql',
            'DBP33 - Check indexation percentage.sql',
            'DBP34 - Check WW.sql',
            'DBP35 - Check Benefit duration WW.sql',
            'DBP36 - Check Insured amount WW.sql',
            'DBP37 - Check rate_type.sql'
        ]

        for file in file_name:
            config = read_config()
            base_path = config['client'].get('base_path')
            logger.info(f'Run file {file}')
            self.sql.execute_macros(folder_name=folder_name, provider_name=self.provider_name,
                                    file_name=file, db_name=db_name,base_path=base_path, new_db_name=new_db_name)

    def run(self, db_name, new_db_name):
        self.delete_table(db_name, new_db_name=new_db_name)
        self.check(db_name, new_db_name=new_db_name)
        logger.info(f'End macros "Run DB checks" for {db_name}')
