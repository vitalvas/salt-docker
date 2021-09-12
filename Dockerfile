ARG SALT_VERSION
FROM saltstack/salt:${SALT_VERSION}

ADD saltinitrun.py /usr/local/bin/saltinitrun

CMD ["/usr/local/bin/saltinitrun"]
