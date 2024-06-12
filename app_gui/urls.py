from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('', include('main.urls')),
    path('fibas/', include('fibas.urls')),
    path('term/', include('term.urls')),
    path('lifeware/', include('lifeware.urls')),
    path('jool/', include('jool.urls')),

    path('admin/', admin.site.urls),
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
