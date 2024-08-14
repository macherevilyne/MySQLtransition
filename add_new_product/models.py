import os

from django.db import models
from django.utils import timezone
from .storage import OverwriteStorage
from django.core.validators import FileExtensionValidator
from add_new_product.utils import get_path_name_input_add_new_product, validate_file_names_new_product
from django.utils.text import slugify


class New_product(models.Model):
    title = models.CharField(max_length=50)
    slug = models.SlugField(unique=True)
    date_upload = models.DateTimeField(default=timezone.now)
    files_count = models.IntegerField(default=1)
    file_names = models.CharField(max_length=250, default='default_filename')


    class Meta:
        verbose_name_plural = "Add_new_product"

    def save(self, *args, **kwargs):
        # Генерируем slug из title, если slug не был установлен вручную
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.title

class ConversionFileNewProduct(models.Model):
    new_product = models.ForeignKey(New_product, on_delete=models.CASCADE, related_name='converted_files')
    files = models.FileField(upload_to=get_path_name_input_add_new_product, default=None, blank=True, null=True,
                             max_length=500, storage=OverwriteStorage(),
                             validators=[FileExtensionValidator(['csv']),validate_file_names_new_product])

    def __str__(self):
        return os.path.basename(self.files.name)