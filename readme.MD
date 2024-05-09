# Django Project Setup

This README outlines the process to setup and manage a Django project using a Makefile. The Makefile automates several steps including environment setup, dependency installation, project creation, and more.

## Requirements

- Python 3.9
- Pipenv
- Docker (for Docker tasks)

## Setup Instructions

```bash
make setup PROJECT_NAME=<your_project_name>
```

Replace `<your_project_name>` with the desired name for your Django project. This command will execute all of the steps listed above in sequence, ensuring that your project is fully configured and ready for development.

This `setup` command is designed to provide a one-click solution to getting a Django project up and running, handling all initial configuration and setup tasks automatically.

## Individual Commands

1. **Environment Setup**: Sets up the Python virtual environment and necessary directories.

   ```bash
   make create_environment
   ```

2. **Install Dependencies**: Installs Django within the Pipenv environment.

   ```bash
   make install_dependencies
   ```

3. **Create Project**: Initializes a new Django project with a specified project name.

   ```bash
   make create_project PROJECT_NAME=<your_project_name>
   ```

4. **Create Core Application**: Adds a core application to the Django project.

   ```bash
   make create_core_app
   ```

5. **Database Migrations**: Run initial migrations for the Django project.

   ```bash
   make migrate
   ```

6. **Create Superuser**: Creates an admin superuser for the Django project.

   ```bash
   make superuser
   ```

7. **Prepare Resources**: Copies Dockerfile, Makefile, and entrypoint scripts to their respective locations.

   ```bash
   make prepare_resources
   ```

8. **Run Server**: Starts the Django development server.

   ```bash
   make run
   ```

9. **Testing**: Run tests for the Django project.

   ```bash
   make test
   ```

10. **Collect Static Files**: Collects all static files to the static root.

    ```bash
    make collectstatic
    ```

11. **Docker Build**: Builds the Docker container for the project.

    ```bash
    make docker/build
    ```

12. **Run Gunicorn**: Runs the Django project using Gunicorn.
    ```bash
    make run/gunicorn
    ```

## Additional Commands

- **Clean Project**: Removes SQLite database and Python cache files.
  ```bash
  make clean
  ```

Make sure to replace `<your_project_name>` with the actual name of your Django project where necessary. Adjust the `.env` and `env.template` files as per your local or production configurations.

## Note

This Makefile is optimized for development on Unix-like systems. Ensure all paths and variables are set correctly in the Makefile according to your project's directory structure.
