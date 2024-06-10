# Non-SSL Tailscale Derp Script via Docker 

[![platfrom](https://img.shields.io/badge/platform-amd64%20%7C%20arm64-brightgreen)](https://hub.docker.com/r/fredliang/derper/tags)

# Setup

> required: set env `DERP_DOMAIN` to your domain, and ensure that port 5974 of the derp relay server is not occupied and is allowed in the firewall.

```bash
sh start.sh
```

| env                 | required | description                                                            | default value    |
| ------------------- | -------- | ---------------------------------------------------------------------- |------------------|
| DERP_DOMAIN         | true     | derper server hostname                                                 | derp.example.com |
| DERP_CERT_DIR       | false    | directory to store LetsEncrypt certs(if addr's port is :443)           | /app/certs       |
| DERP_CERT_MODE      | false    | mode for getting a cert. possible options: manual, letsencrypt         | manual           |
| DERP_ADDR           | false    | listening server address                                               | :5974            |
| DERP_STUN           | false    | also run a STUN server                                                 | true             |
| DERP_STUN_PORT      | false    | The UDP port on which to serve STUN.                                   | 5974             |
| DERP_HTTP_PORT      | false    | The port on which to serve HTTP. Set to -1 to disable                  | -1               |
| DERP_VERIFY_CLIENTS | false    | verify clients to this DERP server through a local tailscaled instance | false            |

# Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/
