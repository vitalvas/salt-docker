ARG SALT_VERSION
FROM saltstack/salt:${SALT_VERSION}

ADD saltinitrun.py /usr/local/bin/saltinitrun

RUN pip3 install --no-cache-dir redis

CMD ["/usr/local/bin/saltinitrun"]
