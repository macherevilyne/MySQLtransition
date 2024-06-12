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

from .models import Jool
# from .forms import AddFilesConversionForm, ParametersForm, UserSqlForm, ExecuteSqlForm, \
#     UserMacrosForm, ExecuteMacrosForm
from .helpers.conversion.conversion import Conversion


logger = logging.getLogger(__name__)


DATABASE_NAME = 'JOOL'


# start page JOOL
class JoolView(ListView, DataMixin):
    model = Jool
    template_name = 'jool/jool_index.html'
    context_object_name = 'jool'
    success_url = reverse_lazy('jool')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['jool'] = Jool.objects.order_by('title')
        c_def = self.get_user_context(title='Jool page')
        return dict(list(context.items()) + list(c_def.items()))





