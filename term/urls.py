from django.urls import path

from . import views

urlpatterns = [
    path('', views.TermView.as_view(), name='term'),
    path('add_files/', views.UploadView.as_view(), name='term_add_files'),
    path('<int:pk>/', views.DatabasePageView.as_view(), name='term_database'),
    path('<int:pk>/term-data-conversion/', views.data_conversion, name='term_data_conversion'),
    path('update/<int:pk>', views.TermUpdateView.as_view(), name='term_database_update'),
    path('<int:pk>/term-parameters-entry/', views.ParametersView.as_view(), name='term_parameters_entry'),
    path('<int:pk>/term-macros/', views.MacrosView.as_view(), name='term_macros'),
    path('<int:pk>/term-macros/term-generate-monet-inputs-exp-death/', views.run_generate_monet_inputs_exp_death,
         name='term_run_generate_monet_inputs_exp_death'),
    path('<int:pk>/term-macros/term-generate-monet-inputs-term/', views.run_generate_monet_inputs_term,
         name='term_run_generate_monet_inputs_term'),
    path('<int:pk>/term-macros/term-generate-monet-inputs-exp-pl/', views.run_generate_monet_inputs_exp_pl,
         name='term_run_generate_monet_inputs_exp_pl'),
    path('<int:pk>/term-macros/term-db-check-data/', views.run_db_check_data, name='term_run_db_check_data'),
    path('<int:pk>/term-macros/term-run-check/', views.run_check, name='term_run_check'),
    path('add_sql/', views.AddSqlView.as_view(), name='term_add_sql'),
    path('edit_sql/<int:pk>/', views.EditSqlView.as_view(), name='term_edit_sql'),
    path('delete_sql/<int:sql_id>/delete/', views.delete_sql, name='term_delete_sql'),
    path('user_sql_list/', views.UserSqlListView.as_view(), name='term_user_sql_list'),
    path('execute_sql/<int:sql_id>/', views.ExecuteSqlView.as_view(), name='term_execute_sql'),
    path('custom_macros/', views.CustomMacrosView.as_view(), name='term_custom_macros'),
    path('user_macros_create/', views.UserCreateMacrosView.as_view(), name='term_user_macros_create'),
    path('edit_macros/<int:pk>/', views.EditMacrosView.as_view(), name='term_edit_macros'),
    path('delete_macros/<int:macros_id>/delete/', views.delete_macros, name='term_delete_macros'),
    path('user_macros_list/', views.UserMacrosListView.as_view(), name='term_user_macros_list'),
    path('execute_macros/<int:macros_id>/', views.ExecuteMacrosView.as_view(), name='term_execute_macros'),
]
