from os import path
from django import forms

from .models import LifeWare, Parameters, UserSql, ExecuteSql, UserMacros, ExecuteMacros


class ClearableFileInput(forms.ClearableFileInput):
    def get_context(self, name, value, attrs):
        if value:
            value.name = path.basename(value.name)
        context = super().get_context(name, value, attrs)
        return context


class AddFilesConversionForm(forms.ModelForm):
    bestandsreport = forms.FileField(label='Bestandsreport', widget=ClearableFileInput, required=False)
    bewegungs_report = forms.FileField(label='Bewegungsreport', widget=ClearableFileInput, required=False)
    lapses_since_inception = forms.FileField(label='Lapse report as at', widget=ClearableFileInput, required=False)
    termsheet_report = forms.FileField(label='Termsheet report', widget=ClearableFileInput, required=False)

    class Meta:
        model = LifeWare
        fields = ['bestandsreport', 'bewegungs_report', 'lapses_since_inception', 'termsheet_report']


class ParametersForm(forms.ModelForm):
    val_date = forms.DateTimeField(
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
        fields = ['val_date']


class UserSqlForm(forms.ModelForm):

    class Meta:
        model = UserSql
        fields = ['name', 'query']


class ExecuteSqlForm(forms.ModelForm):
    db_name = forms.ModelChoiceField(queryset=LifeWare.objects.all())

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
    db_name = forms.ModelChoiceField(queryset=LifeWare.objects.all())

    class Meta:
        model = ExecuteMacros
        fields = ['db_name']


