FROM alpine:edge

ENV ENTRYKIT_VER=0.4.0 \
    CONCOURSE_VER=2.7.0 \
    # 'web' keys
    CONCOURSE_TSA_HOST_KEY=/concourse-keys/tsa_host_key \
    CONCOURSE_TSA_AUTHORIZED_KEYS=/concourse-keys/authorized_worker_keys \
    CONCOURSE_SESSION_SIGNING_KEY=/concourse-keys/session_signing_key \
    # 'worker' keys
    CONCOURSE_TSA_PUBLIC_KEY=/concourse-keys/tsa_host_key.pub \
    CONCOURSE_TSA_WORKER_PRIVATE_KEY=/concourse-keys/worker_key \
    \
    CONCOURSE_WORK_DIR=/worker-state

RUN apk update && apk add --no-cache --update ca-certificates openssl iproute2 dumb-init \
    && update-ca-certificates \
    && wget https://github.com/concourse/concourse/releases/download/v${CONCOURSE_VER}/concourse_linux_amd64 \
        -O /usr/local/bin/concourse -q \
    && chmod +x /usr/local/bin/concourse \
    && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# volume containing keys to use
VOLUME /concourse-keys

ENTRYPOINT ["/usr/bin/dumb-init", "/usr/local/bin/concourse"]
