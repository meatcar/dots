# Hister on Watson

Hister runs in a rootless Home Manager Quadlet using the digest-pinned v0.20.0
image. The host publishes only `127.0.0.1:4433`. The container runs as UID/GID
65532, drops all capabilities, uses a read-only root filesystem, and mounts
only its data, startup script, and read-only token file.

Data lives at `~/.local/share/hister`, persisted through Watson's Home Manager
impermanence configuration. The container binds the `/persist` source directly
to avoid mount-order races during live activation. Keep the complete directory
when making a backup; SQLite alone does not contain the search index and saved
page contents.

## Token and browser setup

The token is encrypted in `secrets/histerToken.age`. Home Manager's agenix
service decrypts it to `/run/user/1000/agenix/histerToken`, owned by `meatcar`
with mode `0400`. The Quadlet waits for agenix and mounts that file read-only.
The startup script reads it into Hister's access-token environment variable.

Read it privately in your own Watson terminal, without sudo:

```sh
cat /run/user/1000/agenix/histerToken
```

Install the browser extension yourself. Set its server to
`http://127.0.0.1:4433`, then enter the token in its token setting or an
`X-Access-Token` custom header. Do not put the token in Nix configuration,
shell history, logs, or a chat transcript. Missing, empty, or whitespace-only
tokens prevent startup.

The token is not regenerated at startup. Reboots and rebuilds decrypt the same
encrypted value. Restore access with the encrypted file and an authorized age
identity; no persistent Podman secret copy is needed.

## Operation

```sh
systemctl --user status hister.service
systemctl --user restart hister.service
```

To rotate the token, use `agenix -e histerToken.age` from `secrets/` in the
repository's development shell. Save a new random token as a single line,
apply the updated Home Manager configuration, restart `hister.service`, and
update the extension. The running process keeps its startup token until restart.

For version upgrades, stop the service and preserve its complete state before
starting the new image. Database migrations are not undone by reverting the
image. Browser sessions from v0.17 must sign in again after migration.

The history archive remains within Watson's `/persist` backup scope. Choose
capture exclusions in the extension before indexing sensitive pages.
