FROM alpine:latest

ARG BUILD_RFC3339="1970-01-01T00:00:00Z"
ARG COMMIT
ARG VERSION

STOPSIGNAL SIGKILL

LABEL org.opencontainers.image.ref.name="ywong-nokia/openvpn-client" \
      org.opencontainers.image.created=$BUILD_RFC3339 \
      org.opencontainers.image.authors="ywong-nokia" \
      org.opencontainers.image.documentation="https://github.com/ywong-nokia/openvpn-client/blob/master/README.md" \
      org.opencontainers.image.description="OpenVPN Client in a Docker Container" \
      org.opencontainers.image.licenses="GPLv3" \
      org.opencontainers.image.source="https://github.com/ywong-nokia/openvpn-client" \
      org.opencontainers.image.revision=$COMMIT \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.url="https://hub.docker.com/r/ywong-nokia/openvpn-client"

# https://johnsiu.com/blog/alpine-vscode/
RUN apk update && apk add --no-cache wget curl nano vim sudo openvpn openssh bash gcompat libstdc++

# Create new user 'ywong' and set up SSH access
RUN adduser -D ywong
RUN echo 'ywong:ywong' | chpasswd
RUN mkdir -p /home/ywong/.ssh && \
    chmod 700 /home/ywong/.ssh
RUN ssh-keygen -A

COPY id_rsa.pub /home/ywong/.ssh/authorized_keys
RUN chmod 600 /home/ywong/.ssh/authorized_keys && \
    chown -R ywong:ywong /home/ywong/.ssh

# Update AllowTcpForwarding to yes
RUN sed -i '/^#AllowTcpForwarding /s/^#//' /etc/ssh/sshd_config
RUN sed -i 's/^AllowTcpForwarding .*/AllowTcpForwarding yes/' /etc/ssh/sshd_config

# Update PermitTunnel to yes
RUN sed -i '/^#PermitTunnel /s/^#//' /etc/ssh/sshd_config
RUN sed -i 's/^PermitTunnel .*/PermitTunnel yes/' /etc/ssh/sshd_config

# Custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/vpn"]
