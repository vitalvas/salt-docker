FROM ubuntu:jammy

COPY build.sh /build.sh
RUN bash -x /build.sh
ADD bin /opt/bin/

CMD ["/usr/bin/salt-master"]
