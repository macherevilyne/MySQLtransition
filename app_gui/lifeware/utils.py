from main.utils import validate_filename, create_name_database_with_date, get_path_name_input


def validate_filename_bestandsreport(value):
    correct_name = 'Bestandsreport'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_bewegungs_report(value):
    correct_name = 'Bewegungsreport'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_lapses_since_inception(value):
    correct_name = 'Lapse_report_as_at'
    validate_filename(value=value, correct_name=correct_name)


def validate_filename_termsheet_report(value):
    correct_name = 'Termsheet_report'
    validate_filename(value=value, correct_name=correct_name)


def _get_path_name(filename, file_folder_name):
    provider_name = 'LIFEWARE'
    path = get_path_name_input(filename=filename, file_folder_name=file_folder_name, provider_name=provider_name)
    return path


def bestandsreport_path_name(instance, filename):
    file_folder_name = 'bestandsreport'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def bewegungs_report_path_name(instance, filename):
    file_folder_name = 'bewegungs_report'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def lapses_since_inception_path_name(instance, filename):
    file_folder_name = 'lapses_since_inception'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path


def termsheet_report_path_name(instance, filename):
    file_folder_name = 'termsheet_report'
    path = _get_path_name(filename=filename, file_folder_name=file_folder_name)
    return path

