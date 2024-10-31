import re
import os
import logging
import sqlvalidator

from datetime import datetime
from django.http import Http404, HttpResponse, HttpResponseRedirect
from django.views import View
from django.views.generic import ListView, CreateView, UpdateView
from django.urls import reverse_lazy, reverse
from django.shortcuts import render, redirect
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt

from main.utils import DataMixin, check_files_name, create_name_database_with_date, \
    check_files_name_update, get_db_name_previous_year
from main.helpers.sql_connection.sql_connection import Connector

from .helpers.macros.db_checkdata import DBCheckData
# from .helpers.macros.generate_monet_inputs_exp_death import GenerateMonetInputsExpDeath
from .helpers.macros.generate_monet_inputs import GenerateMonetInputs
# from .helpers.macros.generate_monet_inputs_term import GenerateMonetInputsTerm
from .helpers.macros.generate_monetinputs_exppl import GenerateMonetInputsExpPL
from .helpers.macros.run_check import RunCheck
from .models import Term, Parameters, UserSql, UserMacros, UserMacrosSql
from .forms import AddFilesConversionForm, ParametersForm, UserSqlForm, ExecuteSqlForm, UserMacrosForm, ExecuteMacrosForm
from main.helpers.conversion.helpers import read_config
from .helpers.conversion.conversion import Conversion

logger = logging.getLogger(__name__)

DATABASE_NAME = 'TERM'

# start page TERM
class TermView(ListView, DataMixin):
    model = Term
    template_name = 'term/term_index.html'
    context_object_name = 'term'
    success_url = reverse_lazy('term')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['terms'] = Term.objects.order_by('title')
        c_def = self.get_user_context(title='Term page')
        return dict(list(context.items()) + list(c_def.items()))


# CSV file upload page
# with verification of the correctness of the file name and their upload fields
class UploadView(CreateView, DataMixin):
    form_class = AddFilesConversionForm
    template_name = 'term/term_add_files.html'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['pk'] = self.kwargs.get('pk')
        c_def = self.get_user_context(title=f'Add files')
        return dict(list(context.items()) + list(c_def.items()))

    def get_success_url(self):
        return reverse('term_parameters_entry', kwargs={'pk': self.object.pk})

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
                except TypeError as e:
                    error_message = 'The form cannot be empty'
                    logger.error(f'TypeError occurred: {str(e)}')
                    logger.info(f'self.object: {self.object}')
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


