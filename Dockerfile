FROM ubuntu:jammy

COPY build.sh /build.sh
RUN bash -x /build.sh

ADD bin /opt/bin/
ADD ./conf/ /etc/salt/
ADD ./tools/profile-promt.sh /etc/profile.d/

CMD ["/opt/bin/saltinitrun.py"]
