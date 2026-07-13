{ inputs, llm-agents, ... }:
{
  imports = [ inputs.hunk.homeManagerModules.default ];

  # same release as the hunk flake, but prebuilt (cache.numtide.com)
  programs.hunk.package = llm-agents.hunk;

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