# Action selection page:
# - Updating CSV files in the database
# - Input of the ValDat and product type parameters
# - Running macros
# - Launching the views
class DatabasePageView(ListView, DataMixin):
    model = Term
    template_name = 'term/term_database.html'
    success_url = reverse_lazy('term_database')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Term.objects.filter(id=pk).exists():
            sql = Connector()
            term = Term.objects.get(id=pk)
            title = term.title
            # check db term in MySQL
            check_db_term = sql.check_database(title)
            if check_db_term:
                policydata = sql.check_table(db_name=title, table_name='Policydata_NewReport')
                de_hoop_data = sql.check_table(db_name=title, table_name='DeHoopData')
                context['policydata'] = policydata
                context['de_hoop_data'] = de_hoop_data
            context['pk'] = pk
            context['term'] = term
            context['check_db_term'] = check_db_term
            c_def = self.get_user_context(title=title)
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# CSV file update page in db
# checking the names of uploaded files
class TermUpdateView(UpdateView, DataMixin):
    model = Term
    form_class = AddFilesConversionForm
    template_name = 'term/term_update_files.html'
    context_object_name = 'term'

    def get_success_url(self):
        return reverse('term_database', kwargs={'pk': self.kwargs.get('pk')})

    # Validate forms
    def form_valid(self, form):
        if form.is_valid():
            obj_name = Term.objects.get(id=self.object.pk)
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
        if Term.objects.filter(id=pk).exists():
            term = Term.objects.get(id=pk)
            title = term.title
            context['pk'] = pk
            c_def = self.get_user_context(title=f'Term update {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Input/update page for the ValDat and product type parameters
# with checks:
# - correct input of ValDat
# - existence of ValDat in the database, if there is updates
class ParametersView(CreateView, DataMixin):
    model = Parameters
    form_class = ParametersForm
    template_name = 'term/term_parameters_entry.html'
    allow_empty = False

    def form_valid(self, form):
        form.instance.term_id = self.kwargs.get('pk')
        pk = form.instance.term_id
        if Parameters.objects.filter(term=pk).exists():
            parameters = Parameters.objects.get(term=pk)
            parameters.val_dat_old = parameters.val_dat
            parameters.val_dat = form.instance.val_dat
            parameters.fib_reinsured = form.instance.fib_reinsured
            parameters.date_data_extract = form.instance.date_data_extract
            parameters.Term = pk
            parameters.save()
        else:
            self.object = form.save()

        return redirect(self.get_success_url())

    def get_success_url(self):
        return reverse('term_database', kwargs={'pk': self.kwargs.get('pk')})

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Term.objects.filter(id=pk).exists():
            term = Term.objects.get(id=pk)
            title = term.title
            context['pk'] = self.kwargs.get('pk')
            c_def = self.get_user_context(title=f'Parameters Entry {title}')
            return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


class MacrosView(ListView, DataMixin):
    model = Term
    template_name = 'term/term_macros.html'
    success_url = reverse_lazy('term_macros')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        if Term.objects.filter(id=pk).exists():
            sql = Connector()
            term = Term.objects.get(id=pk)
            title = term.title
            if Parameters.objects.filter(term=term).exists():
                check_db_term = sql.check_database(title)
                if check_db_term:
                    policydata_to_quantum_original = sql.check_table(db_name=title, table_name='Policydata_to_Quantum_ORIGINAL')
                    monet_inputs_term = sql.check_table(db_name=title, table_name='Monet Inputs Term')
                    context['pk'] = self.kwargs.get('pk')
                    context['policydata_to_quantum_original'] = policydata_to_quantum_original
                    context['monet_inputs_term'] = monet_inputs_term
                    c_def = self.get_user_context(title=f'Macros {title}')
                    return dict(list(context.items()) + list(c_def.items()))
        raise Http404()


# Converting CSV files to a database
@csrf_exempt
def data_conversion(request, pk):
    if request.method == 'POST':
        if Term.objects.filter(id=pk).exists():
            f = Term.objects.get(id=pk)
            filename = os.path.basename(f.policydata_new_report.name)
            db_name = create_name_database_with_date(filename=filename, database_name=DATABASE_NAME)

            Connector().create_database(db_name)

            db_name_previous_year = get_db_name_previous_year(filename=db_name, database_name=DATABASE_NAME)
            config = read_config()
            base_path = config['client'].get('base_path')
            try:
                if "_" in db_name:
                    prefix, date_part = db_name.split("_", 1)
                    new_db_name = f"fibas_{date_part}"
                else:
                    new_db_name = "fibas"

                Conversion().run(db_name=db_name, db_name_previous_year=db_name_previous_year, base_path=base_path, new_db_name=new_db_name)
            except Exception as e:
                response = str(e)
                logger.error(response)
                return HttpResponse(response)

            response = 'Done'
            return HttpResponse(response)
    raise Http404()

@csrf_exempt
def run_generate_monet_inputs(request, pk):
    if request.method == 'POST':
        if Term.objects.filter(id=pk).exists():
            sql = Connector()
            term = Term.objects.get(id=pk)

            policydata_new_report_name = os.path.basename(term.policydata_new_report.name)
            db_name = create_name_database_with_date(filename=policydata_new_report_name, database_name=DATABASE_NAME)
            if "_" in db_name:
                prefix, date_part = db_name.split("_", 1)
                new_db_name = f"fibas_{date_part}"
            else:
                new_db_name = "fibas"

            print(new_db_name, 'new_db_name')

            db_name_previous_year = get_db_name_previous_year(filename=db_name, database_name=DATABASE_NAME)
            check_db_name_previous_year = sql.check_database(db_name=db_name_previous_year)


            if Parameters.objects.filter(term=term).exists():
                date_data_extract = datetime.strptime(str(term.parameters.date_data_extract.date()), '%Y-%m-%d').strftime('%d-%m-%Y')
                val_dat = datetime.strptime(str(term.parameters.val_dat.date()), '%Y-%m-%d').strftime('%d-%m-%Y')
                fib_reinsured = term.parameters.fib_reinsured
                val_dat_old = term.parameters.val_dat_old

                if val_dat_old:
                    date = val_dat_old
                else:
                    date = term.parameters.val_dat

                table_names = [
                    'Monet Inputs ExpDeath',
                    'Monet Inputs Term',
                    'Monet Inputs FIBAS',
                    'Monet Inputs Term NB',
                    'Monet Inputs ExpPL',
                    'Monet Inputs Previous year'
                ]
                for table_name in table_names:
                    if sql.check_table(db_name=db_name, table_name=table_name):
                        sql.backup_table(db_name=db_name, table_name=table_name, date=date)
                try:

                    GenerateMonetInputs().run(db_name=db_name, new_db_name=new_db_name, date_data_extract=date_data_extract,
                                                  fib_reinsured=fib_reinsured, val_dat=val_dat)
                    if check_db_name_previous_year:
                        if sql.check_table(db_name=db_name_previous_year, table_name='Monet Inputs Term'):
                                try:
                                    print('PRINT #2')
                                    GenerateMonetInputsExpPL().run(db_name=db_name, date_data_extract=date_data_extract,
                                                                   val_dat=val_dat, fib_reinsured=fib_reinsured,
                                                                   monet_inputs_previous_year=db_name_previous_year, new_db_name=new_db_name)
                                    print('PRINT #3')
                                except Exception as e:
                                    response = str(e)
                                    logger.error(response)
                                    return HttpResponse(response)


                    else:
                        response = f'Table \'{db_name_previous_year}.Monet Inputs Term\' doesn\'t exist'
                        return HttpResponse(response)

                except Exception as e:
                    response = str(e)
                    logger.error(response)
                    return HttpResponse(response)

                response = 'Done'
                return HttpResponse(response)
            response = 'Error'
            return HttpResponse(response)
    raise Http404()



@csrf_exempt
def run_db_check_data(request, pk):
    if request.method == 'POST':
        if Term.objects.filter(id=pk).exists():
            sql = Connector()
            term = Term.objects.get(id=pk)
            policydata_new_report_name = os.path.basename(term.policydata_new_report.name)
            db_name = create_name_database_with_date(filename=policydata_new_report_name, database_name=DATABASE_NAME)
            db_name_previous_year = get_db_name_previous_year(filename=db_name, database_name=DATABASE_NAME)
            check_db_name_previous_year = sql.check_database(db_name=db_name_previous_year)
            if "_" in db_name:
                prefix, date_part = db_name.split("_", 1)
                new_db_name = f"fibas_{date_part}"
            else:
                new_db_name = "fibas"

            if Parameters.objects.filter(term=term).exists():
                val_dat_old = term.parameters.val_dat_old

                if val_dat_old:
                    date = val_dat_old
                else:
                    date = term.parameters.val_dat

                # Make a backup there is a table exists
                table_name = 'DBErrorTable'
                if sql.check_table(db_name=db_name, table_name=table_name):
                    sql.backup_table(db_name=db_name, table_name=table_name, date=date)

                try:
                    if check_db_name_previous_year:
                        if sql.check_table(db_name=db_name_previous_year, table_name='Policydata_to_Quantum_ORIGINAL_PrevY'):
                            DBCheckData().run(db_name=db_name,new_db_name=new_db_name )
                    else:
                        response = f'Table \'{db_name_previous_year}.Policydata_to_Quantum_ORIGINAL_PrevY\' doesn\'t exist'
                        return HttpResponse(response)
                except Exception as e:
                    response = str(e)
                    logger.error(response)
                    return HttpResponse(response)

                response = 'Done'
                return HttpResponse(response)
            response = 'Error'
            return HttpResponse(response)
    raise Http404()


@csrf_exempt
def run_check(request, pk):
    if request.method == 'POST':
        if Term.objects.filter(id=pk).exists():
            sql = Connector()
            term = Term.objects.get(id=pk)
            policydata_new_report_name = os.path.basename(term.policydata_new_report.name)
            db_name = create_name_database_with_date(filename=policydata_new_report_name, database_name=DATABASE_NAME)
            if "_" in db_name:
                prefix, date_part = db_name.split("_", 1)
                new_db_name = f"fibas_{date_part}"
            else:
                new_db_name = "fibas"
            if Parameters.objects.filter(term=term).exists():
                val_dat_old = term.parameters.val_dat_old

                if val_dat_old:
                    date = val_dat_old
                else:
                    date = term.parameters.val_dat

                # Make a backup there is a table exists
                table_name = 'ErrorTable'
                if sql.check_table(db_name=db_name, table_name=table_name):
                    sql.backup_table(db_name=db_name, table_name=table_name, date=date)

                try:
                    RunCheck().run(db_name=db_name,new_db_name=new_db_name)
                except Exception as e:
                    response = str(e)
                    logger.error(response)
                    return HttpResponse(response)

                response = 'Done'
                return HttpResponse(response)
            response = 'Error'
            return HttpResponse(response)
    raise Http404()


class AddSqlView(CreateView, DataMixin):
    model = UserSql
    form_class = UserSqlForm
    template_name = 'term/term_add_sql.html'
    success_url = reverse_lazy('term_user_sql_list')

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
    template_name = 'term/term_edit_sql.html'
    model = UserSql
    form_class = UserSqlForm
    success_url = reverse_lazy('term_user_sql_list')

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
    return HttpResponseRedirect(reverse_lazy('term_user_sql_list'))


class UserSqlListView(ListView, DataMixin):
    model = UserSql
    template_name = 'term/term_user_sql_list.html'
    context_object_name = 'user_sql_list'
    ordering = ['name']

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'List sql')
        return dict(list(context.items()) + list(c_def.items()))


