# Generated by Django 3.2.25 on 2025-01-15 15:38

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0005_recipe_images'),
    ]

    operations = [
        migrations.RenameField(
            model_name='recipe',
            old_name='images',
            new_name='image',
        ),
    ]
