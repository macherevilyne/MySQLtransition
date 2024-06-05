from django.urls import path

from . import views

urlpatterns = [
    path('', views.FibasView.as_view(), name='fibas'),
    path('add_files/', views.UploadView.as_view(), name='fibas_add_files'),
    path('<int:pk>/', views.DatabasePageView.as_view(), name='fibas_database'),
    path('<int:pk>/fibas-data-conversion/', views.data_conversion, name='fibas_data_conversion'),
    path('update/<int:pk>', views.FibasUpdateView.as_view(), name='fibas_database_update'),
    path('<int:pk>/fibas-parameters-entry/', views.ParametersView.as_view(), name='fibas_parameters_entry'),


    path('<int:pk>/macros/', views.MacrosView.as_view(), name='fibas_macros'),
    path('<int:pk>/macros/fibas-run-db-checks/', views.run_db_checks, name='fibas_run_db_checks'),
    path('<int:pk>/macros/fibas-run-monetinputs/', views.run_m_monetinputs, name='fibas_run_monetinputs'),
    path('<int:pk>/macros/fibas-run-check/', views.run_check, name='fibas_run_check'),
    path('<int:pk>/macros/fibas-run-all-macros/', views.run_all_macros, name='fibas_run_all_macros'),

    path('<int:pk>/fibas-upload-excel-file/', views.UploadExcelView.as_view(), name='fibas_upload_excel_file'),
    path('<int:pk>/fibas-upload-excel-file/fibas-convert-monet-results-all/', views.convert_monet_results_all,
         name='convert_monet_results_all'),
    path('<int:pk>/fibas-queries/', views.QueriesView.as_view(), name='fibas_queries'),
    path('<int:pk>/fibas-query/<str:sql_file>/', views.QueryView.as_view(), name='fibas_query_with_file'),
    path('custom_macros/', views.CustomMacrosView.as_view(), name='fibas_custom_macros'),
    path('add_sql/', views.AddSqlView.as_view(), name='fibas_add_sql'),
    path('upload_query/', views.Fibas_upload_query.as_view(), name='fibas_upload_query'),
    path('fibas_history_query_list/<str:db_name>/', views.FibasUserHistoryQueryListView.as_view(),name='fibas_history_query_list'),
    path('user_sql_list/', views.UserSqlListView.as_view(), name='fibas_user_sql_list'),
    path('edit_sql/<int:pk>/', views.EditSqlView.as_view(), name='fibas_edit_sql'),
    path('delete_sql/<int:sql_id>/delete/', views.delete_sql, name='fibas_delete_sql'),
    path('execute_sql/<int:sql_id>/', views.ExecuteSqlView.as_view(), name='fibas_execute_sql'),
    path('execute_query/<str:db_name>/<int:query_id>/', views.ExecuteQueryView.as_view(), name='fibas_execute_query'),

    path('user_macros_create/', views.UserCreateMacrosView.as_view(), name='fibas_user_macros_create'),
    # path('macros/<str:db_name>/fibas-create-custom-macros/', views.UserCreateCustomMacrosView, name='fibas_create_custom_macros'),
    path('edit_macros/<int:pk>/', views.EditMacrosView.as_view(), name='fibas_edit_macros'),
    path('delete_macros/<int:macros_id>/delete/', views.delete_macros, name='fibas_delete_macros'),
    path('user_macros_list/', views.UserMacrosListView.as_view(), name='fibas_user_macros_list'),
    path('execute_macros/<int:macros_id>/', views.ExecuteMacrosView.as_view(), name='fibas_execute_macros'),

    path('sftp/', views.SFTPFileManagerView.as_view(), name='fibas_sftp_file_manager'),
    path('sftp/<path:path>/', views.SFTPFileManagerView.as_view(), name='fibas_sftp_file_manager'),

]

