from sqlalchemy import ForeignKey,  String
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


list_coluns = ['Insurer Name', 'Insurer Contract Id', 'Product name', 'Product Calculation engine',
               'Policy Terms', 'Policy Number', 'Policy Application Date', 'Policy Start Date', 'Policy Status',
               'Policy Status modification date', 'Policy Term', 'Policy Cancel date', 'Policy Cancellation reason',
               'PH Initials', 'PH Surname', 'PH Date of Birth', 'PH Street', 'PH Number', 'PH Zipcode', 'PH City',
               'PH AddressLine1', 'PH AddressLine2', 'Insured1 Surname', 'Insured1 Initials', 'Insured1 SSN',
               'Insured1 Date of Birth', 'Insured1 Gender', 'Insured1 Height', 'Insured1 Weight',
               'Insured1 Smoker Status', 'Insured1 Sum assured', 'Insured1 Type of cover',
               'Insured1 Annuity interest percentage', 'Insured1 Extra mortality rate', 'Insured2 Surname',
               'Insured2 Initials', 'Insured2 SSN', 'Insured2 Date of Birth', 'Insured2 Gender', 'Insured2 Height',
               'Insured2 Weight', 'Insured2 Smoker Status', 'Insured2 Sum assured', 'Insured2 Type of cover',
               'Insured2 Annuity interest percentage', 'Insured2 Extra mortality rate', 'Option Terminal Illness',
               'Option Premium Exemption Disability', 'Option Accident cover', 'Option Surrender value',
               'Option Surviving Dependants Children', 'Life annuity clause', 'Split premium',
               'PremiumPayer=PolicyHolder', 'PremiumPayerIDAvailable', 'Payment method', 'One Off Fee',
               'Premium Payment Duration', 'Premium End date', 'Adminoffice commission', 'Discount percentage',
               'Insured premium periodic', 'Insured premium single', 'Insured gross premium periodic',
               'Insured gross premium single', 'Insurer premium periodic', 'Insurer premium single',
               'Intermediary commission', 'Intermediary commission rate', 'Wholesaler commission',
               'Wholesaler commission rate', 'Intermediary id', 'Intermediary name', 'Wholesaler id',
               'Wholesaler name', 'Pledgee id', 'Pledgee name', 'Deed of pledge received', 'Insured1 Income',
               'Insured1 Assets', 'Insured1 OccupationLevel', 'Insured1 EducationLevel', 'Insured2 Income',
               'Insured2 Assets', 'Insured2 OccupationLevel', 'Insured2 EducationLevel', 'BMI override',
               'benefitterm', 'Change policy info', 'Option Surviving Deceased Children', 'name first beneficiary',
               'date of birth first beneficiary', 'gender first beneficiary', 'mortaged', 'guaranteedloading',
               'final age of claimpayment', 'sum assured children', 'Insured1 sum assured at enddate',
               'Insured2 sum assured at enddate', 'productgroup', 'Medical office']


class User(Base):
    __tablename__ = "Policydata_NewReport"
