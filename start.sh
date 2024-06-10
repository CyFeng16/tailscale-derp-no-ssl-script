#!/usr/bin/bash
# TODO: modify domain to your own domain
export DERP_DOMAIN="derp.example.com"
docker build --build-arg DERP_DOMAIN="${DERP_DOMAIN}" -t derp-no-ssl .
docker run --network host --restart always -d derp-no-ssl
curl --insecure --resolve "${DERP_DOMAIN}:5974:127.0.0.1" "https://${DERP_DOMAIN}:5974"
timeout 5 nc $(curl ip.sb) 5974 -v