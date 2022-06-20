FROM python:3.8-alpine

ARG SALT_VERSION

ADD bin /opt/bin/

RUN apk add --no-cache gcc g++ autoconf make libffi-dev openssl-dev libgit2-dev swig git openssh && \
    addgroup -g 450 -S salt && \
    adduser -s /bin/sh -SD -G salt salt && \
    mkdir -p /etc/pki /etc/salt/pki /etc/salt/minion.d/ /etc/salt/master.d /etc/salt/proxy.d /var/cache/salt /var/log/salt /var/run/salt && \
    chmod -R 2775 /etc/pki /etc/salt /var/cache/salt /var/log/salt /var/run/salt && \
    chgrp -R salt /etc/pki /etc/salt /var/cache/salt /var/log/salt /var/run/salt && \
    USE_STATIC_REQUIREMENTS=1 pip3 install --no-cache-dir salt=="${SALT_VERSION}" && \
    USE_STATIC_REQUIREMENTS=1 pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary hvac gitpython pygit2

CMD ["/usr/local/bin/salt-master"]
