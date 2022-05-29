ARG SALT_VERSION
FROM saltstack/salt:${SALT_VERSION}

ADD bin /opt/bin/

RUN apk add --no-cache swig git openssh-client && \
    pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary hvac gitpython

CMD ["/opt/bin/saltinitrun.py"]
