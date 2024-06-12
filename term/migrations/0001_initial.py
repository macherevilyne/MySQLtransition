# Generated by Django 4.1.6 on 2024-02-16 14:23

import django.core.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import term.storage
import term.utils


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='ExecuteMacros',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('db_name', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='ExecuteSql',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('db_name', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Term',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(editable=False, max_length=50, unique=True)),
                ('slug', models.SlugField(unique=True)),
                ('date_upload', models.DateTimeField(default=django.utils.timezone.now)),
                ('policydata_new_report', models.FileField(blank=True, default=None, max_length=500, null=True, storage=term.storage.OverwriteStorage(), upload_to=term.utils.policydata_new_report_path_name, validators=[django.core.validators.FileExtensionValidator(['csv']), term.utils.validate_filename_policydata_new_report])),
                ('de_hoop_data', models.FileField(blank=True, default=None, max_length=500, null=True, storage=term.storage.OverwriteStorage(), upload_to=term.utils.de_hoop_data_path_name, validators=[django.core.validators.FileExtensionValidator(['csv']), term.utils.validate_filename_de_hoop_data])),
            ],
            options={
                'verbose_name_plural': 'Term',
            },
        ),
        migrations.CreateModel(
            name='UserMacros',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name_macros', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='UserSql',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('query', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='UserMacrosSql',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('order', models.IntegerField(blank=True, null=True)),
                ('user_macros', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='term.usermacros')),
                ('user_sql', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='term.usersql')),
            ],
            options={
                'ordering': ['order'],
            },
        ),
        migrations.AddField(
            model_name='usermacros',
            name='user_sql',
            field=models.ManyToManyField(through='term.UserMacrosSql', to='term.usersql'),
        ),
        migrations.CreateModel(
            name='Parameters',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('val_dat', models.DateTimeField(verbose_name='ValDat')),
                ('date_data_extract', models.DateTimeField(verbose_name='DateDataExtract')),
                ('fib_reinsured', models.CharField(choices=[('Y', 'Y'), ('N', 'N')], default='Y', max_length=3)),
                ('val_dat_old', models.DateTimeField(blank=True, default=None, null=True)),
                ('term', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='term.term')),
            ],
            options={
                'verbose_name_plural': 'Parameters',
            },
        ),
    ]
