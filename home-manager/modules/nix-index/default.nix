{ pkgs, ... }: {
  home.packages = [ pkgs.nix-index ];
  programs.fish.functions = {
    __fish_command_not_found_handler =
      let
        command_not_found_wrapper = (pkgs.writeShellScript "command_not_found_wrapper" ''
          source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
          command_not_found_handle $@
        '');
      in
      {
        body = "${command_not_found_wrapper} $argv";
        onEvent = "fish_command_not_found";
      };
  };
}
