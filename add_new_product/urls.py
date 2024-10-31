from django.urls import path

from . import views

urlpatterns = [

    path('add/', views.AddNewProductView.as_view(), name='add_new_product'),
    path('<str:title>/', views.NewProductView.as_view(), name='new_product'),
    path('<str:title>/add_files/', views.NewProductUploadView.as_view(), name='new_product_add_files'),
    path('<str:title>/<int:pk>/new_product-parameters-entry/', views.NewProductParametersView.as_view(), name='new_product_parameters_entry'),
    path('<str:title>/<int:pk>/', views.NewProductDatabasePageView.as_view(), name='new_product_database'),
    path('<str:title>/<int:pk>/new-product-data-conversion/', views.data_conversion_new_product, name='data_conversion_new_product'),
    path('<str:title>/<int:pk>/update/', views.NewproductUpdateView.as_view(), name='new_product_database_update'),

]