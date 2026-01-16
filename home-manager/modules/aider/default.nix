{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "aider" ''
      source ${config.age.secrets.aienv.path}
      ${nixpkgs-unstable.aider-chat}/bin/aider \
        --config '${config.xdg.configHome}/aider/aider.conf.yml' \
        --chat-history-file '${config.xdg.dataHome}/aider/chat-history.json' \
        --input-history-file '${config.xdg.dataHome}/aider/input-history.json' \
        "$@"
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
    no-auto-commits = true;
  };
}
