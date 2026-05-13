{
  imports = [
    (import ../lib/mkUser.nix {
      fullName = "Denys Pavlov";
      email = "github@denys.me";
    })
  ];

  launchd.agents.syncthing = {
    enable = true;
    config = {
      ProgramArguments = [
        "/opt/homebrew/bin/syncthing"
        "serve"
        "--no-browser"
        "--no-restart"
        "--logflags=0"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/Users/denys/Library/Logs/syncthing.log";
      StandardErrorPath = "/Users/denys/Library/Logs/syncthing.log";
    };
  };
}
