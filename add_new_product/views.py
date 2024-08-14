from django.shortcuts import reverse, redirect

from .forms import AddNewProductForm, ConversionFileNewProductForm
from .models import New_product, ConversionFileNewProduct
from django.views.generic import ListView, CreateView
from main.utils import DataMixin, get_menu, check_files_name
import logging
logger = logging.getLogger(__name__)
from django.db import IntegrityError


# Создание нового продукта

class AddNewProductView(CreateView, DataMixin):
    model = New_product
    form_class = AddNewProductForm
    template_name = 'add_new_product/add_new_product.html'
    context_object_name = 'add_new_products'

    def post(self, request, *args, **kwargs):

        form = AddNewProductForm(request.POST)
        if form.is_valid():
            files_count = int(form.cleaned_data['files_count'])
            print(files_count, 'files_count')
            file_names = [request.POST.get(f'file_names_{i}') for i in range(1, files_count + 1)]
            print(file_names, 'files_names')
            product = form.save(commit=False)
            print(product, 'product')
            product.file_names = ','.join(file_names)  # Объединение имен файлов в одну строку
            product.save()
            success_url = self.get_success_url(title=product.title)
            print(success_url, 'success_url')  # Добавьте отладочное сообщение для success_url
            return redirect(success_url)
        else:
            print(form.errors)  # Log form errors
            return self.form_invalid(form)

    def form_invalid(self, form):
        # Обновите контекст, чтобы включить форму с ошибками
        context = self.get_context_data(form=form)
        return self.render_to_response(context)

    def get_success_url(self, title):
        # Убедитесь, что title передается правильно и является строкой
        print(f"Generating URL for title: {title}")
        return reverse('new_product', kwargs={'title': title})

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['form'] = self.form_class()
        context['add_new_products'] = New_product.objects.order_by('title')
        c_def = self.get_user_context(title='Add New Product Page')
        context['menu'] = get_menu()
        return dict(list(context.items()) + list(c_def.items()))

# Страница нового продукта

class NewProductView(ListView, DataMixin):
    model = New_product
    template_name = 'add_new_product/new_product_index.html'
    context_object_name = 'new_product'

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['add_new_products'] = New_product.objects.order_by('title')
        title = self.kwargs.get('title', 'Default Title')
        c_def = self.get_user_context(title=title)
        return dict(list(context.items()) + list(c_def.items()))


# CSV file upload page
# with verification of the correctness of the file name and their upload fields
class NewProductUploadView(CreateView, DataMixin):
    form_class = ConversionFileNewProductForm
    template_name = 'add_new_product/new_product_add_files.html'

    def get_success_url(self):
        return reverse('fibas_parameters_entry', kwargs={'pk': self.object.pk})

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        product_title = self.kwargs.get('title')
        product = New_product.objects.get(title=product_title)
        # Допустим, у вас есть метод получения списка имен файлов для продукта
        file_names = product.file_names
        print(file_names, 'FILE_names')
        files_count = product.files_count
        kwargs.update({
            'product': product,
            'file_names': file_names,
            'files_count':files_count
        })
        return kwargs

    def form_valid(self, form):
        if form.is_valid():
            check_names = check_files_name(form=form)
            if check_names:
                return self.render_to_response(self.get_context_data(form=form, check_names=check_names))

            try:
                files = form.cleaned_data
                uploaded_file_names = form.uploaded_file_names  # Получаем список имен файлов
                print(files, 'FILES CLEANED')
                print(uploaded_file_names, 'UPLOADED FILE NAMES')  # Выводим имена файлов для отладки
                product_title = self.kwargs.get('title')
                print(f"Debug: product_title: {product_title}")  # Отладочный вывод
                product = New_product.objects.get(title=product_title)

                for file_field, file in files.items():
                    if file:
                        # Используем имя файла из списка uploaded_file_names
                        ConversionFileNewProduct.objects.create(
                            new_product=product,
                            files=file.name  # Используем имя загруженного файла
                        )

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
        c_def = self.get_user_context(title=f'Add files')
        print(f"Debug: title in context: {title}")  # Отладочный вывод
        return dict(list(context.items()) + list(c_def.items()))
