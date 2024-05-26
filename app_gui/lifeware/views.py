import re
import os
import logging
import sqlvalidator

from datetime import datetime

from django.http import HttpResponseRedirect
from django.views import View
from django.http import Http404, HttpResponse
from django.views.generic import ListView, CreateView, UpdateView
from django.urls import reverse_lazy, reverse
from django.shortcuts import render, redirect
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger

from main.utils import DataMixin, check_files_name, create_name_database_with_date, check_files_name_update
from main.helpers.sql_connection.sql_connection import Connector

from .models import LifeWare, Parameters, UserSql, UserMacros, UserMacrosSql
from .forms import AddFilesConversionForm, ParametersForm, UserSqlForm, ExecuteSqlForm, \
    UserMacrosForm, ExecuteMacrosForm
from .helpers.conversion.conversion import Conversion
from .helpers.macros.run_check_new import CheckNew
from .helpers.macros.run_termsheet_checks import TermsheetChecks


logger = logging.getLogger(__name__)


DATABASE_NAME = 'LIFEWARE'


# start page LIFEWARE
class LifeWareView(ListView, DataMixin):
    model = LifeWare
    template_name = 'lifeware/life_ware_index.html'
    context_object_name = 'life_ware'
    success_url = reverse_lazy('lifeware')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['life_wares'] = LifeWare.objects.order_by('title')
        c_def = self.get_user_context(title='Life Ware page')
        return dict(list(context.items()) + list(c_def.items()))


