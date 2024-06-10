FROM golang:latest AS builder
WORKDIR /app
RUN go install tailscale.com/cmd/derper@main

FROM ubuntu:22.04 AS worker
WORKDIR /app
ARG DEBIAN_FRONTEND=noninteractive
ARG DERP_DOMAIN=localhost
ENV DERP_DOMAIN $DERP_DOMAIN
ENV DERP_CERT_MODE manual
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :5974
ENV DERP_STUN true
ENV DERP_STUN_PORT 5974
ENV DERP_HTTP_PORT -1
ENV DERP_VERIFY_CLIENTS false
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/derper /app/derper
RUN mkdir -p $DERP_CERT_DIR && \
    cd $DERP_CERT_DIR && \
    openssl genpkey -algorithm RSA -out $DERP_DOMAIN.key && \
    openssl req -new -key $DERP_DOMAIN.key -out $DERP_DOMAIN.csr \
        -subj "/C=AU/ST=Some-State/L=YourCity/O=Internet Widgits Pty Ltd/OU=YourUnit/CN=$DERP_DOMAIN/emailAddress=your_email@example.com" && \
    printf "subjectAltName=DNS:$DERP_DOMAIN" > extfile.cnf && \
    openssl x509 -req -days 36500 -in $DERP_DOMAIN.csr -signkey $DERP_DOMAIN.key -out $DERP_DOMAIN.crt -extfile extfile.cnf && \
    openssl x509 -in ${DERP_DOMAIN}.crt -noout -text
CMD /app/derper \
    --hostname=$DERP_DOMAIN \
    --certmode=$DERP_CERT_MODE \
    --certdir=$DERP_CERT_DIR \
    --a=$DERP_ADDR \
    --stun=$DERP_STUN  \
    --stun-port=$DERP_STUN_PORT \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS