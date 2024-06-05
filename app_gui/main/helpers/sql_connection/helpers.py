import os

from ..utils.get_file import Files


class HelpersSQL:
    def __init__(self):
        self.files = Files()

    # from .sql files get commands for requests in database
    def commands_list(self, folder_name: str, provider_name: str, file_name: str):
        sql_path_folder = self.files.get_folder_sql(folder_name=folder_name, provider_name=provider_name)
        sql_file = self.files.get_file(file_name, sql_path_folder)
        path_file = os.path.join(sql_path_folder, sql_file)
        fd = open(path_file, 'r')
        sql_file = fd.read()
        fd.close()
        sql_commands = sql_file.split(';')
        sql_commands = [sql for sql in sql_commands if sql.strip()]
        return sql_commands

    def execute_requests(self, connection, provider_name, folder_name: str, file_name: str):
        sqls = self.commands_list(folder_name=folder_name, provider_name=provider_name, file_name=file_name)
        for sql in sqls:
            connection.execute(sql)

    def execute_requests_funcs(self, connection, folder_name: str, provider_name: str, file_name: str):
        sql_path_folder = self.files.get_folder_sql(folder_name=folder_name, provider_name=provider_name)
        sql_file = self.files.get_file(file_name, sql_path_folder)
        path_file = os.path.join(sql_path_folder, sql_file)
        fd = open(path_file, 'r')
        sql = fd.read()
        fd.close()
        connection.execute(sql)
