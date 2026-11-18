{ config, pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      reporting = "off";
      disableStartupPopups = true;
      gui = {
        showFileTree = true;
        nerdFontsVersion = "3";
        useHunkModeInStagingView = false;
        theme = {
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
      };
      git.autoFetch = false;
      git.pagers = [
        {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --paging=never";
        }
      ];
    };
  };

  # NOTE: erase first, carapace claims lazygit with a coarser spec
  programs.fish.completions.lazygit.body = ''
    complete -e -c lazygit
    ${config.programs.lazygit.package}/bin/lazygit completion fish | source
  '';
}
