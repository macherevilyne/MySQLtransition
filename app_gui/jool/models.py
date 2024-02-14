from django.db import models

# Create your models here.

class Jool(models.Model):
    title = models.CharField(max_length=50, unique=True, editable=False)
    slug = models.SlugField(unique=True)
    class Meta:
        verbose_name_plural = "Jool"

    def __str__(self):
        return self.title
