import logging

from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)


# Run macros "Run Termsheet checks"
class TermsheetChecks:

	def __init__(self):
		self.sql = Connector()
		self.helpers_sql = HelpersSQL()
		self.provider_name = 'LIFEWARE'

	# executes macros "Run Termsheet checks"
	def execute_run_termsheet_checks(self, folder_name: str, file_name: str, db_name: str):
		sql_commands = self.helpers_sql.commands_list(folder_name=folder_name, provider_name=self.provider_name, file_name=file_name)
		for command in sql_commands:
			self.sql.connection(db_name).execute(command)

	def termsheet_checks(self, db_name):
		folder_name = 'checks'
		file_name = [
			'TS 01 - Check tariff symbol.sql',
			'TS 01a - Check double tariff symbol.sql',
			'TS 02 - Check currency.sql',
			'TS 03 - Check mortality table.sql',
			'TS 04 - Check imc type.sql',
			'TS 05 - Check imc_rp.sql',
			'TS 06 - Check imc_sp.sql',
			'TS 07 - Check imcmin.sql',
			'TS 08 - Check imcmax.sql',
			'TS 09 - Check imcincrement.sql',
			'TS 10 - Check imcincrementmin.sql',
			'TS 11 - Check imcincrementmax.sql',
			'TS 12 - Check amc.sql',
			'TS 12a - Check amc slide.sql',
			'TS 13 - Check amcmin.sql',
			'TS 14 - Check amcmax.sql',
			'TS 15 - Check amc base.sql',
			'TS 16 - Check ipc_rp.sql',
			'TS 17 - Check ipc_sp.sql',
			'TS 18 - Check aac.sql',
			'TS 19 - Check aacmin.sql',
			'TS 20 - Check aacmax.sql',
			'TS 21 - Check aac base.sql',
			'TS 22 - Check pf.sql',
			'TS 23 - Check ufc sp amortized.sql',
			'TS 24 - Check ufc sp min amortized.sql',
			'TS 25 - Check ufc sp direct.sql',
			'TS 26 - Check ufc sp min direct.sql',
			'TS 27 - Check ufc rp.sql',
			'TS 28 - Check ufc rp min.sql',
			'TS 29 - Check dur_max_comm.sql',
			'TS 30 - Check rc.sql',
			'TS 31 - Check rc type.sql',
			'TS 32 - Check rpc.sql',
			'TS 33 - Check durpc.sql',
			'TS 34 - Check durec.sql',
			'TS 35 - Check cocy.sql',
			'TS 36 - Check rate_ammort.sql',
			'TS 37 - Check amort table.sql',
			'TS 38 - Check facdeath.sql',
			'TS 39 - Check sc.sql',
			'TS 40 - Check dursc rp.sql',
			'TS 41 - Check dursc sp.sql',
			'TS 42 - Check surrender fee.sql',
		]
		for file in file_name:
			logger.info(f'Run file {file}')
			self.execute_run_termsheet_checks(folder_name=folder_name, file_name=file, db_name=db_name)

	def run(self, db_name):
		self.termsheet_checks(db_name=db_name)
		logger.info(f'End macros "Run Termsheet checks" for {db_name}')
