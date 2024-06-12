import os
import logging

from os import listdir
from os.path import isfile, join

logger = logging.getLogger(__name__)


class Files:

    # search name files
    def get_file(self, file_name: str, path_folder: str):
        only_files = [f for f in listdir(path_folder) if isfile(join(path_folder, f))]
        for file in only_files:
            if file_name in file:
                return file
        try:
            file = only_files[0]
            return file
        except:
            logger.info(f'get_file > only_files: {only_files}')
            raise OSError(2, 'No such file or directory')

    # get the folder where files are uploaded
    def get_input_folder(self, folder_name: str, provider_name: str, db_name: str) -> str:
        input_folder = os.path.join(os.getcwd(), 'data', 'Products', provider_name, 'input', db_name, folder_name)
        return input_folder

    # get folder with sql files
    def get_folder_sql(self, folder_name: str, provider_name: str) -> str:
        folder = os.path.join(os.getcwd(), 'data', 'Products', provider_name, 'SQLscripts', folder_name)
        return folder
