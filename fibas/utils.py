from main.utils import validate_filename, get_path_name_input, validate_filename_sftp
import os
from main.helpers.conversion.helpers import read_config

def validate_filename_claims(value):
    correct_name = 'Reserveringen'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_claims_basic(value):
    correct_name = 'ClaimBasisOverzicht'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_claims_policy(value):
    correct_name = 'PolisnummerPerClaim'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_policies(value):
    correct_name = 'PremieVerzekeraar'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_claims_sftp(file_name: str):
    correct_name = 'Reserveringen'
    result = validate_filename_sftp(file_name=file_name, correct_name=correct_name)
    return result


def validate_filename_claims_basic_sftp(file_name: str):
    correct_name = 'ClaimBasisOverzicht'
    result = validate_filename_sftp(file_name=file_name, correct_name=correct_name)
    return result


def validate_filename_claims_policy_sftp(file_name: str):
    correct_name = 'PolisnummerPerClaim'
    result = validate_filename_sftp(file_name=file_name, correct_name=correct_name)
    return result


def validate_filename_policies_sftp(file_name: str):
    correct_name = 'PremieVerzekeraar'
    result = validate_filename_sftp(file_name=file_name, correct_name=correct_name)
    return result

def _get_path_name(filename, file_folder_name):
    provider_name = 'FIBAS'
    config = read_config()
    base_path = config['client'].get('base_path')
    path = get_path_name_input(filename=filename, file_folder_name=file_folder_name, provider_name=provider_name, base_path=base_path)
    return path

def claims_path_name(instance, filename):
    file_folder_name = 'claims'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def claims_basic_path_name(instance, filename):
    file_folder_name = 'claims_basic'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def claims_policy_path_name(instance, filename):
    file_folder_name = 'claims_policy'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def policies_path_name(instance, filename):
    file_folder_name = 'policies'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def monet_result_all_path_name(instance, filename):
    file_folder_name = 'MonetResultsAll'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


''' Dowload files in temp folder '''
def upload_queries_temp(instance, filename):
    temp_folder = 'temp_uploads'
    return os.path.join(temp_folder, filename)