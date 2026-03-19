# Secrets

Managed with [ragenix](https://github.com/yaxitech/ragenix) + [age-plugin-1p](https://github.com/1Password/age-plugin-1p) (1Password).

## New machine setup

1. Sign in to 1Password and authenticate the CLI (`op whoami`).
2. Generate an age identity:
   ```sh
   mkdir -p ~/.config/age
   age-plugin-1p -s > ~/.config/age/age-plugin-1p-identity.txt
   ```
3. Add the printed public key to `secrets.nix`, then rekey: `agenix -r`
