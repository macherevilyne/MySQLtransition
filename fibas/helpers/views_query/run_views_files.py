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
from fibas.helpers.conversion.conversion import read_config



def run_view_file(db_name, sql_file, val_dat, product_type, new_db_name):
	connection = connector.connection(db_name=db_name)
	config = read_config()
	base_path = config['client'].get('base_path')

	try:

		sql_commands = helpers_sql.commands_list(folder_name=FOLDER_NAME, provider_name=PROVIDER_NAME, db_name=db_name, base_path=base_path, file_name=sql_file,new_db_name=new_db_name)
		print(sql_commands, )
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

