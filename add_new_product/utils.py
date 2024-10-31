import os
import re
import datetime
from dateutil.relativedelta import relativedelta
from django.core.exceptions import ValidationError

from main.helpers.conversion.helpers import read_config

# Validate files names

def validate_file_names_new_product(value, correct_name):
    for file_name in correct_name:
        if not validate_filename_for_file(value=file_name, correct_name=correct_name):
            raise ValidationError(f"Invalid file name: {file_name}")
        validate_filename_for_file(value=value, correct_name=correct_name)

# Validate files names

def validate_filename_for_file(value, correct_name: str):
    filename = os.path.splitext(value.name)[0]
    filename = filename.replace(' ', '_')
    print(filename, 'FILE_NAME')
    if correct_name.lower() not in filename.lower():
        raise ValidationError(f'Invalid file. Required "{correct_name}"')

# path folder

def new_product_path_name(instance, filename):
    file_folder_name = 'conversion'
    provider_name = instance.new_product.title  # Извлекаем название продукта
    path = _get_path_name_new_product(
        filename=filename,
        file_folder_name=file_folder_name,
        provider_name=provider_name
    )
    return path

# path base_path

def _get_path_name_new_product(filename, file_folder_name, provider_name):
    config = read_config()
    base_path = config['client'].get('base_path')
    path = get_path_name_input_new_product(filename=filename, file_folder_name=file_folder_name, provider_name=provider_name, base_path=base_path)
    return path

# Full path for save files in directory

def get_path_name_input_new_product(filename, file_folder_name: str, provider_name: str, base_path: str):
    folder_name = create_name_database_with_date_new_product(filename=filename, database_name=provider_name)
    path_name_input = os.path.join(base_path,'Products', provider_name,'input', folder_name, file_folder_name, str(filename))
    return path_name_input


# Creating database name

def create_name_database_with_date_new_product(filename, database_name: str):
    year, month, day = re.findall(r'\d+', filename)
    # minus 1 month
    date = datetime.date(int(year), int(month), int(day)) - relativedelta(months=1)
    year, month, day = datetime.datetime.strptime(str(date), '%Y-%M-%d').strftime('%Y,%M,%d').split(',')
    print(database_name, 'database_name!!!')
    db_name = database_name.upper()
    result = f'{db_name}_{year[2:]}{month}'
    return result