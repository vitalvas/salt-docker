#!/usr/bin/env bash

set -e -o pipefail

export DEBIAN_FRONTEND=noninteractive
export USE_STATIC_REQUIREMENTS=1

if [ -z "${VERSION}" ]; then
    echo "VERSION is not set"
    exit 1
fi


apt update -qy
apt install -qy \
    git openssh-server curl dpkg swig libssl-dev openssl libgit2-dev libffi-dev libxslt1-dev patchelf \
    python-is-python3 python3-pip python3-dev python3-cffi 

if [ ! -f  "/usr/sbin/dpkg-split" ]; then
    ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
fi

if [ ! -f "/usr/sbin/dpkg-deb" ]; then
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
fi

curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.pgp https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public
echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.pgp] https://packages.broadcom.com/artifactory/saltproject-deb/ stable main" > /etc/apt/sources.list.d/salt.list

cat <<EOF >/etc/apt/preferences.d/salt-pin
Package: salt-*
Pin: version ${VERSION}.*
Pin-Priority: 1001
EOF

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
    Mako \
    msgpack-pure \
    napalm \
    psycopg-binary \
    py-consul \
    pycrypto \
    pyghmi \
    pygit2==1.14.1 \
    pynetbox \
    redis \
    salt-sproxy \
    salt-cumulus \
    service-identity \
    tornado \
    twisted \
    yamlordereddictloader

apt purge -qqy dmidecode
