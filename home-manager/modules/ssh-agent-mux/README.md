# SSH agents on Watson

Watson uses `ssh-agent-mux` at `$XDG_RUNTIME_DIR/ssh-agent-mux/agent.sock`.
It offers 1Password keys first, then GCR's local keys. GCR keeps managing local
key unlocking and caching; GNOME Keyring keeps storing application secrets.

SSH follows `SSH_AUTH_SOCK`. There is no global `IdentityAgent` override, so
project environments and forwarded agents can select their own socket.

## Apply and check

From the dotfiles checkout:

```sh
sudo nixos-rebuild switch --flake .#watson
systemctl --user status ssh-agent-mux.service
```

Activation updates the systemd user environment. Existing terminals, tmux
sessions, and agents such as Amp keep their inherited environment. In Fish,
switch the current terminal, then restart programs that need the new value:

```fish
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent-mux/agent.sock"
ssh-add -l
```

The managed configuration is `~/.config/ssh-agent-mux/ssh-agent-mux.toml`.
Change the Nix module rather than editing that generated file. Service logs are
available with `journalctl --user -u ssh-agent-mux.service`.

## Local keys

GCR discovers pairs such as `~/.ssh/work` and `~/.ssh/work.pub`, loads them on
first use, and caches unlocked keys. Its unlock prompt can also remember the
passphrase through GNOME Keyring.

The mux supports listing and signing, not adding or deleting keys. For a key
outside GCR's discovery directory, add it directly to GCR:

```sh
SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh" ssh-add /path/to/key
```

The mux then exposes that key. Use the same GCR socket override for `ssh-add -d`
or `ssh-add -D`. These operations do not delete local key files, remembered
passphrases, or 1Password items. GCR can load file-backed keys again.

## A project with its own agent

If the project's tooling already sets `SSH_AUTH_SOCK`, SSH uses that agent
instead of the default mux. Child shells preserve the supplied socket.

For a direnv project, its `.envrc` can select a socket provided by the project's
agent setup:

```sh
export SSH_AUTH_SOCK="$PROJECT_AGENT_SOCK"
```

Leaving the directory restores the previous environment. A project-specific
`IdentityAgent` in SSH configuration still takes precedence over this variable.

## A project agent plus the default keys

Start a separate mux that combines the default mux with the project agent.
Use a distinct unit name for each project. Run this after the project agent has
set `PROJECT_AGENT_SOCK` to its actual socket:

```sh
systemd-run --user --collect --unit=ssh-agent-mux-myproject \
  --property=RuntimeDirectory=ssh-agent-mux-myproject \
  --property=RuntimeDirectoryMode=0700 --property=UMask=0077 \
  ssh-agent-mux --config /dev/null \
  --listen "$XDG_RUNTIME_DIR/ssh-agent-mux-myproject/agent.sock" \
  "$XDG_RUNTIME_DIR/ssh-agent-mux/agent.sock" "$PROJECT_AGENT_SOCK"
```

Point the project's `.envrc` at this new mux, then run `direnv allow`:

```sh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent-mux-myproject/agent.sock"
```

This leaves the desktop default unchanged. Add keys directly to the project
agent before using them through the mux. Stop the project mux when finished:

```sh
systemctl --user stop ssh-agent-mux-myproject.service
```

Command-line upstream sockets replace the configured list, rather than append
to it. Nesting the default mux preserves its configured backends without
repeating their paths. Put the project socket first if its keys should be
offered before the default keys.

## Limits

- Plain `ssh-copy-id user@host` selects all advertised keys, including GCR's
  discovered public keys. Use `ssh-copy-id -i /path/to/key.pub user@host` to
  select one local key. A 1Password public-key-only file needs `-f -i`.
- Many offered keys can hit a server's authentication-attempt limit. For that
  host, select its public key with `IdentityFile` and `IdentitiesOnly yes`.
- A missing backend is skipped during listing and can appear after it starts.
  A backend that accepts connections but fails requests can still cause errors.
- 1Password sees the mux as its socket client. Its approval attribution may
  differ from direct connections; confirm the prompts on first use.
- Agent forwarding remains disabled. Do not rely on this mux for OpenSSH
  destination-constrained keys or enable forwarding on that assumption.

Sources: [mux configuration](https://github.com/overhacked/ssh-agent-mux/tree/v0.2.0#configuration),
[1Password authorization](https://www.1password.dev/ssh/agent/security),
[GCR key discovery](https://github.com/GNOME/gcr/blob/4.4.0.1/gcr/gcr-ssh-agent-preload.c).
