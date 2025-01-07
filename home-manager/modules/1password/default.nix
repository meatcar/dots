{
  programs.ssh.matchBlocks."*".extraOptions = {
    IdentityAgent = "~/.1password/agent.sock";
  };
}
