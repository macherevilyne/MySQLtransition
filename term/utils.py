from main.utils import validate_filename, create_name_database_with_date, get_path_name_input


def validate_filename_policydata_new_report(value):
    correct_name = 'Policydata'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_de_hoop_data(value):
    correct_name = 'PolicydataDeHoop'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_claims(value):
    correct_name = 'Claim_ORV_report'
    validate_filename(value=value, correct_name=correct_name)


def _get_path_name(filename, file_folder_name):
    provider_name = 'TERM'
    path = get_path_name_input(filename=filename, file_folder_name=file_folder_name, provider_name=provider_name)
    return path


def policydata_new_report_path_name(instance, filename):
    file_folder_name = 'policydata_new_report'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def de_hoop_data_path_name(instance, filename):
    file_folder_name = 'de_hoop_data'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def claims_path_name(instance, filename):
    file_folder_name = 'claims'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path
