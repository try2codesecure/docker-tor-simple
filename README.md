# docker-tor-simple

[![](https://img.shields.io/docker/build/try2codesecure/docker_tord.svg)](https://hub.docker.com/r/try2codesecure/docker_tord/builds/) [![](https://images.microbadger.com/badges/version/try2codesecure/docker_tord.svg)](https://microbadger.com/images/try2codesecure/docker_tord) [![](https://images.microbadger.com/badges/commit/try2codesecure/docker_tord.svg)](https://microbadger.com/images/try2codesecure/docker_tord) [![](https://images.microbadger.com/badges/image/try2codesecure/docker_tord.svg)](https://microbadger.com/images/try2codesecure/docker_tord) [![](https://img.shields.io/docker/stars/try2codesecure/docker_tord.svg)](https://hub.docker.com/r/try2codesecure/docker_tord)  [![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

**Smallest minimal docker container for Tor network proxy daemon.**

Suitable for relay, exit node or hidden service modes with SOCKS5 proxy enabled. It works well as a single self-contained container or in cooperation with other containers (like `nginx` and `osminogin/php-fpm`) for organizing complex hidden services on the Tor network.

The image is based on great [Alpine Linux](https://alpinelinux.org/) distribution so it is has extremely low size (less than 5 MB).

Star this project on Docker Hub :star2: https://hub.docker.com/r/try2codesecure/docker_tord/


## Volumes

* `/etc/tor` config dir.
* `/var/lib/tor` data dir.


## Getting started

### Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/try2codesecure/docker_tord/) and is the recommended method of installation.

```bash
docker pull try2codesecure/docker_tord
```

Alternatively you can build the image yourself.

```bash
docker build -t tor github.com/try2codesecure/docker_tord
```


### Quickstart

```bash
docker run -p 9001:9001 -p 9030:9030 -v --name tor try2codesecure/docker_tord

# or
docker-compose up
```

After start Tor proxy available on `localhost:9050`

:exclamation:**Warning**:exclamation:

Don't bind SOCKSv5 port 9050 to public network addresses if you don't know exactly what you are doing (better bind to localhost as in the example above).


## Advanced usage

You can copy original tor config from container, modify and mount them back inside. Changing the configuration file is required for running Tor as exit node, relay or bridge. For some operation modes you need to expose additional ports (9001, 9030, 9051).

```bash
# Copy config
docker cp tor:/etc/tor/torrc /root/torrc

# ... modify torrc and run
docker run --rm --name tor \
  -p 9001:9001 \ # ORPort
  -p 9030:9030 \ # DIRPort
  -v /root/torrc:/etc/tor/torrc:ro \
  try2codesecure/docker_tord
```

## Unit file for systemd

#### tor.service

```ini
[Unit]
Description=Tor service
Wants=network-online.target
Requires=docker.service
After=docker.service network.target network-online.target

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=15s
ExecStartPre=/usr/bin/docker pull try2codesecure/docker_tord
ExecStart=/usr/bin/docker run --rm --name tor -p 127.0.0.1:9050:9050 try2codesecure/docker_tord
ExecStop=/usr/bin/docker stop tor

[Install]
WantedBy=multi-user.target
```


## Examples

Example webserver deployment config with microservice architecture to setup Tor hidden service.


#### docker-compose.yml

```yaml
tor-node:
  image: try2codesecure/docker_tord
  links:
    - nginx:myservice

nginx:
  image: nginx
  links:
    - drupal:drupalhost
  volumes:
    - /srv/drupal:/srv/www:ro
    - /srv/nginx/nginx.conf:/etc/nginx/nginx.conf:ro

drupal:
  image: osminogin/php-fpm
  links:
    - mysql:mysqlhost
  volumes:
    - /srv/drupal:/srv/www

mysql:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: changeme
```


## License

MIT
