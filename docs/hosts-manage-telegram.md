# Hosts Manage Telegram

## Env

* TELEGRAM_TOKEN - Telegram token of your bot
* TELEGRAM_CHAT_ID - Telegram chat ID  (In order to find out - you can use this bot - https://t.me/getmyid_bot)
* SALT_CLUSTER_ID - Name of your salt cluster - сhat identification

## Config

Salt master config:

```yaml
reactor:
  - 'salt/auth':
    - /srv/salt/reactor/minion-auth.sls
...

file_roots:
  base:
    - /srv/salt/states
```

File `/srv/salt/reactor/minion-auth.sls`:

```yaml
{% if data.get('act') in ['pend', 'denied'] %}
{% set key_digest = salt['hashutil.digest'](data['pub']) %}

accept_minion_public_key:
  runner.state.orch:
    - args:
      - mods: salt.int.register
      - pillar:
          act: {{ data['act'] }}
          id: {{ data['id'] }}
          key_digest: {{ key_digest }}
{% endif %}
```

File `/srv/salt/states/salt/int/register.sls`:

```yaml
{{ tpldot }}.register:
  cmd.run:
    - name: /opt/bin/hosts-manage-telegram.py {{ salt.pillar.get('act') }} {{ salt.pillar.get('id') }} {{ salt.pillar.get('key_digest') }}
    - stateful: True
```
