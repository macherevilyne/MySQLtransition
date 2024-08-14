import os
import re
import datetime
from dateutil.relativedelta import relativedelta
from django.core.exceptions import ValidationError

# а тут проверка загружаемых файлов с файлами продукта
def validate_filename(value, correct_name: str):
    filename = os.path.splitext(value.name)[0]
    filename = filename.replace(' ', '_')
    if correct_name.lower() not in filename.lower():
        raise ValidationError(f'Invalid file. Required "{correct_name}"')


def validate_file_names_new_product(value):
    correct_name = '' # должны быть список файлов при создании продукта
    validate_filename(value=value, correct_name=correct_name)



def create_name_database_with_date_add_new_product(filename, database_name: str):
    year, month, day = re.findall(r'\d+', filename)
    # minus 1 month
    date = datetime.date(int(year), int(month), int(day)) - relativedelta(months=1)
    year, month, day = datetime.datetime.strptime(str(date), '%Y-%M-%d').strftime('%Y,%M,%d').split(',')
    print(database_name, 'database_name!!!')
    db_name = database_name.upper()
    print(db_name, 'DB_NAME!!!')
    result = f'{db_name}_{year[2:]}{month}'
    return result


def get_path_name_input_add_new_product(filename, provider_name):
    folder_name = create_name_database_with_date_add_new_product(filename=filename, database_name=provider_name)
    path_name_input = os.path.join('Products', provider_name, 'input', folder_name, str(filename))
    return path_name_input