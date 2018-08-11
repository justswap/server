#!/usr/bin/env bash
cd src

python wait_redis_postgres.py
python manage.py migrate

touch /tmp/.done.info
daphne -b 0.0.0.0 -p 8001 config.asgi:application
