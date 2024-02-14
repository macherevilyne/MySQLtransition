import os
import re
import datetime
import configparser

from dateutil.relativedelta import relativedelta
from django.core.exceptions import ValidationError


menu = [
    {'title': 'Fibas', 'url_name': 'fibas'},
    {'title': 'Term', 'url_name': 'term'},
    {'title': 'Life Ware', 'url_name': 'lifeware'},
    {'title': 'Jool', 'url_name': 'jool'},
]


class DataMixin:
    paginate_by = 20

    def get_user_context(self, **kwargs):
        context = kwargs
        user_menu = menu.copy()
        context['menu'] = user_menu
        return context


def validate_filename(value, correct_name: str):
    filename = os.path.splitext(value.name)[0]
    filename = filename.replace(' ', '_')
    if correct_name.lower() not in filename.lower():
        raise ValidationError(f'Invalid file. Required "{correct_name}"')


def validate_filename_sftp(file_name: str, correct_name: str):
    filename = os.path.splitext(file_name)[0]
    filename = filename.replace(' ', '_')
    if correct_name.lower() in filename.lower():
        return True
    else:
        return False


def check_files_name(form):
    check_date = ''
    check_names = {}

    for form_name, filename in form.files.dict().items():
        try:
            year, month, day = re.findall(r'\d+', str(filename))

        except:
            try:
                year, month = re.findall(r'\d+', str(filename))
            except:
                return 'File date error.'

        if check_date == '':
            check_date = f'{year[2:]}{month}'
        else:
            date = f'{year[2:]}{month}'
            if check_date != date:
                check_names[form_name] = f'File date error. Need a date {year}-{check_date[2:]}'
            else:
                check_date = date
    return check_names


def check_files_name_update(form, check_date):
    check_names = {}

    for form_name, filename in form.files.dict().items():
        year, month, day = re.findall(r'\d+', str(filename))
        date = datetime.date(int(year), int(month), int(day)) - relativedelta(months=1)
        year, month, day = datetime.datetime.strptime(str(date), '%Y-%M-%d').strftime('%Y,%M,%d').split(',')

        c_date = datetime.date(int(check_date[:2]), int(check_date[2:]), int(day)) + relativedelta(months=1)
        check_year, check_month, day = datetime.datetime.strptime(str(c_date), '%Y-%M-%d').strftime('%Y,%M,%d').split(',')

        if check_date != f'{year[2:]}{month}':
            check_names[form_name] = f'File date error. Need a date 20{check_year[2:]}-{check_month}'
    return check_names


# get date from names file, write date in format YYMM
# return table name "*TABLE NAME*_YYMM"
def create_name_database_with_date(filename, database_name: str):
    year, month, day = re.findall(r'\d+', filename)
    # minus 1 month
    date = datetime.date(int(year), int(month), int(day)) - relativedelta(months=1)
    year, month, day = datetime.datetime.strptime(str(date), '%Y-%M-%d').strftime('%Y,%M,%d').split(',')
    db_name = database_name.upper()
    result = f'{db_name}_{year[2:]}{month}'
    return result


def get_db_name_previous_year(filename, database_name: str):
    year = re.findall(r'\d+', filename)[0][:2]
    year = f'20{year}'
    month = re.findall(r'\d+', filename)[0][2:]
    date = datetime.date(int(year), int(month), 1) - relativedelta(years=1)  # minus 1 year
    year, month, day = datetime.datetime.strptime(str(date), '%Y-%M-%d').strftime('%Y,%M,%d').split(',')
    db_name = database_name.upper()
    result = f'{db_name}_{year[2:]}{month}'
    return result


def get_path_name_input(filename, file_folder_name: str, provider_name: str):
    folder_name = create_name_database_with_date(filename=filename, database_name=provider_name)
    path_name_input = os.path.join('Products', provider_name, 'input', folder_name, file_folder_name, str(filename))
    return path_name_input


class ConnectConfig:

    def __init__(self, service_name: str):
        self.config = configparser.ConfigParser()
        self.file_config = os.path.join(os.getcwd(), 'config.ini')
        self.config.read(self.file_config)
        self.service_name = service_name

    def get_service_val(self, key):
        return self.config[self.service_name][key]
