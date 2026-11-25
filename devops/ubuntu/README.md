# Ubuntu development container

This project builds an Ubuntu 26.04 container with SSH access for the `ubuntu` user. It is intended
for a local development environment.

## Design

- The image runs from `/home/ubuntu` as the `ubuntu` user. The startup script uses passwordless
  `sudo` for password setup, SSH host keys, and the root-owned `sshd` process managed by Supervisor.
- Compose publishes container port 22 on the host at `127.0.0.1:2222` and attaches the container to
  an existing Docker network named `local`.
- Compose bind mounts `data/ssh` to `/etc/ssh`, `data/ubuntu-auth` read-only to `/run/ubuntu-auth`,
  and `data/ubuntu-home` to `/home/ubuntu`. These host directories hold the persistent state.
- The image saves its original `/home/ubuntu` files under `/opt/defaults/ubuntu`. They are **not**
  copied into the mounted home directory automatically.
- `scripts/create-auth.sh` generates a SHA-512 password hash on the host. On each container start,
  `prepare-container.sh` applies that hash to `ubuntu`; if the hash file is missing or empty, it
  locks password login for that account.

## Requirements

- Docker with the Compose plugin and `make` on the host.
- OpenSSL on the host to run `scripts/create-auth.sh`.
- A locally maintained `compose.yaml` supplied by operations.
- A pre-existing Docker network named `local`.

## First start

Run these commands from the repository root:

```sh
mkdir -p data/ssh data/ubuntu-home
if [ ! -e data/ubuntu-auth/ubuntu.hash ]; then
  ./scripts/create-auth.sh
fi
make build
docker compose up -d --no-build
ssh -p 2222 ubuntu@127.0.0.1
```

`compose.ubuntu.yaml` is a tracked reference configuration. Operations maintains the actual
`compose.yaml`; this repository does not create it. The local file is ignored by Git and excluded
from the Docker build context. `make build` calls `docker build` and tags the image as
`q.local/ubuntu:dev`. The optional `make compose-build` target uses the local `compose.yaml`
and requires its `build` section to be enabled.

The mounted home directory starts with its current host contents. To copy the image's default files
such as `.bashrc` and `.profile` into it **manually**, run this after the container starts:

```sh
./scripts/copy-default-home.sh
```

That script copies only missing files. It does not run during container startup.

## Common operations

Rebuild the image and recreate the container after changing the Containerfile or files under
`container/`:

```sh
make build
docker compose up -d --no-build --force-recreate
```

To apply a changed password hash, restart the container:

```sh
docker compose restart ubuntu
```

The hash creation script refuses to overwrite an existing `data/ubuntu-auth/ubuntu.hash`. To rotate
the password, move the old file aside, run `./scripts/create-auth.sh`, and restart the container.
Verify the new login before deleting the old hash backup. Changing the password only with `passwd`
inside the container is temporary: the stored hash is applied again at the next start.

## Notes and cautions

- **Back up an existing home before adding the mount.** A bind mount hides the old container's
  `/home/ubuntu`. If the old container has files you need, copy them to `data/ubuntu-home` before
  recreating it, for example with `docker cp -a ubuntu:/home/ubuntu/. ./data/ubuntu-home/`.
- Ensure `data/ubuntu-home` is accessible and writable by the image's `ubuntu` user. The directory's
  ownership matters because the image starts as that user.
- The password hash is sensitive even though it is not plaintext. Keep `data/ubuntu-auth`
  restricted; `create-auth.sh` creates it with mode `700` and the hash file with mode `600`. The
  `data/` tree is excluded from Git and the Docker build context.
- Removing `ubuntu.hash` does **not** revoke a password in a running container immediately. Restart
  the container to lock password login. SSH key login may still work.
- Setting an account password does not override `sshd_config`. If SSH password login fails, check
  the effective SSH authentication settings in the persisted `data/ssh` configuration.
- `ubuntu` has `NOPASSWD:ALL` sudo access. Its login password does not provide a separate barrier to
  root access inside the container.
- The loopback host port does not isolate SSH from other containers on the shared `local` Docker
  network. Adjust the network and port mapping for the deployment environment.
- Supervisor retries a failed `sshd`, but the container does not continuously check SSH health. If
  `sshd` reaches Supervisor's `FATAL` state after startup, the container can remain running.
- Existing files in `data/ssh` are preserved. New SSH defaults from a rebuilt image are copied only
  when the corresponding file is missing.

Run the available script tests with `sh tests/create-auth.sh`, `sh tests/prepare-container.sh`, and
`sh tests/entrypoint-user.sh`.
