from django import forms

from .models import New_product, ConversionFileNewProduct


class AddNewProductForm(forms.ModelForm):
    title = forms.CharField(required=True, label='Type in the product name')
    files_count = forms.IntegerField(required=True, label='Choose the number of files for the conversion')
    file_names = forms.CharField(required=True, label='Type in filenames')

    class Meta:
        model = New_product
        fields = ['title', 'files_count', 'file_names']


class ConversionFileNewProductForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        product = kwargs.pop('product', None)
        file_names = kwargs.pop('file_names', [])
        self.files_count = kwargs.pop('files_count', 0)
        super().__init__(*args, **kwargs)

        if product and file_names:
            # Проверяем, что file_names это список строк
            if isinstance(file_names, str):
                file_names = file_names.split(',')

            # Создаем столько полей, сколько указано в files_count
            for i in range(self.files_count):
                # Назначаем метку из file_names, если она есть, иначе используем дефолтную
                file_label = file_names[i] if i < len(file_names) else f'File {i + 1}'
                self.fields[f'file_{i}'] = forms.FileField(
                    label=file_label.strip(),  # Убираем лишние пробелы
                    required=False
                )

    class Meta:
        model = ConversionFileNewProduct
        fields = []

    def clean(self):
        cleaned_data = super().clean()

        # Создаем список для хранения имен файлов
        self.uploaded_file_names = []

        for i in range(self.files_count):
            file_field = cleaned_data.get(f'file_{i}')
            if file_field:
                # Добавляем имя файла в список
                self.uploaded_file_names.append(file_field.name)


        # Выводим список имен файлов
        print(self.uploaded_file_names, 'uploaded_file_names')

        return cleaned_data