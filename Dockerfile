FROM python:3.9-alpine3.13
LABEL maintainer="gzelalem"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8010

# this creates image layer for each command we run
RUN python -m venv /py && \ #creates ne virtual environment
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
#everything above was done throuth root user until 
#the bottom line cswitched the user to Django-user
USER django-user