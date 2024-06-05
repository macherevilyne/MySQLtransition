import logging
from sqlalchemy.types import Integer

from main.helpers.sql_connection.helpers import HelpersSQL
from main.helpers.conversion.helpers import HelpersConversion
from main.helpers.sql_connection.sql_connection import Connector

logger = logging.getLogger(__name__)


# converters CSV files to MySQL, tables:
# "Bestandsreport", "Bewegungsreport", "Lapses since inception", "TermsheetReport"
class Conversion:

    def __init__(self):
        self.sql = Connector()
        self.helpers_sql = HelpersSQL()
        self.helpers_conversion = HelpersConversion()
        self.provider_name = 'LIFEWARE'

    def bestandsreport(self, db_name: str):
        folder_name = 'bestandsreport'
        file_name = 'Bestandsreport'
        name_new_table = 'Bestandsreport'
        skiprows = 1
        self.helpers_conversion.transfer_csv_to_mysql(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, skiprows=skiprows)

    def bewegungs_report(self, db_name: str):
        folder_name = 'bewegungs_report'
        file_name = 'Bewegungsreport'
        name_new_table = 'Bewegungsreport'
        skiprows = 1
        self.helpers_conversion.transfer_csv_to_mysql(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name, skiprows=skiprows)

    def lapses_since_inception(self, db_name: str):
        folder_name = 'lapses_since_inception'
        file_name = 'Lapse_report_as_at'
        name_new_table = 'Lapses since inception'
        self.helpers_conversion.transfer_csv_to_mysql(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name)

    def termsheet_report(self, db_name: str):
        folder_name = 'termsheet_report'
        file_name = 'Termsheet_report'
        name_new_table = 'TermsheetReport'
        self.helpers_conversion.transfer_csv_to_mysql(folder_name=folder_name, provider_name=self.provider_name,
                                                      file_name=file_name, name_new_table=name_new_table,
                                                      db_name=db_name)

    def create_func(self, db_name: str, func_name: str):
        folder_name = 'functions'
        connection = self.sql.connection(db_name)
        connection.execute('SET GLOBAL log_bin_trust_function_creators = 1;')
        connection.execute(f'DROP FUNCTION IF EXISTS {func_name};')
        self.helpers_sql.execute_requests_funcs(connection=connection, folder_name=folder_name,
                                                provider_name=self.provider_name, file_name=func_name)
        logger.info(f'Created function {func_name}')

    def run(self, db_name: str):
        logger.info('Сonversion start')
        self.sql.create_database(db_name=db_name)
        self.create_func(db_name=db_name, func_name='AnnualPremium')  # create AnnualPremium function
        self.create_func(db_name=db_name, func_name='CalcAge')  # create CalcAge function
        self.create_func(db_name=db_name, func_name='CalcProduct')  # create CalcProduct function
        self.create_func(db_name=db_name, func_name='CommissionModel')  # create CommissionModel function
        self.create_func(db_name=db_name, func_name='MonetTariff')  # create MonetTariff function
        self.create_func(db_name=db_name, func_name='MonetTariffNew')  # create MonetTariffNew function
        self.create_func(db_name=db_name, func_name='PremiumFreq')  # create PremiumFreq function
        self.create_func(db_name=db_name, func_name='PremiumSum')  # create PremiumSum function
        self.create_func(db_name=db_name, func_name='ReinsuranceModel')  # create ReinsuranceModel function
        self.create_func(db_name=db_name, func_name='TypeOfPremium')  # create TypeOfPremium function
        self.bestandsreport(db_name=db_name)
        self.bewegungs_report(db_name=db_name)
        self.lapses_since_inception(db_name=db_name)
        self.termsheet_report(db_name=db_name)
        logger.info('Сonversion end')
