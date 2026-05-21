#!/bin/sh
# Install build-certs/extra-ca.pem into the Debian trust store (Docker build stages).
set -eu

if [ ! -f /tmp/build-certs/extra-ca.pem ]; then
	echo "WARN: build-certs/extra-ca.pem not found; cargo/go may fail TLS behind corporate proxies" >&2
	exit 0
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends ca-certificates
cp /tmp/build-certs/extra-ca.pem /usr/local/share/ca-certificates/extra-ca.crt
update-ca-certificates
apt-get clean
rm -rf /var/lib/apt/lists/*
echo "Installed extra CA from build-certs/extra-ca.pem"
