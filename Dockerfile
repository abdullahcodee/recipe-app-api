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
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
# Set the PATH to include the virtual environment
ENV PATH="/py/bin:$PATH"

# Use non-root user
USER django-user

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
