import logging

from main.helpers.utils.get_file import Files
from main.helpers.sql_connection.sql_connection import Connector
from main.helpers.sql_connection.helpers import HelpersSQL

logger = logging.getLogger(__name__)

PROVIDER_NAME = 'FIBAS'
FOLDER_NAME = 'q_requests'
files = Files()
connector = Connector()
helpers_sql = HelpersSQL()


def run_view_file(db_name, sql_file, val_dat, product_type):
	connection = connector.connection(db_name=db_name)

	try:
		sql_commands = helpers_sql.commands_list(folder_name=FOLDER_NAME, provider_name=PROVIDER_NAME, file_name=sql_file)
		for command in sql_commands:
			command = command.format(ValDat=val_dat, producttype=product_type)
			connection.execute(command)

		result = {'success': 'Query completed successfully'}
		return result
	except Exception as e:
		logger.error(str(e))

		try:
			error_text = str(e.orig)
		except:
			error_text = str(e)

		result = {'error': error_text}
		return result

