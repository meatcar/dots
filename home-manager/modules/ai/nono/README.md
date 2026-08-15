# Named nono agent contexts

This module installs global nono profiles named `<context>-<agent>`. The
initial contexts are `personal` and `work`; each has profiles for Claude,
Codex, Pi, and Amp. `nono-agent <context> <agent> [args...]` starts one, so
`nono-agent personal claude` and `nono-agent work codex` are the canonical
launchers. Fish keeps the short personal aliases (`sclaude`, `scodex`, `spi`)
and adds `samp` plus `wclaude`, `wcodex`, `wpi`, and `wamp`.

These are named global profiles rather than project aliases because a context
is an account boundary that is useful across many repositories. Every profile sets `HOME` and the XDG directories under
`~/.local/share/nono-agent-profiles/<context>/<agent>/`. Amp also gets explicit
settings and log paths there. Persistent agent state is writable only inside
that context root; the launcher separately grants the current worktree. The
profiles deliberately exclude capability groups that expose the host's shared
agent caches or editor configuration, and Git uses a context-local global
configuration. Auth files, sessions, plugins, settings, and Git identity
therefore cannot be reused just because two launchers run the same CLI. Home
Manager creates every declared context root during activation; the root is
persisted on Watson by the impermanence module.

## Adding a client

Declare another context in the host configuration, then use the same launcher.
Names are lowercase letters, digits, and hyphens.

```nix
me.ai.nono.contexts."client-acme" = {
  credentialProvider = "infisical";
  infisical = {
    projectId = "set-the-client-project-id";
    environment = "set-the-client-environment";
    credentials = [
      {
        service = "client_anthropic";
        secretName = "set-the-client-secret-name";
        upstream = "https://api.anthropic.com";
        envVar = "ANTHROPIC_API_KEY";
        injectHeader = "x-api-key";
        credentialFormat = "{}";
        endpointRules = [
          { method = "POST"; path = "/v1/messages"; }
        ];
      }
    ];
  };
};
```

Then run `nono-agent client-acme claude`. No client ID, vault, item, or secret
name is assumed by this module. The Nix assertion requires both an Infisical
project ID and environment when a work/client route is enabled, and rejects
duplicate route names.

## Credentials and SSO

Personal API-key integrations use nono's supported `env_credentials` mapping.
Provide 1Password references only; this module rejects any non-`op://`
reference:

```nix
me.ai.nono.contexts.personal.onePasswordCredentials = {
  "op://<vault>/<item>/<field>" = "ANTHROPIC_API_KEY";
};
```

The reference is resolved by nono at launch, not stored as a value in Nix.
This mechanism intentionally gives the sandboxed client that API-key
variable, so reserve it for personal credentials where that is acceptable.

Work and client routes use nono `custom_credentials` plus
`credential_capture`. The generated supervisor command is equivalent to:

```sh
infisical secrets get --plain --silent --projectId <configured-id> \
  --env <configured-environment> --path <configured-path> <configured-name>
```

It runs lazily outside the sandbox. Nono replaces the sandbox-visible value
with a phantom token and injects the real value only while proxying the
configured HTTPS origin. The captured value never appears in the child
process environment, profile, Nix store, or audit output. Authenticate the
supervisor first with `infisical login`; do not put service tokens in this
configuration.

CLI SSO is separate from API-key routing. Run each CLI's normal login command
through its context launcher (for example, `nono-agent personal claude auth
login` or `nono-agent work codex login`). Its browser callback and resulting
state stay in that context root. Claude, Codex, and Pi use their signed
nolabs-ai capability sets as the reference for the local grants. Amp has no
nolabs-ai profile, so the module uses a local least-privilege profile with an
isolated `HOME`, XDG state, `AMP_SETTINGS_FILE`, `AMP_LOG_FILE`, worktree
access, Nix runtime, and only the exact `https://ampcode.com` browser origin
documented by its CLI. Revisit that origin if Amp changes its login flow.

`varlock` (and environment filtering generally) is not the security boundary.
It helps prevent accidental inherited credentials, but nono's filesystem
sandbox and credential proxy enforce the boundary; the supervisor-side
Infisical capture is what keeps work secret material out of the child.

## Development shells and validation

Profiles compose with repository shells. Either enter a development shell
first and launch an agent there, or use one command:

```sh
nix develop -c nono-agent personal pi
```

The profiles include nono's Nix runtime group but do not grant mutable host
home state. Store-backed Home Manager files remain readable through
`/nix/store`, so they must never contain secrets; context-local environment
variables ensure the tools do not select the host Git configuration. After
changing contexts, format and evaluate the host, then inspect the generated
profiles:

```sh
nix fmt
nix build .#nixosConfigurations.watson.config.system.build.toplevel
nono profile validate ~/.config/nono/profiles/personal-claude.json --strict
nono profile show personal-claude
```
