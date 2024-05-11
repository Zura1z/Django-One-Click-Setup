#!/bin/bash

source DbConfig

if [ "$Database" == "postgresql" ]; then
    if [ -n "$DATABASE_NAME" ] && [ -n "$DATABASE_HOST" ] && [ -n "$DATABASE_USER" ] && [ -n "$DATABASE_PASSWORD" ] && [ -n "$DATABASE_PORT" ]; then
        cat DbConfig >> $1/../.env
        echo "Configurations copied to .env file."

if [ -z "$1"  ]; then
    echo "Usage: $0 <project_root> <project_name>"
    exit 1
fi

if [ -z "$2"  ]; then
    echo "Usage: $0 <PROJECT_ROOT> <project_name>"
    exit 1
fi
cd $1 && pipenv install psycopg2-binary && cd -
echo $PWD

settings_file="$1/$2/settings.py"
if [ ! -f "$settings_file" ]; then
    echo "Error: $settings_file does not exist."
    exit 1
fi
rm "$1/db.sqlite3"
echo "$settings_file"
sed -i '76,82d' "$settings_file"
sed -i '76i\
import os \
DATABASES = {\
    '\''default'\'': {\
        '\''ENGINE'\'': '\''django.db.backends.postgresql'\'',\
        '\''NAME'\'': os.getenv('\''DATABASE_NAME'\''),\
        '\''USER'\'': os.getenv('\''DATABASE_USER'\''),\
        '\''PASSWORD'\'': os.getenv('\''DATABASE_PASSWORD'\''),\
        '\''HOST'\'': os.getenv('\''DATABASE_HOST'\'', '\''localhost'\''),\
        '\''PORT'\'': os.getenv('\''DATABASE_PORT'\'', '\''5432'\''),\
    }\
}\
' "$settings_file"

    else
        echo "Not all database configuration values are filled. Please fill all fields before continuing."
    fi


else
    echo "Only send to .env in postgresql"
fi
