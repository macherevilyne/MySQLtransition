from django.contrib import admin

from .models import LifeWare, Parameters, UserSql, UserMacros, UserMacrosSql

admin.site.register(LifeWare)
admin.site.register(Parameters)
admin.site.register(UserSql)
admin.site.register(UserMacros)
admin.site.register(UserMacrosSql)

