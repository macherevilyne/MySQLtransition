from django.urls import path

from . import views

urlpatterns = [

    path('add/', views.AddNewProductView.as_view(), name='add_new_product'),
    path('<str:title>/', views.NewProductView.as_view(), name='new_product'),
    path('<str:title>/add_files/', views.NewProductUploadView.as_view(), name='new_product_add_files'),

    # path('<int:pk>/new-product-parameters-entry/', views.NewProductParametersView.as_view(), name='fibas_parameters_entry'),
]