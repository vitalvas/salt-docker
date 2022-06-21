FROM ubuntu:focal

COPY build.sh /build.sh
RUN bash -x /build.sh
ADD bin /opt/bin/

CMD ["/usr/local/bin/salt-master"]
