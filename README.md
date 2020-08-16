# honk-docker

dockerfile for https://humungus.tedunangst.com/r/honk  
ActivityPub implementation  

below is an example of use with docker-compose, traefik, and "vanity" usernames  
eg. host honk at `honk.my.domain` but be available on fediverse as `@me@my.domain` without the subdomain

```yaml
version: '3'
networks:
  reverse_proxy:
    external: true
services:
  main:
    build: ${BUILD}/honk-docker
    environment:
    - TZ
    - HONK_USERNAME=example
    - HONK_PASSWORD=example # must be 7+ chars
    - HONK_LISTEN_ADDR=0.0.0.0:80
    - HONK_SERVER_NAME=honk.my.domain
    - HONK_MASQNAME=my.domain
    expose:
    - 80
    labels:
      traefik.enable: 'true'
      traefik.http.routers.honk.entrypoints: web
      traefik.http.routers.honk.rule: Host(`honk.my.domain`) || Path(`/.well-known/webfinger`)
      traefik.http.services.honk.loadbalancer.server.port: 80
    networks:
    - reverse_proxy
    volumes:
    - ./data:/opt/data
```
