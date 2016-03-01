# Docker OpenVPN Client

1. You should add the generated openvpn client config to a directory, you can call it client.ovpn
2. You should add the password for the private key in the `client.ovpn` to `client.pwd`
3. Run the following, I recommend adding `--auth-nocache`

```
docker run -d --name vpn-client \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -v /path/with/vpn/configs:/vpn \
  ekristen/openvpn-client --config /vpn/client.conf --askpass /vpn/client.pwd --auth-nocache
```
