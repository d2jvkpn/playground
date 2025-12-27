ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS base

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

RUN --mount=type=secret,id=token \
    TOKEN="$(cat /run/secrets/token)" && \
    curl -fsSL -H "Authorization: Bearer ${TOKEN}" https://example.com/private/resource -o /tmp/resource && \
    rm -f /tmp/resource

# DOCKER_BUILDKIT=1 docker build --secret id=token,src=./token.txt -t demo-secret:latest ./
