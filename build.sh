#!/usr/bin/env bash

set -e -o pipefail

export DEBIAN_FRONTEND=noninteractive
export USE_STATIC_REQUIREMENTS=1

if [ -z "${VERSION}" ]; then
    echo "VERSION is not set"
    exit 1
fi

apt update -qy
apt upgrade -qy
apt install -qy \
    git openssh-server curl dpkg swig libssl-dev openssl libc-bin libgit2-dev libffi-dev libxslt1-dev patchelf \
    python-is-python3 python3-pip python3-dev python3-cffi python3-venv

python3 -m venv /opt/saltstack/salt
/opt/saltstack/salt/bin/pip install salt==${VERSION}.*

mkdir -p /etc/salt
mkdir -p /etc/salt/master.d

/opt/saltstack/salt/bin/pip install --no-cache-dir \
    awscli \
    boto \
    boto3 \
    cffi \
    cherrypy \
    cryptography \
    distro \
    dnspython \
    gitdb \
    gitpython \
    hvac \
    jinja2 \
    jira \
    junos-eznc \
    jxmlease \
    looseversion \
    M2Crypto \
    Mako \
    msgpack \
    msgpack-pure \
    napalm \
    packaging \
    psycopg-binary \
    py-consul \
    pycrypto \
    pycryptodome \
    pyghmi \
    pygit2==1.14.1 \
    pynetbox \
    pyyaml \
    redis \
    salt-cumulus \
    salt-sproxy \
    service-identity \
    tornado \
    twisted \
    zmq \
    yamlordereddictloader

apt purge -qqy dmidecode

for name in $(ls /opt/saltstack/salt/bin/salt*); do 
    ln -s $name /usr/local/bin/$(basename $name)
done
