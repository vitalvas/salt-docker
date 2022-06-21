# Custom docker build of SaltStack

## Supported platforms

* x86-64 (AMD64)
* ARM64

## Run

Example:

```yaml
version: '3.9'
services:
  watchtower:
    image: containrrr/watchtower
    restart: always
    network_mode: 'host'
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_INCLUDE_RESTARTING=true
      - WATCHTOWER_POLL_INTERVAL=43200
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  master:
    image: ghcr.io/vitalvas/salt-docker:latest
    command: /usr/local/bin/salt-master
    restart: always
    read_only: true
    network_mode: 'host'
    tmpfs:
      - /var/cache/salt
      - /var/log/salt
      - /var/run
      - /tmp
    volumes:
      - /srv/salt/master/pki:/etc/salt/pki
      - /opt/salt/conf/master:/etc/salt/master.d:ro
      - /opt/salt/src:/srv/salt:ro
```
