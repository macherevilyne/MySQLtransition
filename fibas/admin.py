from django.contrib import admin

from .models import Fibas, Parameters, ExcelFile, UserSql, UserMacros, UserMacrosSql, UserQuery,User_Custom_Macros, UserCustomMacrosSql

admin.site.register(Fibas)
admin.site.register(Parameters)
admin.site.register(ExcelFile)
admin.site.register(UserSql)
admin.site.register(UserMacros)
admin.site.register(UserMacrosSql)
admin.site.register(UserQuery)
admin.site.register(User_Custom_Macros)
admin.site.register(UserCustomMacrosSql)

