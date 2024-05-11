PROJECT_ROOT = backend/src
DJANGO_PROJECT_NAME = $(PROJECT_NAME)

.PHONY: setup
setup: create_environment install_dependencies create_project create_core_app add_core_app_to_settings database_setup migrate superuser prepare_resources run

.PHONY: create_environment
create_environment:
	mkdir -p $(PROJECT_ROOT)  
	echo "PYTHONUNBUFFERED=1" >> $(PROJECT_ROOT)/../.env  

	python_version=$$(python3 -V 2>&1 | grep -o '[0-9.]*' | head -n1) && \
	cd backend && pipenv --python $$python_version && \
	echo "Python version is $$python_version"

.PHONY: install_dependencies
install_dependencies:
	cd backend && pipenv install django

.PHONY: create_project
create_project:
	cd $(PROJECT_ROOT) && pipenv run django-admin startproject $(DJANGO_PROJECT_NAME) .
	cd $(PROJECT_ROOT)/$(DJANGO_PROJECT_NAME) && ls -la  # List to verify creation

.PHONY: create_core_app
create_core_app:
	cd $(PROJECT_ROOT) && pipenv run python manage.py startapp core
	ls -la $(PROJECT_ROOT)/core  # Verify app creation

.PHONY: add_core_app_to_settings
add_core_app_to_settings:
	echo "INSTALLED_APPS += ['core',]" >> $(PROJECT_ROOT)/$(DJANGO_PROJECT_NAME)/settings.py

.PHONY: prepare_resources
prepare_resources:
	cp resources/Dockerfile backend/
	cp resources/Makefile backend/
	mkdir -p $(PROJECT_ROOT)/scripts  # Ensure the scripts directory exists
	cp resources/entrypoint.sh $(PROJECT_ROOT)/scripts/
	echo "DEBUG=True\nSECRET_KEY=YourSecretKeyHere\nDATABASE_URL=postgres://USER:PASSWORD@HOST:PORT/DBNAME" > $(PROJECT_ROOT)/../env.template
	cat $(PROJECT_ROOT)/../env.template >> $(PROJECT_ROOT)/../.env 

.PHONY: run
run:
	cd $(PROJECT_ROOT) && pipenv run python manage.py runserver 0.0.0.0:8000

.PHONY: superuser
superuser:
	cd $(PROJECT_ROOT) && DJANGO_SUPERUSER_PASSWORD=admin pipenv run python manage.py createsuperuser --no-input \
	    --username admin@admin.com \
	    --email admin@admin.com

.PHONY: database_setup
database_setup:
	bash resources/database.sh $(PROJECT_ROOT) $(PROJECT_NAME)
.PHONY: migrate
migrate:
	cd $(PROJECT_ROOT) && pipenv run python manage.py makemigrations
	cd $(PROJECT_ROOT) && pipenv run python manage.py migrate

.PHONY: clean
clean:
	rm -rf $(PROJECT_ROOT)/db.sqlite3
	rm -rf $(PROJECT_ROOT)/__pycache__
	rm -rf $(PROJECT_ROOT)/core/__pycache__

.PHONY: collectstatic
collectstatic:
	cd $(PROJECT_ROOT) && pipenv run python manage.py collectstatic --no-input

.PHONY: test
test:
	cd $(PROJECT_ROOT) && pipenv run python manage.py test

.PHONY: docker/build
docker/build:
	docker build -f backend/Dockerfile -t $(PROJECT_NAME)-prod:latest .

.PHONY: run/gunicorn
run/gunicorn:
	PYTHONPATH=$(PROJECT_ROOT) gunicorn src.wsgi:application --bind 0.0.0.0:8000
