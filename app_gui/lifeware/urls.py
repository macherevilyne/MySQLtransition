from django.urls import path

from . import views

urlpatterns = [
    path('', views.LifeWareView.as_view(), name='lifeware'),
    path('add_files/', views.UploadView.as_view(), name='life_ware_add_files'),
    path('<int:pk>/', views.DatabasePageView.as_view(), name='life_ware_database'),
    path('<int:pk>/lifeware-data-conversion/', views.data_conversion, name='life_ware_data_conversion'),
    path('update/<int:pk>', views.LifeWareUpdateView.as_view(), name='life_ware_database_update'),
    path('<int:pk>/lifeware-parameters-entry/', views.ParametersView.as_view(), name='life_ware_parameters_entry'),
    path('<int:pk>/macros/', views.MacrosView.as_view(), name='life_ware_macros'),
    path('<int:pk>/macros/lifeware-run-check-new/', views.run_check_new, name='life_ware_run_check_new'),
    path('<int:pk>/macros/lifeware-run-termsheet-checks/', views.run_termsheet_checks, name='life_ware_run_termsheet_checks'),
    path('custom_macros/', views.CustomMacrosView.as_view(), name='life_ware_custom_macros'),
    path('add_sql/', views.AddSqlView.as_view(), name='life_ware_add_sql'),
    path('user_sql_list/', views.UserSqlListView.as_view(), name='life_ware_user_sql_list'),
    path('edit_sql/<int:pk>/', views.EditSqlView.as_view(), name='life_ware_edit_sql'),
    path('delete_sql/<int:sql_id>/delete/', views.delete_sql, name='life_ware_delete_sql'),
    path('execute_sql/<int:sql_id>/', views.ExecuteSqlView.as_view(), name='life_ware_execute_sql'),
    path('user_macros_create/', views.UserCreateMacrosView.as_view(), name='life_ware_user_macros_create'),
    path('edit_macros/<int:pk>/', views.EditMacrosView.as_view(), name='life_ware_edit_macros'),
    path('delete_macros/<int:macros_id>/delete/', views.delete_macros, name='life_ware_delete_macros'),
    path('user_macros_list/', views.UserMacrosListView.as_view(), name='life_ware_user_macros_list'),
    path('execute_macros/<int:macros_id>/', views.ExecuteMacrosView.as_view(), name='life_ware_execute_macros'),
]
