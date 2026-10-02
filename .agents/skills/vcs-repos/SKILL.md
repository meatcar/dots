---
name: vcs-repos
description: Use when cloning or forking a repo, finding a local checkout, or checking status or fetching updates across multiple repos.
---

- Clone with `forgemap clone OWNER/REPO` or `forgemap clone gitlab:GROUP/REPO`. Paths follow `/git/{hub,lab}/OWNER/REPO`.
- Fork with `gh repo fork OWNER/REPO --clone=false --remote=false`, then `forgemap clone meatcar/REPO`.
- Initialize jj after cloning with `jj git init "$(forgemap path OWNER/REPO)"`. Preserve existing `REPO/REPO-WORKSPACE` layouts; forgemap cannot create those.
- Survey with `hrd ls`, or `hrd` for the TUI. Fetch with `hrd fetch REPO`; use jj for rebasing and pushing.
- Keep forgemap's Git-based cleanup/delete away from jj repositories.
- Treat hrd counts as hints: they cover one ancestor bookmark and one remote, not every unpublished change in a megamerge. Confirm with `jj log`.
- Scope history changes to one repository. hrd lists shared jj workspaces separately; bulk `pull`/`up` rebases them independently.
