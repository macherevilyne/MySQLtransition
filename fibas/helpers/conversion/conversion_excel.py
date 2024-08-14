from main.helpers.conversion.helpers import HelpersConversion


# converters Excel file to MySQL, table:  "MonetResultsAll"
class ConversionExcel:

    def __init__(self):
        self.helpers_conversion = HelpersConversion()
        self.provider_name = 'FIBAS'

    def monet_results_all(self, db_name: str,base_path:str):
        folder_name = 'MonetResultsAll'
        file_name = 'MonetResultsAll'
        name_new_table = 'MonetResultsAll'
        self.helpers_conversion.transfer_excel_to_mysql(file_folder_name=folder_name, provider_name=self.provider_name,
                                                        file_name=file_name, name_new_table=name_new_table,
                                                        db_name=db_name,bath_path=base_path)


