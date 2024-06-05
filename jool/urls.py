from django.urls import path

from . import views

urlpatterns = [
    path('', views.JoolView.as_view(), name='jool'),
    # path('add_files/', views.UploadView.as_view(), name='jool_add_files'),
    # path('<int:pk>/', views.DatabasePageView.as_view(), name='jool_database'),
    # path('<int:pk>/jool-data-conversion/', views.data_conversion, name='jool_data_conversion'),
    # path('update/<int:pk>', views.JoolUpdateView.as_view(), name='jool_database_update'),
    # path('<int:pk>/jool-parameters-entry/', views.ParametersView.as_view(), name='jool_parameters_entry'),
    # path('<int:pk>/macros/', views.MacrosView.as_view(), name='jool_macros'),
    # path('<int:pk>/macros/jool-run-check-new/', views.run_check_new, name='jool_run_check_new'),
    # path('<int:pk>/macros/jool-run-termsheet-checks/', views.run_termsheet_checks, name='jool_run_termsheet_checks'),
    # path('custom_macros/', views.CustomMacrosView.as_view(), name='jool_custom_macros'),
    # path('add_sql/', views.AddSqlView.as_view(), name='jool_add_sql'),
    # path('user_sql_list/', views.UserSqlListView.as_view(), name='jool_user_sql_list'),
    # path('edit_sql/<int:pk>/', views.EditSqlView.as_view(), name='jool_edit_sql'),
    # path('delete_sql/<int:sql_id>/delete/', views.delete_sql, name='jool_delete_sql'),
    # path('execute_sql/<int:sql_id>/', views.ExecuteSqlView.as_view(), name='jool_execute_sql'),
    # path('user_macros_create/', views.UserCreateMacrosView.as_view(), name='jool_user_macros_create'),
    # path('edit_macros/<int:pk>/', views.EditMacrosView.as_view(), name='jool_edit_macros'),
    # path('delete_macros/<int:macros_id>/delete/', views.delete_macros, name='jool_delete_macros'),
    # path('user_macros_list/', views.UserMacrosListView.as_view(), name='jool_user_macros_list'),
    # path('execute_macros/<int:macros_id>/', views.ExecuteMacrosView.as_view(), name='jool_execute_macros'),
]
