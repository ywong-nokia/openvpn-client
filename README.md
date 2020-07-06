Forked from ekristen. Add automated multi archbuilds and tags for OpenVPN version in Alpine. Check out [jnovack/docker-multi-arch-hooks](https://github.com/jnovack/docker-multi-arch-hooks) for that.

# Docker OpenVPN Client

1. You should add the generated openvpn client config to a directory, you can call it client.ovpn
2. You should add the password for the private key in the `client.ovpn` to `client.pwd`
3. Run the following, I recommend adding `--auth-nocache`

```bash
docker run -d --name vpn-client \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -v /path/with/vpn/configs:/vpn \
  frauhottelmann/openvpn-client:tag --config /vpn/client.conf --askpass /vpn/client.pwd --auth-nocache
```

### Route container traffic

Use `--net=container:<container-id>` -- routes available by the VPN client will be made available to the container.

```bash
docker run -it --rm \
  --net=container:vpn-client
  ubuntu /bin/bash
```

# docker-compose example:
```yaml
version: '2'

services:
  openvpn-client:
    build:
      context: build
    container_name: frauhottelmann/openvpn-client:tag
    restart: always
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    command: --config /vpn/client.ovpn --askpass /vpn/client.pwd --auth-nocache
    volumes:
      - ./client/:/vpn
    networks:
      - openvpn
networks:
  openvpn:
    driver: bridge
```