class ExecuteSqlView(View, DataMixin):
    template_name = 'term/term_execute_sql.html'

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


class CustomMacrosView(ListView, DataMixin):
    model = UserSql
    template_name = 'term/term_custom_macros.html'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Custom macros')
        return dict(list(context.items()) + list(c_def.items()))


class UserCreateMacrosView(CreateView, DataMixin):
    model = UserMacros
    form_class = UserMacrosForm
    template_name = 'term/term_user_macros_create.html'
    success_url = reverse_lazy('term_user_macros_list')

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

            return redirect('term_execute_macros', macros_id=user_macros.pk)
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
    template_name = 'term/term_user_macros_list.html'
    context_object_name = 'user_macros_list'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title=f'Macros List')
        user_macros = UserMacros.objects.all()
        context['user_macros'] = user_macros
        return dict(list(context.items()) + list(c_def.items()))


class EditMacrosView(UpdateView, DataMixin):
    template_name = 'term/term_edit_macros.html'
    model = UserMacros
    form_class = UserMacrosForm
    success_url = reverse_lazy('term_user_macros_list')

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
                return redirect('term_user_macros_list')
            elif from_page == 'execute_macros':
                return redirect(reverse_lazy('term_execute_macros', args=[user_macros.id]))
            return redirect('term_user_macros_list')
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
    return HttpResponseRedirect(reverse_lazy('term_user_macros_list'))


class ExecuteMacrosView(View, DataMixin):
    template_name = 'term/term_execute_macros.html'

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


