import re
import os
import io
import logging
import shutil
from copy import deepcopy
from django.contrib.sessions.models import Session
from django.contrib.sessions.backends.db import SessionStore
from main.helpers.conversion.helpers import read_config
from django.conf import settings
from django.utils import timezone
import sqlparse
import sqlvalidator
import paramiko

from os import listdir
from os.path import isfile, join
from datetime import datetime
from stat import S_ISDIR

from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.db.models import Q
from django.http import HttpResponseRedirect
from django.views import View
from django.http import Http404, HttpResponse, JsonResponse
from django.views.generic import ListView, CreateView, UpdateView
from django.urls import reverse_lazy, reverse
from django.shortcuts import render, redirect, get_object_or_404
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.core.files.uploadedfile import SimpleUploadedFile
from django.contrib import messages
from main.utils import DataMixin, ConnectConfig, check_files_name, \
    create_name_database_with_date, check_files_name_update, get_path_name_input
from main.helpers.sql_connection.sql_connection import Connector

from .models import Fibas, Parameters, ExcelFile, UserSql, UserMacros, UserMacrosSql, \
    UserQuery, ExecuteQuery, User_Custom_Macros, UserCustomMacrosSql
from .forms import AddFilesConversionForm, ParametersForm, ExcelFileForm, UserSqlForm, \
    ExecuteSqlForm, UserMacrosForm, ExecuteMacrosForm, ExecuteQueryForm, UserQueryForm, UserCustomMacrosForm, \
    ExecuteCustomMacrosForm
from .helpers.conversion.conversion import Conversion
from .helpers.conversion.conversion_excel import ConversionExcel
from .helpers.macros.Run_DB_checks import DBchecks
from .helpers.macros.M_MonetInputs import MMonetInputs
from .helpers.macros.Run_check import Check
from .helpers.views_query.run_views_files import run_view_file
from .utils import validate_filename_claims_sftp, validate_filename_claims_basic_sftp, \
    validate_filename_claims_policy_sftp, validate_filename_policies_sftp
from app_gui.settings import MEDIA_ROOT


# from main.utils import get_path_name_input_queries
from main.utils import move_query_file

from main.utils import delete_query_file

logger = logging.getLogger(__name__)

DATABASE_NAME = 'FIBAS'


# start page FIBAS
class FibasView(ListView, DataMixin):
    model = Fibas
    template_name = 'fibas/fibas_index.html'
    context_object_name = 'fibas'
    success_url = reverse_lazy('fibas')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['fibases'] = Fibas.objects.order_by('title')
        c_def = self.get_user_context(title='Fibas page')
        return dict(list(context.items()) + list(c_def.items()))


# CSV file upload page
# with verification of the correctness of the file name and their upload fields
class UploadView(CreateView, DataMixin):
    form_class = AddFilesConversionForm
    template_name = 'fibas/fibas_add_files.html'
#
    def get_success_url(self):
        return reverse('fibas_parameters_entry', kwargs={'pk': self.object.pk})

    # Validate forms
    def form_valid(self, form):
        if form.is_valid():
            check_names = check_files_name(form=form)
            if check_names:
                return self.render_to_response(self.get_context_data(form=form, check_names=check_names))

            try:
                try:
                    self.object = form.save()
                    return redirect(self.get_success_url())
                except TypeError:
                    logger.info(f'self.object {self.object}')
                    error_message = 'The form cannot be empty'
                    logger.info(error_message)
                    return self.render_to_response(self.get_context_data(form=form,
                                                                         check_names=check_names,
                                                                         error_message=error_message))
            except IntegrityError as e:
                if 'UNIQUE'.lower() in str(e).lower() or 'Duplicate'.lower() in str(e).lower():
                    logger.info('Such database already exist')
                    error_message = 'Such database already exist'
                    return self.render_to_response(self.get_context_data(form=form,
                                                                         check_names=check_names,
                                                                         error_message=error_message))
            return self.render_to_response(self.get_context_data(form=form, check_names=check_names))
        logger.error('Upload csv form isn\'t valid')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['pk'] = self.kwargs.get('pk')
        c_def = self.get_user_context(title=f'Add files')
        return dict(list(context.items()) + list(c_def.items()))


