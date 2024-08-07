FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# that's saying when we use docker-compose configuration it will be automatically true and while using other compose will be false
ARG DEV=false

# Install system dependencies needed for building packages
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev \
    postgresql-dev \
    && apk add --no-cache bash

# Create and activate virtual environment, then install Python packages
RUN python3 -m ensurepip && \
    python3 -m venv /py && \
    /py/bin/pip install --upgrade pip setuptools wheel && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi

# Cleanup temporary files
RUN rm -rf /tmp

# Add django-user without password and without home directory
RUN adduser -D -H django-user

# Set the PATH to include the virtual environment
ENV PATH="/py/bin:$PATH"

# Use non-root user
USER django-user

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
