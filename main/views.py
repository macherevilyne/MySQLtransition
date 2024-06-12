from django.views.generic import ListView
from django.urls import reverse_lazy

from .models import Main
from .utils import DataMixin


class HomeView(ListView, DataMixin):
    model = Main
    template_name = 'main/home.html'
    success_url = reverse_lazy('home')

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        c_def = self.get_user_context(title='Main page')
        return dict(list(context.items()) + list(c_def.items()))

