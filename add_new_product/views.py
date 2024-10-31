import os
import re
from django.http import Http404, HttpResponse, JsonResponse
from django.shortcuts import reverse, redirect, get_object_or_404
from django.urls import reverse_lazy
from django.views.decorators.csrf import csrf_exempt
from main.helpers.sql_connection.sql_connection import Connector
from .forms import AddNewProductForm, ConversionFileNewProductForm,NewProductParametersForm
from .helpers.conversion.conversion import Conversion
from .models import New_product, ObjectsNewProduct, Parameters, ConversionFiles
from django.views.generic import ListView, CreateView, UpdateView
from main.utils import DataMixin, get_menu, check_files_name, check_files_name_update
from .utils import create_name_database_with_date_new_product
from django.db import IntegrityError
from django.shortcuts import redirect
from django.urls import reverse
import logging

logger = logging.getLogger(__name__)

# Creating a new product based on which the user enters, the name, the number of files, the name of the files

class AddNewProductView(CreateView, DataMixin):
    model = New_product
    form_class = AddNewProductForm
    template_name = 'add_new_product/add_new_product.html'
    context_object_name = 'add_new_products'

    def post(self, request, *args, **kwargs):
        form = AddNewProductForm(request.POST)
        if form.is_valid():
            files_count = int(form.cleaned_data['files_count'])
            tables_count = int(form.cleaned_data['tables_count'])
            print(tables_count, 'table_count')


            print(files_count, 'files_count')
            file_names = [request.POST.get(f'file_names_{i}') for i in range(1, files_count + 1)]
            print(file_names, 'files_names')
            table_names = [request.POST.get(f'table_names_{i}') for i in range(1, tables_count + 1)]
            print(table_names, 'table_names')

            check_names = check_files_name(form=form)
            if check_names:
                print('Приходит сюда CHECKNAMES')
                return self.render_to_response(self.get_context_data(form=form, check_names=check_names))

            try:
                self.object = form.save(commit=False)
                print(self.object, 'product')
                self.object.file_names = ','.join(file_names)
                self.object.table_names = ','.join(table_names)
                self.object.save()

                success_url = self.get_success_url(title=self.object.title)
                print(success_url, 'success_url')
                return redirect(success_url)

            except IntegrityError as e:
                if 'UNIQUE'.lower() in str(e).lower() or 'Duplicate'.lower() in str(e).lower():
                    logger.info(f'Such Product {self.object.title} entry already exists')
                    error_message = f'Such Product {self.object.title} entry already exists'
                    return self.render_to_response(self.get_context_data(
                        form=form,
                        check_names=check_names,
                        error_message=error_message
                    ))
                else:
                    logger.error(f"An unexpected IntegrityError occurred: {e}")
                    return self.render_to_response(self.get_context_data(
                        form=form,
                        error_message='An unexpected error occurred.'
                    ))

        else:
            print(form.errors)
            return self.form_invalid(form)

    def form_invalid(self, form):
        context = self.get_context_data(form=form)
        return self.render_to_response(context)

    def get_success_url(self, title):
        print(f"Generating URL for title: {title}")
        return reverse('new_product', kwargs={'title': title})

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['form'] = self.form_class()
        context['add_new_products'] = New_product.objects.order_by('title')
        c_def = self.get_user_context(title='Add New Product Page')
        context['menu'] = get_menu()
        return dict(list(context.items()) + list(c_def.items()))


# Page new product

class NewProductView(ListView, DataMixin):
    model = ObjectsNewProduct
    template_name = 'add_new_product/new_product_index.html'
    context_object_name = 'new_product_objects'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        title = self.kwargs.get('title')
        context['products_objects'] = ObjectsNewProduct.objects.filter(new_product__title=title)
        objects = ObjectsNewProduct.objects.all()
        print(objects, 'objects')
        context['title'] = title
        c_def = self.get_user_context()
        return dict(list(context.items()) + list(c_def.items()))


