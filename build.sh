#!/usr/bin/env bash

set -e -o pipefail

export USE_STATIC_REQUIREMENTS=1

apt update -qy
apt install -qy git openssh-server python3-pip curl dpkg swig libssl-dev openssl libgit2-dev

if [ ! -f  "/usr/sbin/dpkg-split" ]; then
    ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
fi

if [ ! -f "/usr/sbin/dpkg-deb" ]; then
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
fi

curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" > /etc/apt/sources.list.d/salt.list
apt update -qy

apt install -qy salt-master salt-minion salt-ssh salt-syndic salt-cloud salt-api

pip3 install --no-cache-dir redis M2Crypto pycrypto psycopg-binary hvac gitpython pygit2
