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

ADD https://github.com/concourse/concourse/releases/download/v${CONCOURSE_VER}/concourse_linux_amd64 \
        /usr/local/bin/concourse
RUN apk update && apk add --no-cache ca-certificates iproute2 dumb-init

# volume containing keys to use
VOLUME /concourse-keys

ENTRYPOINT ["/usr/bin/dumb-init", "/usr/local/bin/concourse"]
