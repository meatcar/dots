{ inputs, pkgs, ... }:
{
  imports = [ inputs.hunk.homeManagerModules.default ];

  programs.hunk.package = inputs.hunk.packages.${pkgs.system}.hunk;

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "auto";
      mode = "auto";
      line_numbers = false;
      wrap_lines = true;
      agent_notes = true;
    };
  };
}
