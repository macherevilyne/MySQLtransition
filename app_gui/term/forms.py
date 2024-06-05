from os import path
from django import forms

from .models import Term, Parameters, UserSql, ExecuteSql, UserMacros, ExecuteMacros


class ClearableFileInput(forms.ClearableFileInput):
    def get_context(self, name, value, attrs):
        if value:
            value.name = path.basename(value.name)
        context = super().get_context(name, value, attrs)
        return context


class AddFilesConversionForm(forms.ModelForm):
    policydata_new_report = forms.FileField(label='Policydata', widget=ClearableFileInput, required=False)
    de_hoop_data = forms.FileField(label='PolicydataDeHoop', widget=ClearableFileInput, required=False)

    class Meta:
        model = Term
        fields = ['policydata_new_report', 'de_hoop_data']


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
    date_data_extract = forms.DateTimeField(
        widget=forms.DateTimeInput(
                attrs={
                    'placeholder': 'DD/MM/YYYY',
                    'required': 'required',
                },
                format='%d/%m/%Y'
            ),
        input_formats=['%d/%m/%Y'],
        label='Date of data extract (always enter as 1st of next month)'
    )

    class Meta:
        model = Parameters
        fields = ['val_dat', 'date_data_extract', 'fib_reinsured']


class UserSqlForm(forms.ModelForm):

    class Meta:
        model = UserSql
        fields = ['name', 'query']


class ExecuteSqlForm(forms.ModelForm):
    db_name = forms.ModelChoiceField(queryset=Term.objects.all())

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
    db_name = forms.ModelChoiceField(queryset=Term.objects.all())

    class Meta:
        model = ExecuteMacros
        fields = ['db_name']
