#!/bin/bash

printf "\n\n======================================\n"
printf "Making database migrations"
printf "\n======================================\n\n"
python3 ./manage.py makemigrations
python3 ./manage.py migrate

printf "\n\n======================================\n"
printf "Start the application"
printf "\n======================================\n\n"
gunicorn authors.wsgi

exit 0
