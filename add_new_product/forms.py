from django import forms
from os import path

from django.core.exceptions import ValidationError

from .models import New_product, ObjectsNewProduct, Parameters
from .utils import validate_filename_for_file


class ClearableFileInput(forms.ClearableFileInput):
    def get_context(self, name, value, attrs):
        if value:
            value.name = path.basename(value.name)
            print(value)
        context = super().get_context(name, value, attrs)
        return context

# Form creating new products

class AddNewProductForm(forms.ModelForm):
    title = forms.CharField(required=True, label='Type in the product name')
    files_count = forms.IntegerField(required=True, label='Choose the number of files for the conversion')
    file_names = forms.CharField(required=True, label='Type in filenames')

    tables_count = forms.IntegerField(required=True, label='Choose the number of tables for the conversion')
    table_names = forms.CharField(required=True, label='Type in tables names')

    class Meta:
        model = New_product
        fields = ['title', 'files_count', 'file_names', 'tables_count', 'table_names'  ]




# Dynamic form , conversion of csv files to a database.
# Creates as many file conversion fields as were specified when creating the product
# Validate files names

class ConversionFileNewProductForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        product = kwargs.pop('product', None)
        file_names = kwargs.pop('file_names', [])
        self.files_count = kwargs.pop('files_count', 0)
        self.table_names = kwargs.pop('table_names', [])  # Получаем table_names из kwargs
        self.tables_count = kwargs.pop('tables_count', 0)  # Получаем tables_count из kwargs
        current_files = kwargs.pop('current_files', [])
        super().__init__(*args, **kwargs)

        print(
            f"Debug: Initializing form with product={product}, file_names={file_names}, files_count={self.files_count}")

        table_name_choices = []
        if product and file_names:
            # Проверяем, что file_names это список строк
            if isinstance(file_names, str):
                file_names = file_names.split(',')
            if self.table_names and isinstance(self.table_names, str):
                self.table_names = self.table_names.split(',')
            # Создаем столько полей, сколько указано в files_count
            for i in range(self.files_count):
                # Назначаем метку из file_names, если она есть, иначе используем дефолтную
                file_label = file_names[i] if i < len(file_names) else f'File {i + 1}'
                current_file = current_files[i] if i < len(current_files) else None
                print(file_label, 'FILE LABEL')
                print(f"Debug: Adding field file_{i} with label {file_label.strip()}")
                self.fields[f'file_{i}'] = forms.FileField(
                    label=file_label.strip(),  # Убираем лишние пробелы
                    widget=ClearableFileInput,
                    required=False,
                    initial=current_file  # Устанавливаем начальное значение поля
                )

                file_label = file_names[i] if i < len(file_names) else f'File {i + 1}'
                self.fields[f'table_name_{i}'] = forms.ChoiceField(
                    label=f'Table for {file_label.strip()}',
                    choices=[(name, name) for name in self.table_names],
                    required=False
                )
    class Meta:
        model = ObjectsNewProduct
        fields = []

    def clean(self):
        cleaned_data = super().clean()

        # Создаем список для хранения имен файлов
        self.uploaded_file_names = []
        self.selected_table_names = []

        for i in range(self.files_count):
            file_field = cleaned_data.get(f'file_{i}')
            if file_field:
                # Добавляем имя файла в список
                self.uploaded_file_names.append(file_field.name)

                # Проверка, что файл имеет расширение .csv
                extension = file_field.name.split('.')[-1].lower()
                if extension != 'csv':
                    raise ValidationError(f'The file "{file_field.name}" is not a CSV file.')

                # Получаем ожидаемое имя файла из метки поля
                correct_name = self.fields[f'file_{i}'].label.strip()  # Ожидаемое имя файла
                validate_filename_for_file(value=file_field, correct_name=correct_name)

        # Считываем выбранные таблицы
        for j in range(self.tables_count):
            table_field = cleaned_data.get(f'table_name_{j}')
            if table_field:
                self.selected_table_names.append(table_field)

        print(self.uploaded_file_names, 'uploaded_file_names')
        print(self.selected_table_names, 'selected_table_names')

        return cleaned_data


class NewProductParametersForm(forms.ModelForm):
    val_dat = forms.DateTimeField(
        widget=forms.DateTimeInput(
                attrs={
                    'placeholder': 'DD/MM/YYYY',
                    'required': 'required'
                },
                format='%d/%m/%Y'
            ),
        input_formats=['%d/%m/%Y']
    )

    class Meta:
        model = Parameters
        fields = ['val_dat', 'product_type', 'max_disable']
