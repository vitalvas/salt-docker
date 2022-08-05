#!/usr/bin/env python3

import os
import time
import sys
import pathlib
import hvac
from hashlib import sha1


client = hvac.Client(
    url=os.getenv('VAULT_URL')
)


if os.getenv('VAULT_TOKEN'):
    client.token = os.getenv('VAULT_TOKEN')

elif os.getenv('VAULT_ROLE_ID') and os.getenv('VAULT_SECRET_ID'):
    client.auth.approle.login(
        role_id=os.getenv('VAULT_ROLE_ID'),
        secret_id=os.getenv('VAULT_SECRET_ID'),
        mount_point=os.getenv('VAULT_APPROLE_MOUNT', 'approle')
    )


vault_mount_point = os.getenv('VAULT_MOUNT_POINT', 'salt/secrets')
vault_path = os.getenv('VAULT_PATH', 'master')


def get_minions_list():
    try:
        list_response = client.secrets.kv.v2.list_secrets(
            mount_point=vault_mount_point,
            path=f'{vault_path}/pki/minion/'
        )
    except:
        return []

    minions = []
    for key in list_response['data']['keys']:
        if key.startswith("_"):
            continue
        
        minions.append(key)

    return minions                


for row in get_minions_list():
    read_response = client.secrets.kv.read_secret_version(
        mount_point=vault_mount_point,
        path=f'{vault_path}/pki/minion/{key}'
    )
    
    with open(f'/etc/salt/pki/master/minions/{row}', 'w') as f:
        f.write(read_response['data']['data']['data'])

for name in ['master.pem', 'master.pub']:

    read_response = client.secrets.kv.read_secret_version(
        mount_point=vault_mount_point,
        path=f'{vault_path}/pki/master/{name}'
    )

    with open(f'/etc/salt/pki/master/{name}', 'w') as f:
        f.write(read_response['data']['data']['data'])
    