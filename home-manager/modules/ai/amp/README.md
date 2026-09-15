# Amp accounts

Run `amp-p login` and `amp-w login`, choosing the
appropriate account in the browser each time. Then use either account:

```sh
amp-p
amp-w threads list
```

`amp-p` uses the personal account; `amp-w` uses work.
Arguments and stdin pass through to Amp.
Plain `amp` and the existing `nono-agent` profiles are unchanged.

Each account starts empty. Its config, credentials, threads, caches, and
`~/.amp` state live under `$XDG_DATA_HOME/amp-accounts/<account>`, defaulting
to `~/.local/share/amp-accounts/<account>`. Watson persists that directory.
Configure settings and authenticate MCP servers separately for each account.
The launcher clears inherited `AMP_API_KEY`, `AMP_SETTINGS_FILE`, and
`AMP_LOG_FILE` so they do not override the selected account's state.

Bubblewrap mounts these directories over Amp's normal paths without changing
`HOME` or the XDG variables. Git, SSH, editor integration, networking, and
other tools retain their usual configuration. Global skills in `~/.agents`
and project files remain shared.

This is account selection, not a security sandbox. Processes can still read
the host filesystem, including other accounts' backing directories. Explicit
Amp settings/log flags can also select paths outside the account directories.
Do not nest account launchers.