# CSV file upload page
# with verification of the correctness of the file name and their upload fields
class UploadView(CreateView, DataMixin):
    form_class = AddFilesConversionForm
    template_name = 'lifeware/life_ware_add_files.html'

    def get_success_url(self):
        return reverse('life_ware_parameters_entry', kwargs={'pk': self.object.pk})

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
# - Input parameters
# - Running macros
# - Launching the views
class DatabasePageView(ListView, DataMixin):
    model = LifeWare
    template_name = 'lifeware/life_ware_database.html'
    success_url = reverse_lazy('life_ware_database')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if LifeWare.objects.filter(id=pk).exists():
            sql = Connector()
            life_ware = LifeWare.objects.get(id=pk)
            title = life_ware.title
            # check db in MySQL
            check_db = sql.check_database(title)
            if check_db:
                bestandsreport = sql.check_table(db_name=title, table_name='Bestandsreport')
                bewegungs_report = sql.check_table(db_name=title, table_name='Bewegungsreport')
                lapses_since_inception = sql.check_table(db_name=title, table_name='Lapses since inception')
                termsheet_report = sql.check_table(db_name=title, table_name='TermsheetReport')

                context['bestandsreport'] = bestandsreport
                context['bewegungs_report'] = bewegungs_report
                context['lapses_since_inception'] = lapses_since_inception
                context['termsheet_report'] = termsheet_report
            context['pk'] = pk
            context['life_ware'] = life_ware
            context['check_db'] = check_db
            c_def = self.get_user_context(title=title)
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# CSV file update page in db
# checking the names of uploaded files
class LifeWareUpdateView(UpdateView, DataMixin):
    model = LifeWare
    form_class = AddFilesConversionForm
    template_name = 'lifeware/life_ware_update_files.html'
    context_object_name = 'life_ware'

    def get_success_url(self):
        return reverse('life_ware_database', kwargs={'pk': self.kwargs.get('pk')})

    # Validate forms
    def form_valid(self, form):
        if form.is_valid():
            obj_name = LifeWare.objects.get(id=self.object.pk)
            obj_date = re.findall(r'\d+', str(obj_name))
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
        if LifeWare.objects.filter(id=pk).exists():
            life_ware = LifeWare.objects.get(id=pk)
            title = life_ware.title
            context['pk'] = pk
            c_def = self.get_user_context(title=f'Life Ware update {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Input/update page for the ValDate and product type parameters
# with checks:
# - correct input of ValDate
# - existence of ValDate in the database, if there is updates
class ParametersView(CreateView, DataMixin):
    model = Parameters
    form_class = ParametersForm
    template_name = 'lifeware/life_ware_parameters_entry.html'
    allow_empty = False

    def form_valid(self, form):
        form.instance.life_ware_id = self.kwargs.get('pk')
        pk = form.instance.life_ware_id

        if Parameters.objects.filter(life_ware=pk).exists():
            parameters = Parameters.objects.get(life_ware=pk)
            parameters.val_date_old = parameters.val_date
            parameters.val_date = form.instance.val_date
            parameters.LifeWare = pk
            parameters.save()
        else:
            self.object = form.save()

        return redirect(self.get_success_url())

    def get_success_url(self):
        return reverse('life_ware_database', kwargs={'pk': self.kwargs.get('pk')})

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if LifeWare.objects.filter(id=pk).exists():
            life_ware = LifeWare.objects.get(id=pk)
            title = life_ware.title
            context['pk'] = self.kwargs.get('pk')
            c_def = self.get_user_context(title=f'Parameters Entry {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Converting CSV files to a database
@csrf_exempt
def data_conversion(request, pk):
    if request.method == 'POST':
        if LifeWare.objects.filter(id=pk).exists():
            obj = LifeWare.objects.get(id=pk)
            filename = os.path.basename(obj.bestandsreport.name)
            db_name = create_name_database_with_date(filename=filename, database_name=DATABASE_NAME)
            Connector().create_database(db_name)

            try:
                Conversion().run(db_name)
            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()


# Macros Launch Page
class MacrosView(ListView, DataMixin):
    model = LifeWare
    template_name = 'lifeware/life_ware_macros.html'
    success_url = reverse_lazy('life_ware_macros')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if LifeWare.objects.filter(id=pk).exists():
            sql = Connector()
            life_ware = LifeWare.objects.get(id=pk)
            title = life_ware.title
            if Parameters.objects.filter(life_ware=life_ware).exists():
                check_db = sql.check_database(title)
                bestandsreport = sql.check_table(db_name=title, table_name='Bestandsreport')
                bewegungsreport = sql.check_table(db_name=title, table_name='Bewegungsreport')
                lapses_since_inception = sql.check_table(db_name=title, table_name='Lapses since inception')
                termsheet_report = sql.check_table(db_name=title, table_name='TermsheetReport')
                if check_db and bestandsreport and bewegungsreport and lapses_since_inception and termsheet_report:
                    context['pk'] = self.kwargs.get('pk')
                    c_def = self.get_user_context(title=f'Macros {title}')
                    return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Running a macros "Run check new"
@csrf_exempt
def run_check_new(request, pk):
    if request.method == 'POST':
        if LifeWare.objects.filter(id=pk).exists():
            sql = Connector()
            life_ware = LifeWare.objects.get(id=pk)
            bestandsreport_name = os.path.basename(life_ware.bestandsreport.name)
            db_name = create_name_database_with_date(filename=bestandsreport_name, database_name=DATABASE_NAME)
            parameters = Parameters.objects.get(life_ware=pk)
            val_date = datetime.strptime(str(life_ware.parameters.val_date.date()), '%Y-%m-%d').strftime('%d-%m-%Y')
            val_date_old = parameters.val_date_old
            if val_date_old:
                date = val_date_old
            else:
                date = parameters.val_date

            # Make a backup there is a table exists
            table_name = 'Error Table'
            if sql.check_table(db_name=db_name, table_name=table_name):
                sql.backup_table(db_name=db_name, table_name=table_name, date=date)

            try:
                CheckNew().run(db_name=db_name, val_date=val_date)
            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()


# Running a macros "Run Termsheet checks"
@csrf_exempt
def run_termsheet_checks(request, pk):
    if request.method == 'POST':
        if LifeWare.objects.filter(id=pk).exists():
            sql = Connector()
            life_ware = LifeWare.objects.get(id=pk)
            bestandsreport_name = os.path.basename(life_ware.bestandsreport.name)
            db_name = create_name_database_with_date(filename=bestandsreport_name, database_name=DATABASE_NAME)
            parameters = Parameters.objects.get(life_ware=pk)

            # Make a backup there is a table exists
            val_date_old = parameters.val_date_old
            if val_date_old:
                date = val_date_old
            else:
                date = parameters.val_date

            table_name = 'TersheetErrorTable'
            if sql.check_table(db_name=db_name, table_name=table_name):
                sql.backup_table(db_name=db_name, table_name=table_name, date=date)

            try:
                TermsheetChecks().run(db_name=db_name)

            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()


#
# # Running a macros "Run M Monetinputs"
# @csrf_exempt
# def run_m_monetinputs(request, pk):
#     if request.method == 'POST':
#         if LifeWare.objects.filter(id=pk).exists():
#             sql = Connector()
#             life_ware = LifeWare.objects.get(id=pk)
#             if Parameters.objects.filter(life_ware=life_ware).exists():
#                 bestandsreport_name = os.path.basename(life_ware.bestandsreport_name.name)
#                 db_name = create_name_database_with_date(filename=bestandsreport_name, database_name=DATABASE_NAME)
#                 val_dat = datetime.strpЧtime(str(life_ware.parameters.val_dat.date()), '%Y-%m-%d').strftime('%d-%m-%Y')
#                 # product_type = life_ware.parameters.product_type
#                 parameters = Parameters.objects.get(fibas=pk)
#                 val_dat_old = parameters.val_dat_old
#                 if val_dat_old:
#                     date = val_dat_old
#                 else:
#                     date = parameters.val_dat
#
#                 # Make a backup there is a table exists
#                 table_name = 'MonetInputsUpdated'
#                 if sql.check_tables(db_name=db_name, table_name=table_name):
#                     sql.backup_table(db_name=db_name, table_name=table_name, date=date)
#
#                 try:
#                     MMonetInputs().run(db_name, val_dat)
#                     if MMonetInputs().check_special_column(db_name):
#                         response = 'Warning!Macros are suspended until the situation is resolved. Column with Special = «Yes» have >1.'
#                         logger.info(response)
#                         return HttpResponse(response)
#                     else:
#                         response = 'Done'
#                         return HttpResponse(response)
#                 except Exception as e:
#                     response = str(e)
#                     logger.error(response)
#                     return HttpResponse(response)
#
#             response = 'Error'
#             return HttpResponse(response)
#     raise Http404()







class CustomMacrosView(ListView, DataMixin):
    model = UserSql
    template_name = 'lifeware/life_ware_custom_macros.html'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Custom macros')
        return dict(list(context.items()) + list(c_def.items()))


class AddSqlView(CreateView, DataMixin):
    model = UserSql
    form_class = UserSqlForm
    template_name = 'lifeware/life_ware_add_sql.html'
    success_url = reverse_lazy('life_ware_user_sql_list')

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


class UserSqlListView(ListView, DataMixin):
    model = UserSql
    template_name = 'lifeware/life_ware_user_sql_list.html'
    context_object_name = 'user_sql_list'
    ordering = ['name']

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'List sql')
        return dict(list(context.items()) + list(c_def.items()))


class EditSqlView(UpdateView, DataMixin):
    template_name = 'lifeware/life_ware_edit_sql.html'
    model = UserSql
    form_class = UserSqlForm
    success_url = reverse_lazy('life_ware_user_sql_list')

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        form = self.get_form()
        if form.is_valid():
            query = form.cleaned_data['query']
            sql_query = sqlvalidator.parse(query)
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
    return HttpResponseRedirect(reverse_lazy('life_ware_user_sql_list'))


class ExecuteSqlView(View, DataMixin):
    template_name = 'lifeware/life_ware_execute_sql.html'

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


class UserCreateMacrosView(CreateView, DataMixin):
    model = UserMacros
    form_class = UserMacrosForm
    template_name = 'lifeware/life_ware_user_macros_create.html'
    success_url = reverse_lazy('life_ware_user_macros_list')

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

            return redirect('life_ware_execute_macros', macros_id=user_macros.pk)
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


class UserMacrosListView(ListView, DataMixin):
    model = UserMacros
    template_name = 'lifeware/life_ware_user_macros_list.html'
    context_object_name = 'user_macros_list'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Macros List')
        user_macros = UserMacros.objects.all()
        context['user_macros'] = user_macros
        return dict(list(context.items()) + list(c_def.items()))


class EditMacrosView(UpdateView, DataMixin):
    template_name = 'lifeware/life_ware_edit_macros.html'
    model = UserMacros
    form_class = UserMacrosForm
    success_url = reverse_lazy('life_ware_user_macros_list')

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
                return redirect('life_ware_user_macros_list')
            elif from_page == 'execute_macros':
                return redirect(reverse_lazy('life_ware_execute_macros', args=[user_macros.id]))
            return redirect('life_ware_user_macros_list')
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
    return HttpResponseRedirect(reverse_lazy('life_ware_user_macros_list'))


class ExecuteMacrosView(View, DataMixin):
    template_name = 'lifeware/life_ware_execute_macros.html'

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

