import os
import re
import datetime
import configparser
import shutil

from dateutil.relativedelta import relativedelta
from django.core.exceptions import ValidationError
from django.urls import reverse
from django.conf import settings
from add_new_product.models import New_product



def get_menu():
    latest_product_titles = New_product.objects.order_by('-id').values_list('title', flat=True)
    menu = [
        {'title': 'Fibas', 'url_name': reverse('fibas')},  # Пример статического URL
        {'title': 'Term', 'url_name': reverse('term')},
        {'title': 'Life Ware', 'url_name': reverse('lifeware')},
        {'title': 'Jool', 'url_name': reverse('jool')},
    ]
    for title in latest_product_titles:
        url = reverse('new_product', kwargs={'title': title})
        menu.append({'title': title, 'url_name': url})
    return menu

class DataMixin:
    paginate_by = 20

    def get_user_context(self, **kwargs):
        context = kwargs
        user_menu = get_menu()  # Получаем актуальное меню с помощью функции get_menu
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
    print(database_name, 'database_name!!!')
    db_name = database_name.upper()
    print(db_name, 'DB_NAME!!!')
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



def get_path_name_input(filename, file_folder_name: str, provider_name: str, base_path: str):
    folder_name = create_name_database_with_date(filename=filename, database_name=provider_name)
    path_name_input = os.path.join(base_path,'Products', provider_name,'input', folder_name, file_folder_name, str(filename))
    return path_name_input


'''Moving files. If the files are in a temporary folder, they are moved to the database folder '''

def move_query_file(query_instance):
    if not query_instance.fibas:
        return
    provider_name = 'FIBAS'
    original_file_path = query_instance.query_file.path
    new_folder_path = os.path.join(settings.MEDIA_ROOT, 'Products', provider_name, 'input', query_instance.fibas.title, 'upload_queries')
    new_file_path = os.path.join(new_folder_path, os.path.basename(original_file_path))

    if original_file_path == new_file_path:
        print("Файл уже находится в нужном месте.")
        return query_instance

    try:
        if not os.path.exists(new_folder_path):
            os.makedirs(new_folder_path)

        try:

            if 'temp' in original_file_path:
                if os.path.exists(new_file_path):
                    timestamp = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
                    base_filename, file_extension = os.path.splitext(os.path.basename(original_file_path))
                    new_filename = f"{base_filename}_{timestamp}{file_extension}"
                    new_file_path = os.path.join(new_folder_path, new_filename)
                    query_instance.file_name = new_filename
                    query_instance.save()
                shutil.move(original_file_path, new_file_path)
            else:
                shutil.copy(original_file_path, new_file_path)

        except shutil.SameFileError:
            print("Попытка переместить файл в его текущее расположение.")

        relative_path = os.path.relpath(new_file_path, settings.MEDIA_ROOT)
        query_instance.query_file.name = relative_path
        query_instance.save()
        return query_instance

    except PermissionError:
        print('Нет доступа к файлу. Возможно, он занят другим процессом')


''' Delete query from path '''

def delete_query_file(query_instance):
    file_path = query_instance.query_file.path
    if os.path.exists(file_path):
        os.remove(file_path)

class ConnectConfig:

    def __init__(self, service_name: str):
        self.config = configparser.ConfigParser()
        self.file_config = os.path.join(os.getcwd(), 'config.ini')
        self.config.read(self.file_config)
        self.service_name = service_name

    def get_service_val(self, key):
        return self.config[self.service_name][key]
