OS := $(shell uname -s 2>/dev/null || echo not)

.PHONY: setup
setup:
	make migrate
	make superuser
	make run
	
.PHONY: run
run:
	pipenv run python src/manage.py runserver 0.0.0.0:8001

	
.PHONY: superuser
superuser:
	DJANGO_SUPERUSER_PASSWORD=admin pipenv run python src/manage.py createsuperuser --no-input --email admin@admin.com --username admin

.PHONY: migrate
migrate: 
	pipenv run python src/manage.py makemigrations
	pipenv run python src/manage.py makemigrations core
	pipenv run python src/manage.py migrate	

.PHONY: clean
clean: 
	rm -rf ./src/db.sqlite3
	rm -rf ./src/__pycache__
	rm -rf ./src/core/__pycache__

.PHONY: migration_reset
migration_reset:
	rm -rf ./src/core/migrations


.PHONY: collectstatic
collectstatic:
	pipenv run python src/manage.py collectstatic --no-input

.PHONY: run/gunicorn
run/gunicorn:
	PYTHONPATH=src gunicorn %app_name%.wsgi:application --bind 0.0.0.0:8000

.PHONY: docker/build
docker/build:
	docker build -f ./Dockerfile -t event_backend:latest .
