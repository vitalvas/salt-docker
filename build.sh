#!/usr/bin/env bash

set -e -o pipefail

export DEBIAN_FRONTEND=noninteractive
export USE_STATIC_REQUIREMENTS=1

apt update -qy
apt install -qy git openssh-server python3-pip curl dpkg swig libssl-dev openssl libgit2-dev python-is-python3 libgit2-dev libffi-dev python3-dev python3-cffi libxslt1-dev \
    python3-requests python3-requests-oauthlib patchelf

if [ ! -f  "/usr/sbin/dpkg-split" ]; then
    ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
fi

if [ ! -f "/usr/sbin/dpkg-deb" ]; then
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
fi

curl -fsSL -o /usr/share/keyrings/salt-pubkey-amd64.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-pubkey-amd64.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/3006 jammy main" > /etc/apt/sources.list.d/salt-amd64.list

curl -fsSL -o /usr/share/keyrings/salt-pubkey-arm64.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/arm64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-pubkey-arm64.gpg arch=arm64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/arm64/3006 jammy main" > /etc/apt/sources.list.d/salt-arm64.list

apt update -qy

apt install -qy salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

SWIG_FEATURES="-I/opt/saltstack/salt/include" /opt/saltstack/salt/bin/pip install --no-cache-dir \
    awscli \
    boto \
    boto3 \
    dnspython \
    gitpython \
    hvac \
    jira \
    junos-eznc \
    jxmlease \
    M2Crypto \
    napalm \
    psycopg-binary \
    pycrypto \
    pyghmi \
    pygit2 \
    pynetbox \
    python-consul \
    redis \
    service-identity \
    tornado \
    twisted \
    yamlordereddictloader

apt purge -qqy dmidecode
