from os import path
from django import forms

from .models import Fibas, Parameters, ExcelFile, UserSql, ExecuteSql, UserMacros, ExecuteMacros, UserQuery, \
    ExecuteQuery


class ClearableFileInput(forms.ClearableFileInput):
    def get_context(self, name, value, attrs):
        if value:
            value.name = path.basename(value.name)
        context = super().get_context(name, value, attrs)
        return context


class AddFilesConversionForm(forms.ModelForm):
    claims = forms.FileField(label='Reserveringen', widget=ClearableFileInput, required=False)
    claims_basic = forms.FileField(label='ClaimBasisOverzicht', widget=ClearableFileInput, required=False)
    claims_policy = forms.FileField(label='PolisnummerPerClaim', widget=ClearableFileInput, required=False)
    policies = forms.FileField(label='PremieVerzekeraar', widget=ClearableFileInput, required=False)

    class Meta:
        model = Fibas
        fields = ['claims', 'claims_basic', 'claims_policy', 'policies']


class ParametersForm(forms.ModelForm):
    val_dat = forms.DateTimeField(
        widget=forms.DateTimeInput(
                attrs={
                    'placeholder': 'DD/MM/YYYY',
                    'required': 'required'
                },
                format='%d/%m/%Y'
            ),
        input_formats=['%d/%m/%Y']
    )

    class Meta:
        model = Parameters
        fields = ['val_dat', 'product_type', 'max_disable']


class ExcelFileForm(forms.ModelForm):
    file = forms.FileField(label='MonetResultsAll', widget=forms.FileInput)

    class Meta:
        model = ExcelFile
        fields = ['file']


class UserSqlForm(forms.ModelForm):

    class Meta:
        model = UserSql
        fields = ['name', 'query']


class UserQueryForm(forms.ModelForm):

    class Meta:
        model = UserQuery
        fields = [ 'query_file']

class ExecuteQueryForm(forms.ModelForm):
    db_name = forms.ModelChoiceField(queryset=Fibas.objects.all())

    class Meta:
        model = ExecuteQuery
        fields = ['db_name']


class ExecuteSqlForm(forms.ModelForm):
    db_name = forms.ModelChoiceField(queryset=Fibas.objects.all())

    class Meta:
        model = ExecuteSql
        fields = ['db_name']


class UserMacrosForm(forms.ModelForm):
    order = forms.IntegerField(widget=forms.HiddenInput(), required=False)

    class Meta:
        model = UserMacros
        fields = ['name_macros', 'user_sql']
        widgets = {'user_sql': forms.CheckboxSelectMultiple(attrs={'class': "checkbox"})}


class ExecuteMacrosForm(forms.ModelForm):
    db_name = forms.ModelChoiceField(queryset=Fibas.objects.all())

    class Meta:
        model = ExecuteMacros
        fields = ['db_name']
