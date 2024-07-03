# Custom docker build of SaltStack

## Supported platforms

* x86-64 (AMD64)
* ARM64

## Run

Example:

```yaml
version: '3.9'
services:
  master:
    image: public.ecr.aws/vitalvas/salt-master:latest
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
