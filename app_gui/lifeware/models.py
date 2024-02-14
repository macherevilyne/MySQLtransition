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
from .utils import validate_filename_bestandsreport, \
    validate_filename_bewegungs_report, validate_filename_lapses_since_inception, \
    validate_filename_termsheet_report, bestandsreport_path_name, \
    bewegungs_report_path_name, lapses_since_inception_path_name, termsheet_report_path_name


class LifeWare(models.Model):
    title = models.CharField(max_length=50, unique=True, editable=False)
    slug = models.SlugField(unique=True)
    date_upload = models.DateTimeField(default=timezone.now)
    bestandsreport = models.FileField(upload_to=bestandsreport_path_name, default=None, blank=True, null=True,
                                      max_length=500, storage=OverwriteStorage(),
                                      validators=[FileExtensionValidator(['csv']), validate_filename_bestandsreport])
    bewegungs_report = models.FileField(upload_to=bewegungs_report_path_name, default=None, blank=True, null=True,
                                        max_length=500, storage=OverwriteStorage(),
                                        validators=[FileExtensionValidator(['csv']),
                                                    validate_filename_bewegungs_report])
    lapses_since_inception = models.FileField(upload_to=lapses_since_inception_path_name,
                                              max_length=500, default=None, blank=True, null=True,
                                              storage=OverwriteStorage(),
                                              validators=[FileExtensionValidator(['csv']),
                                                          validate_filename_lapses_since_inception])
    termsheet_report = models.FileField(upload_to=termsheet_report_path_name,
                                        max_length=500, default=None, blank=True, null=True, storage=OverwriteStorage(),
                                        validators=[FileExtensionValidator(['csv']),
                                                    validate_filename_termsheet_report])

    class Meta:
        verbose_name_plural = "LifeWare"

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        if self.pk:
            fibas_object = LifeWare.objects.get(pk=self.pk)
            if fibas_object.bestandsreport != self.bestandsreport:
                fibas_object.bestandsreport.delete(save=False)

            if fibas_object.bewegungs_report != self.bewegungs_report:
                fibas_object.bewegungs_report.delete(save=False)

            if fibas_object.lapses_since_inception != self.lapses_since_inception:
                fibas_object.lapses_since_inception.delete(save=False)

            if fibas_object.termsheet_report != self.termsheet_report:
                fibas_object.termsheet_report.delete(save=False)
        else:
            database_name = 'LIFEWARE'
            if self.bestandsreport.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.bestandsreport.name),
                    database_name=database_name
                )
            elif self.bewegungs_report.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.bewegungs_report.name),
                    database_name=database_name
                )
            elif self.lapses_since_inception.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.lapses_since_inception.name),
                    database_name=database_name
                )
            elif self.termsheet_report.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.termsheet_report.name),
                    database_name=database_name
                )
            else:
                raise TypeError

            self.slug = slugify(self.title)
        super(LifeWare, self).save(*args, **kwargs)


@receiver(pre_delete, sender=LifeWare)
def files_delete(sender, instance, **kwargs):
    # Pass false so FileField doesn't save the model.
    instance.bestandsreport.delete(False)
    instance.bewegungs_report.delete(False)
    instance.lapses_since_inception.delete(False)
    instance.termsheet_report.delete(False)


PRODUCT_TYPE = (
    ('new', 'new'),
    ('old', 'old'),
)


class Parameters(models.Model):
    val_date = models.DateTimeField(verbose_name='ValDate')
    val_date_old = models.DateTimeField(default=None, blank=True, null=True)
    life_ware = models.OneToOneField(LifeWare, on_delete=models.CASCADE)

    class Meta:
        verbose_name_plural = "Parameters"

    def __str__(self):
        return f'{self.life_ware} {self.val_date}'

    def save(self, *args, **kwargs):
        datetime_now = datetime.datetime.now()
        hour = datetime_now.hour
        minute = datetime_now.minute
        second = datetime_now.second
        year = self.val_date.year
        month = self.val_date.month
        day = self.val_date.day
        time_for_date = '{year}-{month}-{day} {hour}:{minute}:{second}'.format(year=year,
                                                                               month=month,
                                                                               day=day,
                                                                               hour=hour,
                                                                               minute=minute,
                                                                               second=second)
        time_format = datetime.datetime.strptime(time_for_date, '%Y-%m-%d %H:%M:%S')
        self.val_date = time_format
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

