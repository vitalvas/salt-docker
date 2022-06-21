FROM ubuntu:focal

RUN apt update -qy && \
    apt install -qy git openssh-server python3-pip curl && \
    curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" > /etc/apt/sources.list.d/salt.list && \
    apt update -qy && \
    apt install -qy salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api && \
    pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary hvac gitpython pygit2

ADD bin /opt/bin/


CMD ["/usr/local/bin/salt-master"]
