# Generated by Django 2.1.5 on 2019-02-12 08:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('profiles', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='image',
            field=models.URLField(default=None, null=True),
        ),
    ]