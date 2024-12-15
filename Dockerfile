FROM python:3.9-alpine3.13
LABEL maintainer="gzelalem"

ENV PYTHONUNBUFFERED=1

# Copy the requirements files and application code
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8010

ARG DEV=false

# Create virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
    build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser --disabled-password --no-create-home django-user
# Install sudo
RUN apk add sudo

# Set PATH so that Python in the virtual environment is available globally
ENV PATH="/py/bin:$PATH"

# Switch to non-root user to run the app
USER django-user

# Ensure that commands like `python` are correctly recognized
# Use explicit path to Python if needed, e.g., /py/bin/python