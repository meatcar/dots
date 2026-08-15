{
  pkgs,
  llm-agents,
  ...
}:
{
  home.packages = [
    llm-agents.nono
    (pkgs.writeShellApplication {
      name = "nono-agent";
      runtimeInputs = [ llm-agents.nono ];
      text = builtins.readFile ./nono-agent.sh;
    })
  ];

  # Profiles resolve from $XDG_CONFIG_HOME/nono/profiles. Packs are pulled
  # imperatively into the sibling packages/ dir -- they carry sigstore bundles
  # verified on every run, so they are state, not configuration:
  #   nono pull nolabs-ai/{claude,codex,pi} && nono pin nolabs-ai/<name>
  # Pin, or signed third-party code updates itself outside the flake.
  xdg.configFile."nono/profiles/net-tight.json".source = ./net-tight.json;
  xdg.configFile."nono/profiles/subagent.json".source = ./subagent.json;

  programs.fish = {
    completions.nono.body = ''
      ${llm-agents.nono}/bin/nono completion fish | source
    '';
    shellAbbrs = {
      sclaude = "nono run --profile nolabs-ai/claude -- claude";
      # nono is the boundary, so let codex stop fighting it with its own sandbox
      scodex = "nono run --profile nolabs-ai/codex -- codex --sandbox danger-full-access --ask-for-approval on-request";
      spi = "nono run --profile nolabs-ai/pi -- pi";
    };
  };
}
