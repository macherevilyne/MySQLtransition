import os
import datetime
from django.db import models
from django.utils import timezone
from .storage import OverwriteStorage
from django.core.validators import FileExtensionValidator

from django.utils.text import slugify

from .utils import new_product_path_name, validate_file_names_new_product, create_name_database_with_date_new_product

# New product
class New_product(models.Model):
    title = models.CharField(max_length=50)
    slug = models.SlugField(unique=True)
    date_upload = models.DateTimeField(default=timezone.now)
    files_count = models.IntegerField(default=1)
    file_names = models.CharField(max_length=250, default='default_filename')


    tables_count = models.IntegerField(default=1)
    table_names = models.CharField(max_length=250, default='default_filename')


    class Meta:
        verbose_name_plural = "Add_new_product"


    def __str__(self):
        return self.title


    def save(self, *args, **kwargs):

        # Генерируем slug из title, если slug не был установлен вручную
        if not self.slug:
            self.slug = slugify(self.title)

        super().save(*args, **kwargs)

# New objects product

class ObjectsNewProduct(models.Model):
    new_product = models.ForeignKey(New_product, on_delete=models.CASCADE, related_name='converted_files')
    title = models.CharField(max_length=50)
    slug = models.SlugField(unique=True)
    date_upload = models.DateTimeField(default=timezone.now)

    def save(self, *args, **kwargs):
        # Устанавливаем title и slug при сохранении, если они еще не заданы
        if not self.title:
            # Получаем название продукта из связанного объекта New_product
            product_title = self.new_product.title
            self.title = create_name_database_with_date_new_product(
                filename="",
                database_name=product_title
            )

        # Генерация slug из title, если slug не был установлен вручную
        if not self.slug:
            self.slug = slugify(self.title)

        super().save(*args, **kwargs)

    def __str__(self):
        return self.title


# Files objects for conversion csv in database

class ConversionFiles(models.Model):
    new_product = models.ForeignKey(New_product, on_delete=models.CASCADE)
    product_object = models.ForeignKey(ObjectsNewProduct, on_delete=models.CASCADE)
    files = models.FileField(
        upload_to=new_product_path_name, default=None, blank=True, null=True,
        max_length=500, storage=OverwriteStorage(),
        validators=[FileExtensionValidator(['csv']), validate_file_names_new_product]
    )
    table_name = models.CharField(max_length=50, blank=True)


    def save(self, *args, **kwargs):
        # Если объект уже существует, проверим, был ли изменен файл
        if self.pk:
            current_instance = ConversionFiles.objects.get(pk=self.pk)
            if current_instance.files != self.files:
                current_instance.files.delete(save=False)

        # Сохраняем объект
        super().save(*args, **kwargs)

    def __str__(self):
        return  self.files.name



PRODUCT_TYPE = (
    ('new', 'new'),
    ('old', 'old'),
)


class Parameters(models.Model):
    val_dat = models.DateTimeField(verbose_name='ValDat')
    val_dat_old = models.DateTimeField(default=None, blank=True, null=True)
    product_type = models.CharField(max_length=3, choices=PRODUCT_TYPE, default="new")
    max_disable = models.IntegerField(default=1)
    new_product = models.OneToOneField(ObjectsNewProduct, on_delete=models.CASCADE)

    class Meta:
        verbose_name_plural = "Parameters"

    def __str__(self):
        return f'{self.new_product} {self.val_dat}'

    def save(self, *args, **kwargs):
        datetime_now = datetime.datetime.now()
        hour = datetime_now.hour
        minute = datetime_now.minute
        second = datetime_now.second
        year = self.val_dat.year
        month = self.val_dat.month
        day = self.val_dat.day
        time_for_date = '{year}-{month}-{day} {hour}:{minute}:{second}'.format(year=year,
                                                                               month=month,
                                                                               day=day,
                                                                               hour=hour,
                                                                               minute=minute,
                                                                               second=second)
        time_format = datetime.datetime.strptime(time_for_date, '%Y-%m-%d %H:%M:%S')
        self.val_dat = time_format
        return super(Parameters, self).save(*args, **kwargs)
