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
from .utils import validate_filename_claims, \
    validate_filename_claims_basic, \
    validate_filename_claims_policy, \
    validate_filename_policies, \
    claims_path_name, \
    claims_basic_path_name, \
    claims_policy_path_name, \
    policies_path_name, \
    monet_result_all_path_name


class Fibas(models.Model):
    title = models.CharField(max_length=50, unique=True, editable=False)
    slug = models.SlugField(unique=True)
    date_upload = models.DateTimeField(default=timezone.now)
    claims = models.FileField(upload_to=claims_path_name, default=None, blank=True, null=True,
                              max_length=500, storage=OverwriteStorage(),
                              validators=[FileExtensionValidator(['csv']), validate_filename_claims])
    claims_basic = models.FileField(upload_to=claims_basic_path_name, default=None, blank=True, null=True,
                                    max_length=500, storage=OverwriteStorage(),
                                    validators=[FileExtensionValidator(['csv']), validate_filename_claims_basic])
    claims_policy = models.FileField(upload_to=claims_policy_path_name,
                                     max_length=500, default=None, blank=True, null=True, storage=OverwriteStorage(),
                                     validators=[FileExtensionValidator(['csv']), validate_filename_claims_policy])
    policies = models.FileField(upload_to=policies_path_name,
                                max_length=500, default=None, blank=True, null=True, storage=OverwriteStorage(),
                                validators=[FileExtensionValidator(['csv']), validate_filename_policies])

    class Meta:
        verbose_name_plural = "Fibas"

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        if self.pk:
            fibas_object = Fibas.objects.get(pk=self.pk)
            if fibas_object.claims != self.claims:
                fibas_object.claims.delete(save=False)

            if fibas_object.claims_basic != self.claims_basic:
                fibas_object.claims_basic.delete(save=False)

            if fibas_object.claims_policy != self.claims_policy:
                fibas_object.claims_policy.delete(save=False)

            if fibas_object.policies != self.policies:
                fibas_object.policies.delete(save=False)
        else:
            database_name = 'FIBAS'
            if self.claims.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.claims.name),
                    database_name=database_name
                )
            elif self.claims_basic.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.claims_basic.name),
                    database_name=database_name
                )
            elif self.claims_policy.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.claims_policy.name),
                    database_name=database_name
                )
            elif self.policies.name:
                self.title = create_name_database_with_date(
                    filename=os.path.basename(self.policies.name),
                    database_name=database_name
                )
            else:
                raise TypeError

            self.slug = slugify(self.title)
        super(Fibas, self).save(*args, **kwargs)


@receiver(pre_delete, sender=Fibas)
def files_delete(sender, instance, **kwargs):
    # Pass false so FileField doesn't save the model.
    instance.claims.delete(False)
    instance.claims_basic.delete(False)
    instance.claims_policy.delete(False)
    instance.policies.delete(False)


PRODUCT_TYPE = (
    ('new', 'new'),
    ('old', 'old'),
)


class Parameters(models.Model):
    val_dat = models.DateTimeField(verbose_name='ValDat')
    val_dat_old = models.DateTimeField(default=None, blank=True, null=True)
    product_type = models.CharField(max_length=3, choices=PRODUCT_TYPE, default="new")
    max_disable = models.IntegerField(default=1)
    fibas = models.OneToOneField(Fibas, on_delete=models.CASCADE)

    class Meta:
        verbose_name_plural = "Parameters"

    def __str__(self):
        return f'{self.fibas} {self.val_dat}'

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


class ExcelFile(models.Model):
    file = models.FileField(upload_to=monet_result_all_path_name, null=True,
                            max_length=500, storage=OverwriteStorage(), validators=[FileExtensionValidator(['xlsx'])])
    fibas = models.OneToOneField(Fibas, on_delete=models.CASCADE)

    class Meta:
        verbose_name_plural = "ExcelFile"

    def __str__(self):
        return f'{self.fibas} {os.path.basename(self.file.name)}'

    def save(self, *args, **kwargs):
        return super(ExcelFile, self).save(*args, **kwargs)


@receiver(pre_delete, sender=ExcelFile)
def files_delete(sender, instance, **kwargs):
    instance.file.delete(False)


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
