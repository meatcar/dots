{
  pkgs,
  ...
}:
{
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode-fhs;
  # TODO: vscode-fhs environment has trouble reading .ssh/config.
  # hack source: https://github.com/nix-community/home-manager/issues/322#issuecomment-1856128020
  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = "cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config";
  };
  programs.git.ignores = [
    ".roo*"
    ".repomixignore"
    "memory-bank/"
  ];
  home.sessionVariables = {
    "NEXT_TELEMETRY_DISABLED" = "1";
  };

  # This is a workaround to make direnv work with VS Code's integrated terminal
  # when using the direnv extension, by making sure to reload
  # the environment the first time terminal is opened.
  #
  # See <https://github.com/direnv/direnv-vscode/issues/561#issuecomment-2310756248>.
  #
  # The variable VSCODE_INJECTION is apparently set by VS Code itself, and this is how
  # we can detect if we're running inside the VS Code terminal or not.
  # programs.fish.interactiveShellInit = ''
  #   # if test \( -n "$VSCODE_INJECTION" \) -o \( -n "$ZED_TERM" \)
  #   if test -n "$VSCODE_INJECTION"
  #       and test -z "$VSCODE_TERMINAL_DIRENV_LOADED"
  #       and test -f .envrc

  #       # fish only emits `fish_prompt` in interactive mode,
  #       # so emit it explicitly to trigger direnv to reload.
  #       cd ..
  #       emit fish_prompt
  #       cd -
  #       emit fish_prompt

  #       # I'm not sure if this is actually helpful?
  #       # new terminals created by vscode don't inheret env variables,
  #       # so all new terminals will still re-execute this
  #       if test -n "$VSCODE_INJECTION"
  #         export VSCODE_TERMINAL_DIRENV_LOADED=1
  #       end
  #   end
  # '';
}
