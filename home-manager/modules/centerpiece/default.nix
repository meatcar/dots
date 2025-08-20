_: {
  programs.centerpiece = {
    enable = true;
    config = {
      color = {
        text = "#ffffff";
        background = "#000000";
      };
      plugin = {
        applications = {
          enable = true;
        };
        brave_bookmarks = {
          enable = true;
        };
        brave_history = {
          enable = true;
        };
        brave_progressive_web_apps = {
          enable = true;
        };
        clock = {
          enable = true;
        };
        firefox_bookmarks = {
          enable = true;
        };
        firefox_history = {
          enable = true;
        };
        git_repositories = {
          enable = true;
          commands = [
            [
              "direnv"
              "exec"
              "$GIT_DIRECTORY"
              "--"
              "code"
            ]
            [
              "direnv"
              "exec"
              "$GIT_DIRECTORY"
              "--"
              "zeditor"
            ]
          ];
        };
        gitmoji = {
          enable = false;
        };
        resource_monitor_battery = {
          enable = true;
        };
        resource_monitor_cpu = {
          enable = true;
        };
        resource_monitor_disks = {
          enable = true;
        };
        resource_monitor_memory = {
          enable = true;
        };
        sway_windows = {
          enable = true;
        };
        system = {
          enable = true;
        };
        wifi = {
          enable = true;
        };
      };
    };

    # enables a systemd service to index git-repositories
    services.index-git-repositories = {
      enable = false;
    };
  };
}