# Action selection page:
# - Updating CSV files in the database
# - Input of the ValDat and product type parameters
# - Running macros
# - Launching the views
class DatabasePageView(ListView, DataMixin):
    model = Fibas
    template_name = 'fibas/fibas_database.html'
    success_url = reverse_lazy('fibas_database')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            fibas = Fibas.objects.get(id=pk)
            title = fibas.title
            # check db fibas in MySQL
            check_db_fibas = sql.check_database(title)


            if check_db_fibas:
                claims = sql.check_table(db_name=title, table_name='Claims')
                claims_basic = sql.check_table(db_name=title, table_name='ClaimsBasic')
                claims_policy = sql.check_table(db_name=title, table_name='ClaimsPolicy')
                policies = sql.check_table(db_name=title, table_name='Policies')
                special_partial_table = sql.check_table(db_name=title, table_name='SpecialPartialTable')
                check_table_monet_inputs = sql.check_tables(db_name=title, table_name='MonetInputs')
                context['claims'] = claims
                context['claims_basic'] = claims_basic
                context['claims_policy'] = claims_policy
                context['policies'] = policies
                context['special_partial_table'] = special_partial_table
                context['check_table_monet_inputs'] = check_table_monet_inputs
            context['pk'] = pk
            context['fibas'] = fibas
            context['check_db_fibas'] = check_db_fibas
            c_def = self.get_user_context(title=title)
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# CSV file update page in db
# checking the names of uploaded files
class FibasUpdateView(UpdateView, DataMixin):
    model = Fibas
    form_class = AddFilesConversionForm
    template_name = 'fibas/fibas_update_files.html'
    context_object_name = 'fibas'

    def get_success_url(self):
        return reverse('fibas_database', kwargs={'pk': self.kwargs.get('pk')})

    # Validate forms
    def form_valid(self, form):
        if form.is_valid():
            obj_name = Fibas.objects.get(id=self.object.pk)
            print(obj_name, 'ojb name fibas')
            obj_date = re.findall(r'\d+', str(obj_name))
            print(obj_date, 'ojb date fibas')

            check_names = check_files_name_update(form=form, check_date=obj_date[0])
            if check_names:
                return self.render_to_response(self.get_context_data(form=form, check_names=check_names))
            else:
                self.object = form.save()
                return redirect(self.get_success_url())
        logger.error('Update csv form isn\'t valid')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Fibas.objects.filter(id=pk).exists():
            fibas = Fibas.objects.get(id=pk)
            title = fibas.title
            context['pk'] = pk
            c_def = self.get_user_context(title=f'Fibas update {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Input/update page for the ValDat and product type parameters
# with checks:
# - correct input of ValDat
# - existence of ValDat in the database, if there is updates
class ParametersView(CreateView, DataMixin):
    model = Parameters
    form_class = ParametersForm
    template_name = 'fibas/fibas_parameters_entry.html'
    allow_empty = False

    def form_valid(self, form):
        form.instance.fibas_id = self.kwargs.get('pk')
        pk = form.instance.fibas_id
        if Parameters.objects.filter(fibas=pk).exists():
            parameters = Parameters.objects.get(fibas=pk)
            parameters.product_type = form.instance.product_type
            parameters.val_dat_old = parameters.val_dat
            parameters.val_dat = form.instance.val_dat
            parameters.max_disable = form.instance.max_disable
            parameters.Fibas = pk
            parameters.save()
        else:
            self.object = form.save()

        return redirect(self.get_success_url())

    def get_success_url(self):
        return reverse('fibas_database', kwargs={'pk': self.kwargs.get('pk')})

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Fibas.objects.filter(id=pk).exists():
            fibas = Fibas.objects.get(id=pk)
            title = fibas.title
            context['pk'] = self.kwargs.get('pk')
            c_def = self.get_user_context(title=f'Parameters Entry {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Macros Launch Page
class MacrosView(ListView, DataMixin):
    model = Fibas
    template_name = 'fibas/fibas_macros.html'
    success_url = reverse_lazy('fibas_macros')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            f = Fibas.objects.get(id=pk)
            title = f.title
            if Parameters.objects.filter(fibas=f).exists():
                check_db_fibas = sql.check_database(title)
                claims = sql.check_table(db_name=title, table_name='Claims')
                claims_basic = sql.check_table(db_name=title, table_name='ClaimsBasic')
                claims_policy = sql.check_table(db_name=title, table_name='ClaimsPolicy')
                policies = sql.check_table(db_name=title, table_name='Policies')
                special_partial_table = sql.check_table(db_name=title, table_name='SpecialPartialTable')
                if check_db_fibas and claims and claims_basic and claims_policy and policies and special_partial_table:
                    check_table_monet_inputs = Connector().check_tables(db_name=title, table_name='MonetInputs')
                    context['pk'] = self.kwargs.get('pk')
                    context['db_name'] = title
                    c_def = self.get_user_context(title=f'Macros {title}',
                                                  check_table_monet_inputs=check_table_monet_inputs)
                    return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Views Launch Page
class QueriesView(ListView, DataMixin):
    model = Fibas
    template_name = 'fibas/fibas_queries.html'
    success_url = reverse_lazy('fibas')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Fibas.objects.filter(id=pk).exists():
            f = Fibas.objects.get(id=pk)
            title = f.title
            query = self.request.GET.get('query')
            list_only_files = self.view_only_files(query=query)
            context['list_only_files'] = list_only_files
            if Parameters.objects.filter(fibas=f).exists():
                list_only_files = self.view_only_files(query)
                page = self.request.GET.get('page', 1)
                paginator = Paginator(list_only_files, 10)
                try:
                    list_only_files = paginator.page(page)
                except PageNotAnInteger:
                    list_only_files = paginator.page(1)
                except EmptyPage:
                    list_only_files = paginator.page(paginator.num_pages)

                context['list_only_files'] = list_only_files
                context['pk'] = self.kwargs.get('pk')
                c_def = self.get_user_context(title=f'Queries {title}')
                return dict(list(context.items()) + list(c_def.items()))
        raise Http404()

    def view_only_files(self,query ) -> list:
        provider_name = 'FIBAS'
        folder_name = 'q_requests'
        config = read_config()
        base_path = config['client'].get('base_path')
        path_folder = os.path.join(os.getcwd(), base_path, 'Products', provider_name, 'SQLscripts', folder_name)
        only_files = sorted([f for f in listdir(path_folder) if isfile(join(path_folder, f))])
        if query:
            only_files = [file for file in only_files if query.lower() in file.lower()]

        return only_files



class QueryView(ListView, DataMixin):
    model = Fibas
    template_name = 'fibas/fibas_query.html'
    success_url = reverse_lazy('fibas')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        sql_file = self.kwargs.get('sql_file')

        if Fibas.objects.filter(id=pk).exists():
            context['pk'] = pk
            context['sql_file'] = sql_file

            c_def = self.get_user_context(title=f'Query {sql_file}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()

    def view_only_files(self, query=None) -> list:
        provider_name = 'FIBAS'
        folder_name = 'q_requests'
        path_folder = os.path.join(os.getcwd(), 'data', 'Products', provider_name, 'SQLscripts', folder_name)
        only_files = sorted([f for f in listdir(path_folder) if isfile(join(path_folder, f))])
        return only_files

    def post(self, request, pk, sql_file):
        if Fibas.objects.filter(id=pk).exists():
            f = Fibas.objects.get(id=pk)
            provider_name = 'FIBAS'
            folder_name = 'q_requests'
            path_folder = os.path.join(os.getcwd(), 'data', 'Products', provider_name, 'SQLscripts', folder_name, sql_file)
            title = f.title
            if "_" in title:
                prefix, date_part = title.split("_", 1)
                new_db_name = f"fibas_{date_part}"
            else:
                new_db_name = "fibas"
            parameters = Parameters.objects.get(fibas=pk)
            val_dat = parameters.val_dat
            product_type = parameters.product_type
            result_run_view_file = run_view_file(db_name=title, sql_file=sql_file,
                                                 val_dat=val_dat, product_type=product_type, new_db_name=new_db_name)

            # If there are no errors when executing the standard query. Creating a new UserQuery object
            if 'error' not in result_run_view_file:
                user_query = UserQuery.objects.create(
                    file_name=sql_file,
                    query_file =path_folder,
                    fibas=f,  # Связываем с объектом Fibas
                    applied_at=timezone.now()
                )
                user_query.save()
            context = {'result': result_run_view_file}
            context.update(self.get_user_context(title=f'Query {sql_file}'))
            return render(request, self.template_name, context)
        raise Http404()


class UploadExcelView(CreateView, DataMixin):
    model = ExcelFile
    form_class = ExcelFileForm
    template_name = 'fibas/fibas_upload_excel_file.html'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            fibas = Fibas.objects.get(id=pk)
            title = fibas.title
            check_file_monet_input = ExcelFile.objects.filter(fibas=pk).exists()
            context['pk'] = pk
            context['check_file_monet_input'] = check_file_monet_input
            c_def = self.get_user_context(title=f'Upload "MonetResultsAll" {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()

    def form_valid(self, form):
        form.instance.fibas_id = self.kwargs.get('pk')
        pk = form.instance.fibas_id
        if ExcelFile.objects.filter(fibas=pk).exists():
            excel_file = ExcelFile.objects.get(fibas=pk)
            excel_file.file = form.instance.file
            excel_file.Fibas = pk
            excel_file.save()
        else:
            self.object = form.save()
        return redirect(self.get_success_url())

    def get_success_url(self):
        return reverse('fibas_upload_excel_file', kwargs={'pk': self.kwargs.get('pk')})


@csrf_exempt
def convert_monet_results_all(request, pk):
    if request.method == 'POST':
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            f = Fibas.objects.get(id=pk)
            filename = os.path.basename(f.claims.name)
            db_name = create_name_database_with_date(filename=filename, database_name=DATABASE_NAME)
            parameters = Parameters.objects.get(fibas=pk)
            val_dat_old = parameters.val_dat_old

            if val_dat_old:
                date = val_dat_old
            else:
                date = parameters.val_dat

            # Make a backup there is a table exists
            table_name = 'MonetResultsAll'
            if sql.check_table(db_name=db_name, table_name=table_name):
                sql.backup_table(db_name=db_name, table_name=table_name, date=date)

            config = read_config()
            base_path = config['client'].get('base_path')


            ConversionExcel().monet_results_all(db_name, base_path)
            response = 'Done'
            return HttpResponse(response)
    raise Http404()


# Converting CSV files to a database
@csrf_exempt
def data_conversion(request, pk):
    if request.method == 'POST':
        if Fibas.objects.filter(id=pk).exists():
            f = Fibas.objects.get(id=pk)
            filename = os.path.basename(f.claims.name)
            db_name = create_name_database_with_date(filename=filename, database_name=DATABASE_NAME)
            Connector().create_database(db_name)

            try:
                if "_" in db_name:
                    prefix, date_part = db_name.split("_", 1)
                    new_db_name = f"fibas_{date_part}"
                else:
                    new_db_name = "fibas"
                Conversion().run(db_name, new_db_name=new_db_name)
                print(db_name, 'DB_NAME' )
            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()


# Running a macros Run DBchecks
@csrf_exempt
def run_db_checks(request, pk):
    if request.method == 'POST':
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            f = Fibas.objects.get(id=pk)
            claims_name = os.path.basename(f.claims.name)
            db_name = create_name_database_with_date(filename=claims_name, database_name=DATABASE_NAME)
            parameters = Parameters.objects.get(fibas=pk)
            val_dat_old = parameters.val_dat_old

            if val_dat_old:
                date = val_dat_old
            else:
                date = parameters.val_dat

            # Make a backup there is a table exists
            table_name = 'DBPErrorTable'
            if sql.check_table(db_name=db_name, table_name=table_name):
                sql.backup_table(db_name=db_name, table_name=table_name, date=date)

            try:
                if "_" in db_name:
                    prefix, date_part = db_name.split("_", 1)
                    new_db_name = f"fibas_{date_part}"
                else:
                    new_db_name = "fibas"
                DBchecks().run(db_name, new_db_name=new_db_name)
            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()


# Running a macros Run M_MonetInputs
@csrf_exempt
def run_m_monetinputs(request, pk):
    if request.method == 'POST':
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            f = Fibas.objects.get(id=pk)
            if Parameters.objects.filter(fibas=f).exists():
                claims_name = os.path.basename(f.claims.name)
                db_name = create_name_database_with_date(filename=claims_name, database_name=DATABASE_NAME)

                val_dat = datetime.strptime(str(f.parameters.val_dat.date()), '%Y-%m-%d').strftime('%d-%m-%Y')
                print(val_dat, 'VAL_DAT')
                product_type = f.parameters.product_type
                parameters = Parameters.objects.get(fibas=pk)
                val_dat_old = parameters.val_dat_old

                if "_" in db_name:
                    prefix, date_part = db_name.split("_", 1)
                    new_db_name = f"fibas_{date_part}"
                else:
                    new_db_name = "fibas"

                print(new_db_name, 'new_db_name')
                if val_dat_old:
                    date = val_dat_old
                else:
                    date = parameters.val_dat

                # Make a backup there is a table exists
                table_name = 'MonetInputsUpdated'
                if sql.check_tables(db_name=db_name, table_name=table_name):
                    sql.backup_table(db_name=db_name, table_name=table_name, date=date)

                try:
                    MMonetInputs().run(db_name, val_dat, product_type, new_db_name)
                    if MMonetInputs().check_special_column(db_name):
                        response = 'Warning!Macros are suspended until the situation is resolved. Column with Special = «Yes» have >1.'
                        logger.info(response)
                        return HttpResponse(response)
                    else:
                        response = 'Done'
                        return HttpResponse(response)
                except Exception as e:
                    response = str(e)
                    logger.error(response)
                    return HttpResponse(response)



            response = 'Error'
            return HttpResponse(response)
    raise Http404()


# Running a macros Run Check
@csrf_exempt
def run_check(request, pk):
    if request.method == 'POST':
        if Fibas.objects.filter(id=pk).exists():
            sql = Connector()
            f = Fibas.objects.get(id=pk)
            claims_name = os.path.basename(f.claims.name)
            db_name = create_name_database_with_date(filename=claims_name, database_name=DATABASE_NAME)
            parameters = Parameters.objects.get(fibas=pk)
            val_dat_old = parameters.val_dat_old
            max_disable = parameters.max_disable
            if val_dat_old:
                date = val_dat_old
            else:
                date = parameters.val_dat

            # Make a backup there is a table exists
            table_name = 'ErrorTable'
            if sql.check_table(db_name=db_name, table_name=table_name):
                sql.backup_table(db_name=db_name, table_name=table_name, date=date)

            try:
                if "_" in db_name:
                    prefix, date_part = db_name.split("_", 1)
                    new_db_name = f"fibas_{date_part}"
                else:
                    new_db_name = "fibas"
                Check().run(max_disable=max_disable, db_name=db_name, new_db_name=new_db_name)
            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()


# Running all macros
@csrf_exempt
def run_all_macros(request, pk):
    if request.method == 'POST':
        if Fibas.objects.filter(id=pk).exists():
            run_db_checks(request, pk)
            run_m_monetinputs(request, pk)
            run_check(request, pk)
            response = 'Done'
            return HttpResponse(response)
    raise Http404()


class AddSqlView(CreateView, DataMixin):
    model = UserSql
    form_class = UserSqlForm
    template_name = 'fibas/fibas_add_sql.html'
    success_url = reverse_lazy('fibas_user_sql_list')

    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        form = self.get_form()
        if form.is_valid():
            self.object = form.save(commit=False)
            query = form.cleaned_data['query']
            sql_query = sqlvalidator.parse(query)

            try:
                is_valid = sql_query.is_valid()
            except:
                is_valid = False

            if not is_valid:
                form.add_error('query', 'Invalid SQL query')
                return self.form_invalid(form)
            return self.form_valid(form)
        else:
            return self.form_invalid(form)

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Add new sql')
        context.update(c_def)
        return context


class EditSqlView(UpdateView, DataMixin):
    template_name = 'fibas/fibas_edit_sql.html'
    model = UserSql
    form_class = UserSqlForm
    success_url = reverse_lazy('fibas_user_sql_list')

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form = self.get_form()
        if form.is_valid():
            query = form.cleaned_data['query']
            sql_query = sqlvalidator.parse(query)
            print(sql_query,  'sql_query')
            if not sql_query.is_valid():
                form.add_error('query', 'Invalid SQL query')
                return self.form_invalid(form)
            return self.form_valid(form)
        else:
            return self.form_invalid(form)

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Edit sql')
        return dict(list(context.items()) + list(c_def.items()))


def delete_sql(request, sql_id):
    sql_delete = UserSql.objects.get(id=sql_id)
    sql_delete.delete()
    return HttpResponseRedirect(reverse_lazy('fibas_user_sql_list'))


class UserSqlListView(ListView, DataMixin):
    model = UserSql
    template_name = 'fibas/fibas_user_sql_list.html'
    context_object_name = 'user_sql_list'
    ordering = ['name']

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'List sql')
        return dict(list(context.items()) + list(c_def.items()))


class ExecuteSqlView(View, DataMixin):
    template_name = 'fibas/fibas_execute_sql.html'

    def get(self, request, sql_id, *args, **kwargs):
        sql = UserSql.objects.get(pk=sql_id)
        form = ExecuteSqlForm()
        context = {'sql': sql, 'form': form}
        context.update(self.get_user_context(title=f'Executing sql'))
        return render(request, self.template_name, context)

    def post(self, request, sql_id, *args, **kwargs):
        sql = UserSql.objects.get(pk=sql_id)
        form = ExecuteSqlForm(request.POST)
        results = None
        if form.is_valid():
            db_name = form.cleaned_data['db_name']
            results = self.execute_query(query=sql.query, db_name=db_name)

        context = {'sql': sql, 'results': results, 'form': form}
        context.update(self.get_user_context(title=f'Executing sql'))
        return render(request, self.template_name, context)

    def execute_query(self, query, db_name):
        sql = Connector()
        connection = sql.connection(db_name=db_name)
        sql_requests = query.split(';')

        try:
            result = {
                'result': 'Query failed'
            }
            results_connection = []
            for sql_request in sql_requests:
                result_connection = connection.execute(sql_request)
                results_connection.append(result_connection)
            if results_connection:
                result = {
                    'result': 'Query completed'
                }
        except Exception as e:
            logger.error(str(e))

            try:
                error_text = str(e.orig)
            except:
                error_text = str(e)

            result = {
                'error': error_text
            }
        finally:
            connection.close()
        return result



'''Loading sql queries. Get - Getting the database and url.
Post - checking for file extensions, reading files, checking for errors in requests, 
saving objects of uploaded requests. When a certain url is received, a list is generated for creating macros.
 '''

class Fibas_upload_query(CreateView, DataMixin):
    model = UserQuery
    form_class = UserQueryForm
    template_name = 'fibas/fibas_upload_query.html'  # Замените на свой шаблон
    success_url = reverse_lazy('fibas_execute_query')

    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

    def get_success_url(self):
        db_name = self.request.GET.get('db_name')
        next_url = self.request.GET.get('next')

        if next_url:
            return next_url
        else:
            return reverse('fibas_execute_query', kwargs={'db_name': db_name, 'query_id': self.object.pk})

    def post(self, request, *args, **kwargs):
        form = self.get_form()
        if form.is_valid():
            self.object = form.save(commit=False)
            query_file = form.cleaned_data['query_file']

            if query_file:
                _, file_extension = os.path.splitext(query_file.name)

                if file_extension.lower() != '.sql':
                    form.add_error('query_file', f'Invalid file "{query_file.name}"  format. Please upload a SQL file')
                    return self.form_invalid(form)

            else:
                form.add_error('query_file', 'Please choose a file')
                return self.form_invalid(form)

            try:
                query_file = form.cleaned_data['query_file']
                file_content = query_file.read().decode('utf-8').strip()

                try:
                    parsed_queries = sqlparse.parse(file_content)
                    for parsed_query in parsed_queries:
                        if any(token.ttype is sqlparse.tokens.Error for token in parsed_query.tokens):
                            form.add_error('query_file', f'Invalid SQL query in "{query_file.name}"')
                            return self.form_invalid(form)

                except Exception as e:
                    form.add_error('query_file', f'Error parsing SQL queries in "{query_file.name}": {e}')
                    return self.form_invalid(form)

                self.object.save()
                file_name = query_file.name
                self.object.file_name = file_name
                self.macros_list = self.request.session.get('macros_list', [])

                next_url = self.request.GET.get('next')
                if next_url:

                    self.macros_list.append(self.object.pk)
                    print(self.macros_list, 'macros-list')
                    self.request.session['macros_list'] = self.macros_list

                return self.form_valid(form)
            except Exception as e:
                print('Exception:', e)
                form.add_error('query_file', f'Error parsing SQL queries in "{query_file.name}": {e}')
                return self.form_invalid(form)

        else:
            return render(request, self.template_name, {'form': form, 'errors': form.errors})




    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Upload new query')
        return dict(list(context.items()) + list(c_def.items()))

'''Used Queries History List. Getting the database. Getting queries filtered by db_name'''

class FibasUserHistoryQueryListView(ListView, DataMixin):
    model = UserQuery
    template_name = 'fibas/fibas_user_query_list.html'
    context_object_name = 'user_query_list'
    ordering = ['-id']
    paginate_by = 15

    def get_queryset(self):

        db_name = self.kwargs.get('db_name')
        query = self.request.GET.get('query')
        queryset = UserQuery.objects.filter(fibas__title=db_name)

        if query:
            queryset = queryset.filter(file_name__icontains=query.lower())

        return queryset.order_by('-id')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        db_name = self.kwargs.get('db_name')
        context['db_name'] = db_name
        c_def = self.get_user_context(title=f'Used Queries History')
        context.update(c_def)
        paginator = context['paginator']
        page = context['page_obj']
        context['is_paginated'] = page.has_other_pages()
        context['prev_url'] = f'?page={page.previous_page_number()}' if page.has_previous() else ''
        context['next_url'] = f'?page={page.next_page_number()}' if page.has_next() else ''
        return dict(list(context.items()) + list(c_def.items()))

'''Executing query. Get - getting UserQuery objects
Post - Getting objects according to db_name.
If there is no error when inserting the query into the database, a UserQuery object is created 
and the file is moved from the temporary folder to the database folder, 
and if there is an error in the query, the file is deleted'''

class ExecuteQueryView(View, DataMixin):
    template_name = 'fibas/fibas_execute_query.html'

    def get(self, request, query_id, *args, **kwargs):
        query = UserQuery.objects.get(pk=query_id)
        form = ExecuteQueryForm()
        context = {'query': query,'form': form}
        context.update(self.get_user_context(title=f'Executing query'))
        return render(request, self.template_name, context)

    def post(self, request, query_id, *args, **kwargs):
        query = UserQuery.objects.get(pk=query_id)
        form = ExecuteQueryForm(request.POST, request.FILES)
        results = None

        if form.is_valid():
            db_name = form.cleaned_data['db_name']
            fibas_object = Fibas.objects.get(title=db_name.title)
            logger.info(f'Run sql query {query}')

            results = self.execute_query(query=query, db_name=db_name)
            logger.info(f'Run sql query {query}')

            if 'error' not in results:
                new_query = UserQuery.objects.create(
                    file_name=query.file_name,
                    query_file=query.query_file,
                    fibas=fibas_object,
                    applied_at=timezone.now()
                )
                new_query.save()
                move_query_file(new_query)
            else:
                delete_query_file(query)
                query.delete()

        context = {'query': query, 'results': results,  'form': form}
        context.update(self.get_user_context(title=f'Executing query'))
        return render(request, self.template_name, context)

    def execute_query(self, query, db_name):
        connector  = Connector()
        connection = connector .connection(db_name=db_name)

        try:
            parameters = Parameters.objects.first()
            val_dat = parameters.val_dat if parameters else None
            result = {
                'result': 'Query failed'
            }
            results_connection = []
            with open(query.query_file.path, 'r') as file:
                query_content = file.read().strip()
            query_requests = query_content.split(';')

            for query_request  in query_requests:
                query_request_with_val_dat = query_request.replace('{ValDat}', str(val_dat))
                result_connection = connection.execute(query_request_with_val_dat )
                results_connection.append(result_connection)
            if results_connection:
                result = {
                    'result': 'Query completed'
                }
            logger.info(f'End sql query for  {db_name}')
        except Exception as e:
            logger.error(str(e))

            try:
                error_text = str(e.orig)
            except:
                error_text = str(e)

            result = {
                'error': error_text
            }
        finally:
            connection.close()
        return result

class CustomMacrosView(ListView, DataMixin):
    model = UserSql
    template_name = 'fibas/fibas_custom_macros.html'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Custom macros')
        return dict(list(context.items()) + list(c_def.items()))

class UserCreateMacrosView(CreateView, DataMixin):
    model = UserMacros
    form_class = UserMacrosForm
    template_name = 'fibas/fibas_user_macros_create.html'
    success_url = reverse_lazy('fibas_user_macros_list')

    def get(self, request, *args, **kwargs):
        form = UserMacrosForm()
        user_sql_objects = UserSql.objects.all()
        context = {'form': form, 'user_sql_objects': user_sql_objects}
        context.update(self.get_user_context(title=f'Create macros'))
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        form = UserMacrosForm(request.POST)
        if form.is_valid():
            user_macros = form.save(commit=False)
            user_macros.save()

            sql_queries = request.POST.getlist('user_sql')
            for order, sql_id in enumerate(sql_queries, start=1):
                user_sql = UserSql.objects.get(pk=sql_id)
                UserMacrosSql.objects.create(user_macros=user_macros, user_sql=user_sql, order=order)

            return redirect('fibas_execute_macros', macros_id=user_macros.pk)
        else:
            error_message = 'One field is required.'
            context = {'form': form, 'user_sql_objects': UserSql.objects.all(), 'error_message': error_message}
            context.update(self.get_user_context(title=f'Create macros'))
            return render(request, self.template_name, context)

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Create macros')
        context.update(c_def)
        return context

'''Creating objects custom macros
Get - Getting db_name, query list dowloding for creating custom macros
Post - Creating custom macros object with query list. Clearing the list after creating a custom macros '''
class UserCreateCustomMacrosView(CreateView, DataMixin):
    model = User_Custom_Macros #
    form_class = UserCustomMacrosForm #
    template_name = 'fibas/fibas_user_custom_macros_create.html'
    success_url = reverse_lazy('fibas_custom_macros_list')
    paginate_by = 15

    def get(self, request, *args, **kwargs):
        db_name = self.kwargs.get('db_name')
        macros_list_ids = self.request.session.get('macros_list', [])
        macros_list_objects = UserQuery.objects.filter(id__in=macros_list_ids)
        paginator = Paginator(macros_list_objects, self.paginate_by) #
        page_number = request.GET.get('page') #
        page_obj = paginator.get_page(page_number)#
        form = UserCustomMacrosForm()
        context = {'form': form, 'user_custom_sql_objects': page_obj, 'db_name': db_name, 'macros_list_objects':macros_list_objects } #
        context.update(self.get_user_context(title=f'Create custom macros'))
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        form = UserCustomMacrosForm(request.POST)

        if form.is_valid():
            user_custom_macros = form.save(commit=False)
            user_custom_macros.save()
            sql_custom_queries = request.POST.getlist('user_query')
            print(sql_custom_queries, 'sql_custom_queries')
            for order, sql_query_id in enumerate(sql_custom_queries, start=1):
                print(order, 'order')
                print(sql_query_id, 'sql_queryID')
                user_query = UserQuery.objects.get(pk=sql_query_id)
                print(user_query, 'user_query')
                UserCustomMacrosSql.objects.create(user_custom_macros=user_custom_macros, user_query=user_query, order=order)
            request.session['macros_list'] = []
            return redirect('execute_custom_macros', macros_id=user_custom_macros.pk)

        else:
            db_name = self.kwargs.get('db_name')
            error_message = 'One field is required.'
            context = {'form': form, 'user_custom_sql_objects': UserQuery.objects.all(), 'error_message': error_message, 'db_name': db_name}#
            context.update(self.get_user_context(title=f'Create custom macros'))
            return render(request, self.template_name, context)

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Create custom macros')
        context.update(c_def)

        return context

class UserMacrosListView(ListView, DataMixin):
    model = UserMacros
    template_name = 'fibas/fibas_user_macros_list.html'
    context_object_name = 'user_macros_list'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Macros List')
        user_macros = UserMacros.objects.all()
        context['user_macros'] = user_macros
        return dict(list(context.items()) + list(c_def.items()))



class EditMacrosView(UpdateView, DataMixin):
    template_name = 'fibas/fibas_edit_macros.html'
    model = UserMacros
    form_class = UserMacrosForm
    success_url = reverse_lazy('fibas_user_macros_list')

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form = self.get_form()
        user_macros = self.object

        if form.is_valid():
            sql_queries = request.POST.getlist('user_sql')
            existing_sql_ids = []
            for order, sql_id in enumerate(sql_queries, start=1):
                user_sql = UserSql.objects.get(pk=sql_id)
                user_macros_sql, created = UserMacrosSql.objects.get_or_create(user_macros=user_macros, user_sql=user_sql)
                user_macros_sql.order = order
                user_macros_sql.save()
                existing_sql_ids.append(user_sql.id)
            UserMacrosSql.objects.filter(user_macros=user_macros).exclude(user_sql__id__in=existing_sql_ids).delete()

            from_page = request.GET.get('from', '')
            if from_page == 'user_macros_list':
                return redirect('fibas_user_macros_list')
            elif from_page == 'execute_macros':
                return redirect(reverse_lazy('fibas_execute_macros', args=[user_macros.id]))
            return redirect('fibas_user_macros_list')
        else:
            user_macros_sql = UserMacrosSql.objects.filter(user_macros=user_macros)
            initial_sql_queries = user_macros_sql.order_by('order').values_list('user_sql__id', flat=True)
            form.fields['user_sql'].initial = initial_sql_queries
            error_message = 'One field is required.'
            context = {'form': form, 'error_message': error_message}
            context.update(self.get_user_context(title='Edit macros'))
            return render(request, self.template_name, context)

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        user_macros = UserMacros.objects.get(pk=self.kwargs['pk'])
        user_macros_sql = UserMacrosSql.objects.filter(user_macros=user_macros)
        initial_sql_queries = user_macros_sql.order_by('order').values_list('user_sql__id', flat=True)
        form = self.get_form()
        form.fields['user_sql'].initial = initial_sql_queries
        context = {'form': form}
        context.update(self.get_user_context(title='Edit macros'))
        return render(request, self.template_name, context)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title='Edit macros')
        return dict(list(context.items()) + list(c_def.items()))


def delete_macros(request, macros_id):
    macros_delete = UserMacros.objects.get(id=macros_id)
    macros_delete.delete()
    return HttpResponseRedirect(reverse_lazy('fibas_user_macros_list'))

'''Deleting a query from a creating custom macros and database. 
Updating the query list when creating a custom macros '''

def delete_custom_macros_query(request, query_id):
    macros_list_ids = request.session.get('macros_list', [])
    db_name = request.GET.get('db_name', None)
    user_query = get_object_or_404(UserQuery, id=query_id)

    if query_id in macros_list_ids:
        macros_list_ids.remove(query_id)
        request.session['macros_list'] = macros_list_ids
        user_query.delete()

    return redirect(reverse('fibas_create_custom_macros', kwargs={'db_name': db_name}))

class ExecuteMacrosView(View, DataMixin):
    template_name = 'fibas/fibas_execute_macros.html'

    def get(self, request, macros_id, *args, **kwargs):
        form = ExecuteMacrosForm()
        user_macros = UserMacros.objects.get(pk=macros_id)
        user_macros_sql_list = UserMacrosSql.objects.filter(user_macros=user_macros).order_by('order')
        context = {'user_macros': user_macros, 'form': form, 'user_macros_sql_list': user_macros_sql_list}
        context.update(self.get_user_context(title=f'Executing macros'))
        return render(request, self.template_name, context)

    def post(self, request, macros_id, *args, **kwargs):
        user_macros = UserMacros.objects.get(pk=macros_id)
        user_macros_sql_list = UserMacrosSql.objects.filter(user_macros=user_macros).order_by('order')
        form = ExecuteMacrosForm(request.POST)
        results = None
        if form.is_valid():
            db_name = form.cleaned_data['db_name']
            for user_macros_sql in user_macros_sql_list:
                query = user_macros_sql.user_sql.query
                user_sql_name = user_macros_sql.user_sql.name
                results = self.execute_query(sql_name=user_sql_name, query=query, db_name=db_name)
                if results.get('error'):
                    context = {'user_macros': user_macros, 'results': results, 'form': form,
                               'user_macros_sql_list': user_macros_sql_list}
                    context.update(self.get_user_context(title=f'Executing macros'))
                    return render(request, self.template_name, context)

        context = {'user_macros': user_macros, 'results': results, 'form': form, 'user_macros_sql_list': user_macros_sql_list}
        context.update(self.get_user_context(title=f'Executing macros'))
        return render(request, self.template_name, context)

    def execute_query(self, sql_name, query, db_name):
        sql = Connector()
        connection = sql.connection(db_name=db_name)
        sql_requests = query.split(';')

        try:
            result = {
                'result': 'Query failed'
            }
            results_connection = []
            for sql_request in sql_requests:
                result_connection = connection.execute(sql_request)
                results_connection.append(result_connection)
            if results_connection:
                result = {
                    'result': 'Query completed'
                }
        except Exception as e:
            logger.error(str(e))

            try:
                error_text = f'{sql_name}: {e.orig}'
            except:
                error_text = f'{sql_name}: {e}'

            result = {
                'error': error_text
            }
        finally:
            connection.close()
        return result

''' List of created user macros history '''
class FibasUserHistoryCustomMacrosListView(ListView, DataMixin):
    model = User_Custom_Macros
    template_name = 'fibas/fibas_user_custom_macros_list.html'
    context_object_name = 'user_custom_macros'
    paginate_by = 10

    def get_queryset(self):
        db_name = self.kwargs.get('db_name')
        queryset = User_Custom_Macros.objects.filter(fibas__title=db_name)
        return queryset.order_by('-id')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Custom Macros History')
        db_name = self.kwargs.get('db_name')
        context['db_name'] = db_name
        context.update(c_def)
        paginator = context['paginator']
        page = context['page_obj']
        context['is_paginated'] = page.has_other_pages()
        context['prev_url'] = f'?page={page.previous_page_number()}' if page.has_previous() else ''
        context['next_url'] = f'?page={page.next_page_number()}' if page.has_next() else ''
        return dict(list(context.items()) + list(c_def.items()))

'''Executing macros in data base
Get - Getting custom macros object and query list in custom macros
Post - Getting custom macros object and list query for custom macros objects.
If there are no errors when inserting data into the database, the remaining fields are filled in for all queries,
Moving files to a directory with database files or deleting files from the database '''

class ExecuteCustomMacrosView(View, DataMixin):
    template_name = 'fibas/fibas_execute_custom_macros.html'

    def get(self, request, macros_id, *args, **kwargs):
        db_name = self.kwargs.get('db_name')
        print(db_name, 'DB_NAME')
        form = ExecuteCustomMacrosForm()
        user_custom_macros = User_Custom_Macros.objects.get(pk=macros_id)
        user_custom_macros_query_list = UserCustomMacrosSql.objects.filter(user_custom_macros=user_custom_macros).order_by('order')
        context = {'user_custom_macros': user_custom_macros, 'form': form, 'user_custom_macros_query_list': user_custom_macros_query_list}
        context.update(self.get_user_context(title=f'Executing custom macros'))
        return render(request, self.template_name, context)

    def post(self, request, macros_id, *args, **kwargs):
        user_custom_macros = User_Custom_Macros.objects.get(pk=macros_id)
        user_custom_macros_query_list = UserCustomMacrosSql.objects.filter(user_custom_macros=user_custom_macros).order_by('order')
        form = ExecuteCustomMacrosForm(request.POST)
        results = None
        errors = []
        if form.is_valid():
            db_name = form.cleaned_data['db_name']
            fibas_object_custom_macros = Fibas.objects.get(title=db_name.title)
            user_custom_macros.fibas = fibas_object_custom_macros
            user_custom_macros.save()
            user_custom_macros_query_list = UserCustomMacrosSql.objects.filter(
                user_custom_macros=user_custom_macros).order_by('order')
            logger.info(f'Run Custom macros {user_custom_macros}')

            for user_macros_sql in user_custom_macros_query_list:
                query = user_macros_sql.user_query.query_file
                user_query_name = user_macros_sql.user_query.file_name
                results = self.execute_query(query_name=user_query_name, query=query, db_name=db_name)

                if 'error' not in results:
                    user_macros_sql.user_query.fibas = fibas_object_custom_macros
                    user_macros_sql.user_query.applied_at = datetime.now()
                    user_macros_sql.user_query.save()
                    move_query_file(user_macros_sql.user_query)
                else:
                    errors.append({
                        'query_name': user_query_name,
                        'error': results['error']
                    })
                    delete_query_file(user_macros_sql.user_query)
                    user_macros_sql.user_query.delete()

            logger.info(f'End Custom macros {user_custom_macros}')
        context = {'user_custom_macros': user_custom_macros, 'results': results, 'form': form,
                   'user_custom_macros_query_list': user_custom_macros_query_list, 'errors': errors}
        context.update(self.get_user_context(title=f'Executing custom macros'))
        return render(request, self.template_name, context)

    def execute_query(self, query_name, query, db_name):
        sql = Connector()
        connection = sql.connection(db_name=db_name)
        try:
            parameters = Parameters.objects.first()  # или используйте более специфичный фильтр, если требуется
            val_dat = parameters.val_dat if parameters else None
            result = {
                'result': 'Query failed'
            }
            results_connection = []
            with query.open() as file:
                query_content = file.read().decode()
                query_requests = query_content.split(';')
                for sql_request in query_requests:
                    query_request_with_val_dat = sql_request.replace('{ValDat}', str(val_dat))
                    result_connection = connection.execute(query_request_with_val_dat)
                    results_connection.append(result_connection)

                if results_connection:
                    result = {
                        'result': 'Macros completed'
                    }

        except Exception as e:
            logger.error(str(e))

            try:
                error_text = f'{query_name}: {e.orig}'
            except:
                error_text = f'{query_name}: {e}'

            result = {
                'error': error_text
            }
        finally:
            connection.close()
        return result


class File:
    def __init__(self, name, file_path, is_directory=False):
        self.name = name
        self.file_path = file_path
        self.is_directory = is_directory


class SFTPFileManagerView(View, DataMixin):
    template_name = 'fibas/fibas_sftp_download.html'

    def get_files(self, sftp, full_path):
        files = []
        for file_name in sftp.listdir(full_path):
            file_path = os.path.join(full_path, file_name)
            file_attributes = sftp.stat(file_path)
            is_directory = S_ISDIR(file_attributes.st_mode)
            files.append(File(name=file_name, file_path=file_path, is_directory=is_directory))
        return files

    # create bread crumbs
    def breadcrumbs(self, path):
        breadcrumbs = []
        current_path = ''
        breadcrumbs.append(f'/<a href="{reverse("fibas_sftp_file_manager")}">home</a>')
        for folder in path.split('/'):
            if folder:
                breadcrumbs.append(
                    f'<a href="{reverse("fibas_sftp_file_manager", args=[current_path + folder])}">{folder}</a>')
                current_path += f'{folder}/'

        breadcrumbs = '/'.join(breadcrumbs)
        return breadcrumbs

    def get(self, request, path='/'):
        config = ConnectConfig(service_name='sftp_server')

        # Connecting to the SFTP server
        host = config.get_service_val('host')
        port = int(config.get_service_val('port'))
        username = config.get_service_val('username')
        password = config.get_service_val('password')

        transport = paramiko.Transport((host, port))
        transport.connect(username=username, password=password)
        sftp = paramiko.SFTPClient.from_transport(transport)

        history = request.session.get('path_history', [])
        history.append(path)
        request.session['path_history'] = history

        # get list file or directories
        full_path = path
        files = self.get_files(sftp=sftp, full_path=full_path)

        # close connect
        sftp.close()
        transport.close()

        breadcrumbs = self.breadcrumbs(path=path)

        context = {
            'files': files,
            'current_path': full_path,
            'breadcrumbs': breadcrumbs,
        }
        context.update(self.get_user_context(title=f'SFTP File Manager'))

        return render(request, self.template_name, context)

    def post(self, request, path=''):
        config = ConnectConfig(service_name='sftp_server')

        # Connecting to the SFTP server
        host = config.get_service_val('host')
        port = int(config.get_service_val('port'))
        username = config.get_service_val('username')
        password = config.get_service_val('password')

        transport = paramiko.Transport((host, port))
        transport.connect(username=username, password=password)
        sftp = paramiko.SFTPClient.from_transport(transport)

        history = request.session.get('path_history', [])
        history.append(path)
        request.session['path_history'] = history

        full_path = path
        files = self.get_files(sftp=sftp, full_path=full_path)

        breadcrumbs = self.breadcrumbs(path=path)

        context = {
            'files': files,
            'current_path': full_path,
            'breadcrumbs': breadcrumbs,
        }
        context.update(self.get_user_context(title=f'SFTP File Manager'))

        # get selected file
        file_name = request.POST.get('file_name', '')

        # check input file
        check_file_name_claims = validate_filename_claims_sftp(file_name=file_name)
        check_file_name_claims_basic = validate_filename_claims_basic_sftp(file_name=file_name)
        check_file_name_claims_policy = validate_filename_claims_policy_sftp(file_name=file_name)
        check_file_name_policies = validate_filename_policies_sftp(file_name=file_name)

        if check_file_name_claims:
            file_folder_name = 'claims'
        elif check_file_name_claims_basic:
            file_folder_name = 'claims_basic'
        elif check_file_name_claims_policy:
            file_folder_name = 'claims_policy'
        elif check_file_name_policies:
            file_folder_name = 'policies'
        else:
            error_message = 'This file is not suitable'
            context.update({
                'error_message': error_message
            })
            return render(request, self.template_name, context)

        config = read_config()
        base_path = config['client'].get('base_path')

        destination_path = get_path_name_input(filename=file_name, file_folder_name=file_folder_name, provider_name=DATABASE_NAME, base_path=base_path)
        destination_path = os.path.join(MEDIA_ROOT, destination_path)

        remote_file_path = os.path.join(path, file_name)

        # creating a directory if it does not exist
        os.makedirs(os.path.dirname(destination_path), exist_ok=True)

        try:
            # downloading file
            sftp.get(remote_file_path, destination_path)

            form = AddFilesConversionForm(request.POST)

            title = create_name_database_with_date(filename=file_name, database_name=DATABASE_NAME)
            form.instance.title = title.lower()

            existing_objects = Fibas.objects.filter(slug=title.lower())

            if existing_objects.exists():
                # If the object exists, update the data in it
                existing_object = existing_objects.first()
                if check_file_name_claims:
                    existing_object.claims = destination_path
                elif check_file_name_claims_basic:
                    existing_object.claims_basic = destination_path
                elif check_file_name_claims_policy:
                    existing_object.claims_policy = destination_path
                elif check_file_name_policies:
                    existing_object.policies = destination_path

                existing_object.save()

            else:
                # If there is no object, create a new one
                if check_file_name_claims:
                    form.instance.claims = destination_path
                elif check_file_name_claims_basic:
                    form.instance.claims_basic = destination_path
                elif check_file_name_claims_policy:
                    form.instance.claims_policy = destination_path
                elif check_file_name_policies:
                    form.instance.policies = destination_path

                form.save()

            message = 'File successfully downloaded'
            context.update({
                'message': message
            })
            logger.info(f"File {file_name} successfully downloaded to {destination_path}.")
        except FileNotFoundError:
            error_message = f"File {remote_file_path} does not exist."
            context.update({
                'error_message': error_message
            })
            logger.error(error_message)
        finally:
            # close connection
            sftp.close()
            transport.close()

        # send response
        return render(request, self.template_name, context)


