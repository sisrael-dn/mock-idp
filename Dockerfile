FROM python:3.9.6-alpine3.14
RUN apk update && apk upgrade

# Runtime dependencies
RUN apk add --no-cache libxslt py3-cryptography

RUN mkdir -p /usr/local/mock-idp
WORKDIR /usr/local/mock-idp

RUN pip install --upgrade pip

# Install environment
COPY Pipfile .
COPY Pipfile.lock .
RUN pip3 install pipenv
RUN pipenv install --system

# Copy code
COPY bin ./bin
COPY mockidp ./mockidp
COPY doc ./doc
COPY tests ./tests
COPY setup.py .
COPY README.md .

# Install repo as package
RUN pip install -e .

EXPOSE 5000

ENTRYPOINT [ "mock-idp", "--host", "0.0.0.0", "--port" ]
CMD [ "5000" ]