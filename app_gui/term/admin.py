from django.contrib import admin

from .models import Term, Parameters, UserSql, UserMacros, UserMacrosSql

admin.site.register(Term)
admin.site.register(Parameters)
admin.site.register(UserSql)
admin.site.register(UserMacros)
admin.site.register(UserMacrosSql)

