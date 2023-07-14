#!/usr/bin/python3

import os
import sys
import requests
import datetime

TG_TOKEN = os.getenv('TELEGRAM_TOKEN')
TG_CHAT_ID = os.getenv('TELEGRAM_CHAT_ID')
SALT_CLUSTER_ID = os.getenv('SALT_CLUSTER_ID', 'undef')

pki_dir='/etc/salt/pki/master/'
url = f'https://api.telegram.org/bot{TG_TOKEN}'

act = sys.argv[1]
host = sys.argv[2]
key_digest = sys.argv[3]


if not TG_CHAT_ID:
    sys.exit()
  

def send_msg(text, reply_to_message_id=None):
    payload = {
        'chat_id': TG_CHAT_ID,
        'parse_mode': 'HTML',
        'text': f'[{SALT_CLUSTER_ID}] {text}'
    }
    if reply_to_message_id:
        payload['reply_to_message_id'] = reply_to_message_id

    requests.post(f'{url}/sendMessage', data=payload)


req = requests.get(f'{url}/getUpdates', data={'timeout': 10, 'offset': None, 'limit': 10}).json()
if req['ok']:
    for row in req['result']:
        if str(row['message']['chat']['id']) != TG_CHAT_ID:
            continue

        if row['message']['date'] < (datetime.datetime.now() - datetime.timedelta(hours=3)).timestamp():
            continue
        
        if row['message']['text'].strip() == f'/accept {host}':
            for key_dir in ['minions', 'minions_denied', 'minions_pre']:
                if os.path.exists(f'{pki_dir}/{key_dir}/{host}'):
                    os.remove(f'{pki_dir}/{key_dir}/{host}')
        
            open(f'{pki_dir}/minions_autosign/{host}', 'w').close()
            
            send_msg(
                f'Acceped minion: <code>{host}</code>; digest: <code>{key_digest}</code>',
                reply_to_message_id=row['message']['message_id']
            )

lock_file = f'/tmp/host-{host}-{act}-{key_digest}.lock'

if not os.path.exists(lock_file) and not os.path.exists(f'{pki_dir}/minions_autosign/{host}'):
    send_msg(f'New salt minion: <code>{host}</code>; act: <code>{act}</code>; digest: <code>{key_digest}</code>')
    
    open(lock_file, 'w').close()
