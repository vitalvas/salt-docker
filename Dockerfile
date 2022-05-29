ARG SALT_VERSION
FROM saltstack/salt:${SALT_VERSION}

ADD bin /opt/bin/

RUN apk add --no-cache swig && \
    pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary hvac

CMD ["/opt/bin/saltinitrun.py"]
