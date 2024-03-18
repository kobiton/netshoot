# Copyright 2024 Kobiton Inc.
# Modified from `https://github.com/nicolaka/netshoot`

ARG ALPINE_IMAGE_TAG=3.19.1
ARG DEBIAN_IMAGE_TAG=stable-slim

FROM debian:${DEBIAN_IMAGE_TAG} as fetcher
COPY build/fetch_binaries.sh /tmp/fetch_binaries.sh

RUN apt-get update \
 && apt-get install -y \
  curl \
  wget

RUN /tmp/fetch_binaries.sh

FROM alpine:${ALPINE_IMAGE_TAG}

RUN set -ex \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk update \
 && apk upgrade \
 && apk add --no-cache \
      apache2-utils \
      bash \
      bind-tools \
      bird \
      bridge-utils \
      busybox-extras \
      conntrack-tools \
      curl \
      dhcping \
      drill \
      ethtool \
      file\
      fping \
      git \
      httpie \
      iftop \
      iperf \
      iperf3 \
      iproute2 \
      ipset \
      iptables \
      iptraf-ng \
      iputils \
      ipvsadm \
      jq \
      libc6-compat \
      liboping \
      ltrace \
      mtr \
      net-snmp-tools \
      netcat-openbsd \
      nftables \
      ngrep \
      nmap \
      nmap-nping \
      nmap-scripts \
      openssh \
      openssl \
      perl-crypt-ssleay \
      perl-net-ssleay \
      py3-pip \
      py3-setuptools \
      scapy \
      socat \
      speedtest-cli \
      strace \
      swaks \
      tcpdump \
      tcptraceroute \
      tshark \
      util-linux \
      vim \
      websocat \
      zsh \
      zsh-autosuggestions \
 && chown root:root /usr/bin/dumpcap

COPY --from=fetcher --chown=root:root /tmp/ctop /usr/local/bin/ctop
COPY --from=fetcher --chown=root:root /tmp/calicoctl /usr/local/bin/calicoctl
COPY --from=fetcher --chown=root:root /tmp/termshark /usr/local/bin/termshark
COPY --from=fetcher --chown=root:root /tmp/grpcurl /usr/local/bin/grpcurl
COPY --from=fetcher --chown=root:root /tmp/fortio /usr/local/bin/fortio

USER root
WORKDIR /root
ENV HOSTNAME netshoot

COPY --chown=root:root zshrc .zshrc

COPY motd motd

# Running ZSH
CMD ["zsh"]