# The page for uploading the CSV file for conversion
# with checking the correctness of the file name and fields for uploading it
class NewProductUploadView(CreateView, DataMixin):
    form_class = ConversionFileNewProductForm
    template_name = 'add_new_product/new_product_add_files.html'

    def get_success_url(self):
        title = self.kwargs.get('title')
        pk = self.object.pk if self.object else None

        print(f"Debug: get_success_url called with title={title} and pk={pk}")
        logger.debug(f"get_success_url called with title={title} and pk={pk}")

        return reverse('new_product_parameters_entry', kwargs={'title': title, 'pk': pk})

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        product_title = self.kwargs.get('title')
        print(product_title, 'PRODUCT PARAMENTS')
        product = New_product.objects.get(title=product_title)
        file_names = product.file_names
        print(file_names, 'FILE_names')
        files_count = product.files_count
        table_names = product.table_names  # Получаем имена таблиц из продукта
        tables_count = product.tables_count  # Получаем количество таблиц

        print(f"Debug: product_title: {product_title}")
        print(f"Debug: file_names: {file_names}, file count: {files_count}")
        print(f"Debug: table_names: {table_names}, table count: {tables_count}")

        kwargs.update({
            'product': product,
            'file_names': file_names,
            'files_count':files_count,
            'table_names': table_names,
            'tables_count': tables_count,
        })
        return kwargs

    def form_valid(self, form):
        if form.is_valid():
            # Проверка имен файлов с помощью функции `check_files_name`
            check_names = check_files_name(form=form)
            if check_names:
                print('Приходит сюда CHECKNAMES')
                return self.render_to_response(self.get_context_data(form=form, check_names=check_names))

            try:
                # Извлечение данных из очищенной формы
                files = self.request.FILES
                print(files, 'FILES FROM REQUEST')
                print(files, 'FILES CLEANED DATA')

                # Список загруженных имен файлов и выбранных таблиц из формы
                uploaded_file_names = form.uploaded_file_names
                selected_table_names = form.selected_table_names
                print(uploaded_file_names, 'Uploaded file names')
                print(selected_table_names, 'Selected table names')

                # Получение или создание объекта `New_product` на основе заголовка
                product_title = self.kwargs.get('title')
                print(f"Debug: product_title: {product_title}")
                product, created = New_product.objects.get_or_create(title=product_title)

                # Название базы данных (можно изменить под ваши требования)
                provider_name = product.title

                # Создание объекта `ObjectsNewProduct`
                conversion_product = ObjectsNewProduct.objects.create(
                    new_product=product,
                    title=create_name_database_with_date_new_product(
                        filename=uploaded_file_names[0],
                        database_name=provider_name
                    )
                )

                # Сохранение объекта `conversion_product` в self.object
                self.object = conversion_product
                print(conversion_product, 'conversion_product')

                # Сохранение файлов и выбранных таблиц в модель `ConversionFiles`
                for index, (file_field, file) in enumerate(files.items()):
                    print(index)
                    print(file, 'file')
                    print(files.items, 'files.items')
                    print(file_field, 'File field')


                    # Получение имени таблицы из списка выбранных таблиц на основе индекса
                    table_name = selected_table_names[index] if index < len(
                        selected_table_names) else 'Default Table Name'
                    print(f"Creating ConversionFiles with table_name: {table_name}")

                    # Создание объекта `ConversionFiles`
                    ConversionFiles.objects.create(
                        new_product=product,
                        product_object=conversion_product,
                        files=file,
                        table_name=table_name,  # Указание выбранного имени таблицы
                    )

                # Редирект на успешный URL
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
        title = self.kwargs.get('title')
        context['title'] = title
        context['pk'] = self.kwargs.get('pk')
        c_def = self.get_user_context(title=f'Add files')
        print(f"Debug: title in context: {title}")  # Отладочный вывод
        return dict(list(context.items()) + list(c_def.items()))

# Input/update page for the ValDat and product type parameters
# with checks:
# - correct input of ValDat
# - existence of ValDat in the database, if there is updates
class NewProductParametersView(CreateView, DataMixin):
    model = Parameters
    form_class = NewProductParametersForm
    template_name = 'add_new_product/new_product_parameters_entry.html'
    allow_empty = False

    def form_valid(self, form):
        pk = self.kwargs.get('pk')
        print(pk, 'pk v paraments')
        form.instance.new_product_id = pk

        if Parameters.objects.filter(new_product=pk).exists():
            parameters = Parameters.objects.get(new_product=pk)
            parameters.product_type = form.cleaned_data.get('product_type')
            parameters.val_dat_old = parameters.val_dat
            parameters.val_dat = form.cleaned_data.get('val_dat')
            parameters.max_disable = form.cleaned_data.get('max_disable')
            parameters.save()

            self.object = parameters
        else:
            self.object = form.save()

        return redirect(self.get_success_url())



    def get_success_url(self):
        title = self.kwargs.get('title')
        pk = self.kwargs.get('pk') # Проверяем, что self.object не пустой

        print(f"Debug: get_success_url called with title={title} and pk={pk}")

        logger.debug(f"get_success_url called with title={title} and pk={pk}")

        return reverse('new_product_database', kwargs={'title': title, 'pk': pk})


    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        title = self.kwargs.get('title')

        print(f"Debug: pk={pk}, title={title}")  # Отладочный вывод

        if ObjectsNewProduct.objects.filter(id=pk).exists():
            new_product = ObjectsNewProduct.objects.get(id=pk)
            title = new_product.title
            context['pk'] = pk
            context['title'] = title
            c_def = self.get_user_context()
            return dict(list(context.items()) + list(c_def.items()))
        else:
            print("Debug: Object not found for pk=", pk)  # Отладочный вывод
            raise Http404()

# Database page

