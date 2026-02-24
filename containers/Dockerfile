ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS base

#### 1. managed by docker
RUN --mount=type=cache,id=uv-cache,target=/root/.cache/uv \
    uv sync --frozen

#### mount a docker build directory while building
RUN --mount=type=bind,source=some_dir,target=/mnt \
    ls -la /mnt

#### 2. using a secret
RUN --mount=type=secret,id=token token="$(cat /run/secrets/token)" && \
    curl -fsSL -H "Authorization: Bearer ${token}" \
      https://example.com/private/resource -o /tmp/resource && \
    rm -f /tmp/resource

#DOCKER_BUILDKIT=1 docker build --progress=plain \
#  --secret id=token,src=./configs/token.txt \
#  -t demo-secret:latest ./

#### 3. import(--cache-to) and export(--cache-from) BuildKit cache
#docker buildx build \
#  --cache-to=type=local,dest=.buildkit-cache \
#  --cache-from=type=local,src=.buildkit-cache \
#  -t yourimg .
