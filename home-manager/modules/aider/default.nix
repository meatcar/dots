{
  config,
  pkgs,
  specialArgs,
  ...
}:
let
  uPkgs = specialArgs.nixpkgs-unstable;
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "aider" ''
      source ${config.age.secrets.aienv.path}
      ${uPkgs.aider-chat}/bin/aider \
        --config '${config.xdg.configHome}/aider/aider.conf.yml' \
        --chat-history-file '${config.xdg.dataHome}/aider/chat-history.json' \
        --input-history-file '${config.xdg.dataHome}/aider/input-history.json' \
        "$@"
    '')

    (pkgs.writeShellScriptBin "opencode" ''
      source ${config.age.secrets.aienv.path}
      ${uPkgs.opencode}/bin/opencode "$@"
    '')
  ];
  programs.git.ignores = [
    ".aider*"
  ];

  xdg.configFile."aider/aider.conf.yml".text = builtins.toJSON {
    read = [
      "AGENTS.md"
      ".rules"
      "CONTRIBUTING.md"
      ".cursor"
    ];
    notifications = true;
    cache-prompts = true;
    analytics-disable = true;
    git-commit-verify = true;
  };
}