class NewProductDatabasePageView(ListView, DataMixin):
    model = ObjectsNewProduct
    template_name = 'add_new_product/new_product_database.html'
    success_url = reverse_lazy('new_product_database')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        title = self.kwargs.get('title')
        print(f"Debug: pk={pk}, title={title} Сюда пришло")  # Отладочный вывод

        if ObjectsNewProduct.objects.filter(id=pk).exists():
            new_product_object = ObjectsNewProduct.objects.get(id=pk)
            title = new_product_object.title

            related_files = ConversionFiles.objects.filter(product_object=new_product_object)

            sql = Connector()
            check_db_new_product = sql.check_database(title)
            if check_db_new_product:
                table1 = sql.check_table(db_name=title, table_name='table1')
                context['table1'] = table1

            context['pk'] = pk
            context['title'] = title
            context['new_product_object'] = new_product_object
            context['related_files'] = related_files  # Передаем связанные файлы в контекст
            context['check_db_new_product'] = check_db_new_product
            c_def = self.get_user_context(title=title)
            return dict(list(context.items()) + list(c_def.items()))
        else:
            print("Debug: Object not found for pk=", pk)  # Отладочный вывод
            raise Http404()



# Converting CSV files to a database
@csrf_exempt
def data_conversion_new_product(request, title, pk):
    if request.method == 'POST':
        try:
            # Проверяем, существует ли объект продукта с данным pk
            if ObjectsNewProduct.objects.filter(id=pk).exists():
                new_object_product = ObjectsNewProduct.objects.get(id=pk)
                provider_name = new_object_product.new_product.title  # Получаем название поставщика

                print(new_object_product, 'new_object_product')

                if ConversionFiles.objects.filter(product_object=new_object_product).exists():
                    file_obj = ConversionFiles.objects.filter(product_object=new_object_product).first()

                    filename = os.path.basename(file_obj.files.name)
                    print(filename, 'filename')

                    db_name = create_name_database_with_date_new_product(filename=filename, database_name=provider_name)
                    print(db_name, 'db_name')

                    Connector().create_database(db_name)
                    Conversion(provider_name).run(db_name)
                    print(db_name, 'DB_NAME')


        except Exception as e:
            response = str(e)
            logger.error(response)
            return HttpResponse(response)

        return HttpResponse('Done')

    raise Http404()


# CSV file update page in db
# checking the names of uploaded files

class NewproductUpdateView(UpdateView, DataMixin):
    model = ObjectsNewProduct
    form_class = ConversionFileNewProductForm
    template_name = 'add_new_product/new_product_update_files.html'
    context_object_name = 'new_product'

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()

        full_title = self.kwargs.get('title')
        print(full_title, 'FULL PRODUCT TITLE')

        base_title = full_title.rsplit('_', 1)[0].lower()  # Используем rsplit для обрезки справа
        print(base_title, 'BASE PRODUCT TITLE')

        try:
            product = New_product.objects.get(title=base_title)
        except New_product.DoesNotExist:
            print(f"Debug: New_product with title '{base_title}' does not exist.")
            raise Http404(f"Product with title '{base_title}' does not exist.")

        file_names = product.file_names
        print(file_names, 'FILE_NAMES')
        files_count = product.files_count
        conversion_files = ConversionFiles.objects.filter(product_object__new_product=product)
        current_files = [cf.files for cf in conversion_files]

        kwargs.update({
            'product': product,
            'file_names': file_names,
            'files_count': files_count,
            'current_files': current_files
        })
        return kwargs

    def get_success_url(self):
        title = self.kwargs.get('title')
        pk = self.kwargs.get('pk')
        print(f"Debug: get_success_url called with title={title} and pk={pk}")
        logger.debug(f"get_success_url called with title={title} and pk={pk}")
        return reverse('new_product_database', kwargs={'title': title, 'pk': pk})

    def form_valid(self, form):
        if form.is_valid():
            obj_name = ObjectsNewProduct.objects.get(id=self.object.pk)
            obj_date = re.findall(r'\d+', str(obj_name))

            check_names = check_files_name_update(form=form, check_date=obj_date[0])
            if check_names:
                return self.render_to_response(self.get_context_data(form=form, check_names=check_names))

            conversion_files = ConversionFiles.objects.filter(product_object=obj_name)
            for conversion_file in conversion_files:
                if conversion_file.files:
                    conversion_file.files.delete(save=False)
                conversion_file.delete()

            for i in range(form.files_count):
                uploaded_file = form.cleaned_data.get(f'file_{i}')
                if uploaded_file:
                    new_conversion_file = ConversionFiles(
                        new_product=obj_name.new_product,
                        product_object=obj_name,
                        files=uploaded_file
                    )
                    new_conversion_file.save()

            else:
                self.object = form.save()
                return redirect(self.get_success_url())
        logger.error('Update csv form is not valid')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        pk = self.kwargs.get('pk')
        print(f"Debug: Context pk={pk}")
        if ObjectsNewProduct.objects.filter(id=pk).exists():
            new_object = ObjectsNewProduct.objects.get(id=pk)
            title = new_object.title
            print(f"Debug: Found title={title}")
            context['pk'] = pk
            context['title'] = title
            context['form'] = self.get_form()
            c_def = self.get_user_context(title=f'Update files for {title}')
            print(f"Debug: Context data: {context}")
            return dict(list(context.items()) + list(c_def.items()))
        print("Debug: Object not found for pk=", pk)
        raise Http404()

