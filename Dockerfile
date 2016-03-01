FROM alpine

ENTRYPOINT ["openvpn"]
VOLUME ["/vpn"]

RUN apk add --update openvpn
