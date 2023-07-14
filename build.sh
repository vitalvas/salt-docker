#!/usr/bin/env bash

set -e -o pipefail

export USE_STATIC_REQUIREMENTS=1

apt update -qy
apt install -qy git openssh-server python3-pip curl dpkg swig libssl-dev openssl libgit2-dev python-is-python3 libgit2-dev libffi-dev python3-dev python3-cffi libxslt1-dev

if [ ! -f  "/usr/sbin/dpkg-split" ]; then
    ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
fi

if [ ! -f "/usr/sbin/dpkg-deb" ]; then
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
fi

curl -fsSL -o /usr/share/keyrings/salt-pubkey.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-pubkey.gpg] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main" > /etc/apt/sources.list.d/salt.list
apt update -qy

pip3 install --no-cache-dir --upgrade pip
pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary hvac gitpython pygit2 junos-eznc jxmlease yamlordereddictloader napalm

apt install -qy salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api salt-pepper
