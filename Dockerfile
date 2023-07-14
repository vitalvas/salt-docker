FROM ubuntu:jammy

COPY build.sh /build.sh
RUN bash -x /build.sh

ADD bin /opt/bin/
ADD ./conf/ /etc/salt/

CMD ["/opt/bin/saltinitrun.py"]
