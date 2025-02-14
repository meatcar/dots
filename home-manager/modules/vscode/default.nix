{pkgs, ...}: {
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;
  # TODO: vscode-fhs environment has trouble reading .ssh/config.
  # hack source: https://github.com/nix-community/home-manager/issues/322#issuecomment-1856128020
  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
  };
}
