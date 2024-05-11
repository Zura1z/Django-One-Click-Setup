FROM python:3.10 as build-env

ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app

# Add Pipfiles to image and install them
COPY . /app

# List all files in the current directory
RUN ls -la

# Install Pipenv and run
RUN pip install pipenv --no-cache-dir
RUN pipenv install --system --deploy

# Add Django entrypoint script to docker
COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]