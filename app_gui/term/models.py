import os
import datetime

from django.db import models
from django.db.models.signals import pre_delete
from django.dispatch.dispatcher import receiver
from django.core.validators import FileExtensionValidator
from django.utils import timezone
from django.utils.text import slugify
from django.db import transaction

from main.utils import create_name_database_with_date
from .storage import OverwriteStorage
from .utils import policydata_new_report_path_name, \
    de_hoop_data_path_name, \
    validate_filename_policydata_new_report, \
    validate_filename_de_hoop_data


class Term(models.Model):
    title = models.CharField(max_length=50, unique=True, editable=False)
    slug = models.SlugField(unique=True)
    date_upload = models.DateTimeField(default=timezone.now)
    policydata_new_report = models.FileField(upload_to=policydata_new_report_path_name,
                                             default=None, blank=True,
                                             null=True, max_length=500,
                                             storage=OverwriteStorage(),
                                             validators=[FileExtensionValidator(['csv']),
                                                         validate_filename_policydata_new_report])

    de_hoop_data = models.FileField(upload_to=de_hoop_data_path_name,
                                    default=None, blank=True,
                                    null=True, max_length=500,
                                    storage=OverwriteStorage(),
                                    validators=[FileExtensionValidator(['csv']),
                                                validate_filename_de_hoop_data])

    class Meta:
        verbose_name_plural = "Term"

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        if self.pk:
            term_object = Term.objects.get(pk=self.pk)
            if term_object.policydata_new_report != self.policydata_new_report:
                term_object.policydata_new_report.delete(save=False)
            elif term_object.de_hoop_data != self.de_hoop_data:
                term_object.de_hoop_data.delete(save=False)
        else:
            database_name = 'TERM'
            if self.policydata_new_report.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.policydata_new_report.name),
                    database_name=database_name
                )
            elif self.de_hoop_data.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.de_hoop_data.name),
                    database_name=database_name
                )
            else:
                raise TypeError

            self.slug = slugify(self.title)
        super(Term, self).save(*args, **kwargs)


@receiver(pre_delete, sender=Term)
def files_delete(sender, instance, **kwargs):
    # Pass false so FileField doesn't save the model.
    instance.policydata_new_report.delete(False)
    instance.de_hoop_data.delete(False)


FIB_REINSURED_TYPE = (
    ('Y', 'Y'),
    ('N', 'N'),
)


class Parameters(models.Model):
    val_dat = models.DateTimeField(verbose_name='ValDat')
    date_data_extract = models.DateTimeField(verbose_name='DateDataExtract')
    fib_reinsured = models.CharField(max_length=3, choices=FIB_REINSURED_TYPE, default="Y")
    val_dat_old = models.DateTimeField(default=None, blank=True, null=True)
    term = models.OneToOneField(Term, on_delete=models.CASCADE)

    class Meta:
        verbose_name_plural = "Parameters"

    def __str__(self):
        return f'{self.term} {self.val_dat}'

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


class UserSql(models.Model):
    name = models.CharField(max_length=255)
    query = models.TextField()

    def __str__(self):
        return self.name


class ExecuteSql(models.Model):
    db_name = models.CharField(max_length=100)

    def __str__(self):
        return self.db_name


class UserMacros(models.Model):
    name_macros = models.CharField(max_length=200)
    user_sql = models.ManyToManyField('UserSql', through='UserMacrosSql', through_fields=('user_macros', 'user_sql'))

    def __str__(self):
        return self.name_macros


class UserMacrosSql(models.Model):
    user_macros = models.ForeignKey(UserMacros, on_delete=models.CASCADE)
    user_sql = models.ForeignKey(UserSql, on_delete=models.CASCADE)
    order = models.IntegerField(blank=True, null=True)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f'{self.user_macros} - {self.user_sql}'


class ExecuteMacros(models.Model):
    db_name = models.CharField(max_length=100)

    def __str__(self):
        return self.db_name


@receiver(pre_delete, sender=UserSql)
def delete_related_macros(sender, instance, **kwargs):
    related_macros_sql = UserMacrosSql.objects.filter(user_sql=instance)
    with transaction.atomic():
        for macros_sql in related_macros_sql:
            macros_sql.user_macros.delete()


@receiver(pre_delete, sender=UserMacrosSql)
def delete_related_macros(sender, instance, **kwargs):
    related_sql = UserMacrosSql.objects.filter(user_macros=instance.user_macros)

    if not related_sql.exists():
        instance.user_macros.delete()
