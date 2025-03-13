{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (
      pkgs.writeShellScriptBin "aider" ''
        source ${config.age.secrets.aienv.path}
        ${pkgs.aider-chat}/bin/aider "$@"
      ''
    )
  ];
  package.git.ignores = [
    ".aider*"
  ];
}
