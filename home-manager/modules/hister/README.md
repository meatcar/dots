# Hister on Watson

Hister runs in a rootless Home Manager Quadlet using the digest-pinned v0.20.0
image. The host publishes only `127.0.0.1:4433`. The container runs as UID/GID
65532, drops all capabilities, uses a read-only root filesystem, and mounts
only its data and startup script.

Data lives at `~/.local/share/hister`, persisted through Watson's Home Manager
impermanence configuration. The container binds the `/persist` source directly
to avoid mount-order races during live activation. Keep the complete directory
when making a backup; SQLite alone does not contain the search index and saved
page contents.

## Token and browser setup

The container requires the rootless Podman secret `hister-access-token`. Create
it as `meatcar`, without sudo, on a new installation:

```sh
openssl rand -hex 32 | tr -d '\n' | podman secret create hister-access-token -
```

Retrieve it privately in your own terminal:

```sh
podman secret inspect --showsecret hister-access-token | jq -r '.[0].SecretData'
```

Install the browser extension yourself. Set its server to
`http://127.0.0.1:4433`, then enter the token in its token setting or an
`X-Access-Token` custom header. Do not put the token in Nix configuration,
shell history, logs, or a chat transcript. Missing, empty, or whitespace-only
tokens prevent startup.

Podman keeps the secret in its persisted storage. Its file driver is not a
secret vault; Watson's disk encryption protects it while the disk is locked.
The existing backup excludes container storage, so retain the token separately
if you want to restore it rather than generate a replacement.

## Operation

```sh
systemctl --user status hister.service
systemctl --user restart hister.service
```

Rotate the token with `podman secret create --replace hister-access-token -`,
then restart the service and update the extension. An existing container does
not receive a replaced secret until it is recreated.

For version upgrades, stop the service and preserve its complete state before
starting the new image. Database migrations are not undone by reverting the
image. Browser sessions from v0.17 must sign in again after migration.

The history archive remains within Watson's `/persist` backup scope. Choose
capture exclusions in the extension before indexing sensitive pages.
