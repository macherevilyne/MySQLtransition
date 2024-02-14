from django.contrib import admin

from .models import Fibas, Parameters, ExcelFile, UserSql, UserMacros, UserMacrosSql

admin.site.register(Fibas)
admin.site.register(Parameters)
admin.site.register(ExcelFile)
admin.site.register(UserSql)
admin.site.register(UserMacros)
admin.site.register(UserMacrosSql)
