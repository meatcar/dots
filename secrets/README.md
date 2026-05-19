# Secrets

Managed with [ragenix](https://github.com/yaxitech/ragenix).

## New machine setup

1. Generate an age identity (Home Manager activation does this automatically on first run):
   ```sh
   ssh-keygen -t ed25519 -f ~/.config/age/id_ed25519 -N "" -C "age-identity"
   ```
2. Add the printed public key to `secrets.nix`.
3. On an existing machine with access, rekey all secrets: `agenix -r`

## Backup / recovery

The 1Password-backed identity (`age-plugin-1p`) is kept in 1Password as a fallback.
To recover access from 1Password:

```sh
mkdir -p ~/.config/age
age-plugin-1p --generate "op://Private/oxm6uf777r76ocon5x4otr6lnq/private key" \
  --output ~/.config/age/age-plugin-1p-identity.txt
```

Then use `-i ~/.config/age/age-plugin-1p-identity.txt` with `agenix`.
