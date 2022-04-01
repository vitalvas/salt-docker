ARG SALT_VERSION
FROM saltstack/salt:${SALT_VERSION}

ADD bin /opt/bin/
ADD saltinitrun.py /usr/local/bin/saltinitrun

RUN apk add --no-cache swig && \
    pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary

CMD ["/usr/local/bin/saltinitrun"]
