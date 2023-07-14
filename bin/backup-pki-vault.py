#!/usr/bin/python3

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

lock_file = '/tmp/backup-pki-vault.lock'
if os.path.exists(lock_file):
    lock_age = time.time() - os.path.getmtime(lock_file)
    if lock_age < int(os.getenv('LOCK_AGE', '300')):
        sys.exit()

open(lock_file, 'w').close()


def get_fingerprints(path):
    try:
        list_response = client.secrets.kv.v2.list_secrets(
            mount_point=vault_mount_point,
            path=path
        )
    except:
        return {}

    rows = {}

    for key in list_response['data']['keys']:
        if key.startswith("_"):
            continue

        read_response = client.secrets.kv.read_secret_version(
            mount_point=vault_mount_point,
            path=f'{path}/{key}'
        )
        rows[key] = read_response['data']['data']['fingerprint']

    return rows


master_keys = get_fingerprints(path=f'{vault_path}/pki/master/')

for name in ['master.pem', 'master.pub']:
    file_name = f'/etc/salt/pki/master/{name}'
    if not os.path.exists(file_name):
        continue

    v_fingerprint = master_keys.get(name)

    with open(file_name, 'r') as input_file:
        data = str(input_file.read())
        fingerprint = str(sha1(data.encode()).hexdigest())

        if v_fingerprint != fingerprint:
            client.secrets.kv.v2.create_or_update_secret(
                mount_point=vault_mount_point,
                path=f'{vault_path}/pki/master/{name}',
                secret={
                    'data': data,
                    'fingerprint': fingerprint
                }
            )


minion_keys = get_fingerprints(path=f'{vault_path}/pki/minion/')

files = [
    p for p in pathlib.Path('/etc/salt/pki/master/minions/').iterdir() if p.is_file()
]

for file_path in files:
    file_name = file_path.name

    v_fingerprint = minion_keys.get(file_name)

    if file_name in minion_keys:
        del minion_keys[file_name]

    with open(file_path, 'r') as input_file:
        data = str(input_file.read())
        fingerprint = str(sha1(data.encode()).hexdigest())

        if v_fingerprint != fingerprint:
            client.secrets.kv.v2.create_or_update_secret(
                mount_point=vault_mount_point,
                path=f'{vault_path}/pki/minion/{file_name}',
                secret={
                    'data': data,
                    'fingerprint': fingerprint
                }
            )

for key in minion_keys.keys():
    client.secrets.kv.v2.delete_metadata_and_all_versions(
        mount_point=vault_mount_point,
        path=f'{vault_path}/pki/minion/{key}',
    )
