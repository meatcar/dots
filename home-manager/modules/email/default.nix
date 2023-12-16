{
  pkgs,
  config,
  ...
}: let
  mkAccount = name: email: {
    address = email;
    userName = email;
    passwordCommand = "${pkgs.gnome3.libsecret}/bin/secret-tool lookup email ${email}";
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      remove = "both";
      extraConfig.local = {
        SubFolders = "Verbatim";
      };
      extraConfig.account = {
        # faster than 1, more stable than none, esp for initial syncs
        PipelineDepth = 50;
      };
    };
    msmtp.enable = true;
    imapnotify = {
      enable = true;
      boxes = ["Inbox"];
      onNotify = "${pkgs.isync}/bin/mbsync ${name} && ${pkgs.mu}/bin/mu index";
      onNotifyPost = {
        mail = "${pkgs.libnotify}/bin/notify-send -a mail '${name}: new in %s'";
        update = "${pkgs.libnotify}/bin/notify-send -a mail '${name}: update %s'";
        expunge = "${pkgs.libnotify}/bin/notify-send -a mail '${name}: expunge %s'";
      };
    };
  };
in {
  accounts.email.accounts = {
    fastmail =
      (mkAccount "fastmail" "denys@fastmail.com")
      // {
        primary = true;
        address = "me@denys.me";
        aliases = [".*@denys.me" ".*@dnka.ca"]; # regex gets passed to neomutt
        realName = "Denys Pavlov";
        imap.host = "imap.fastmail.com";
        smtp.host = "smtp.fastmail.com";
      };
    gmail =
      (mkAccount "gmail" "denys.pavlov@gmail.com")
      // {
        aliases = [
          "denys.pavlo(v|v\\+.*)@gmail.com"
          "shagydo(g|g\\+.*)@gmail.com"
        ];
        flavor = "gmail.com";
        realName = "Denys Pavlov";
        imap.host = "imap.gmail.com";
        smtp.host = "smtp.gmail.com";
      };
    zoho =
      (mkAccount "zoho" "denys.pavlov@zoho.com")
      // {
        address = "denys@dnka.ca";
        aliases = ["denys.pavlov@zoho.com"];
        realName = "Denys Pavlov";
        imap.host = "imap.zoho.com";
        smtp.host = "smtp.zoho.com";
      };
  };

  programs.mbsync = {
    enable = true;
    extraConfig = ''
      CopyArrivalDate yes
    '';
    groups = {
      quick = {
        fastmail = [];
        gmail = ["Inbox" "[Gmail]"];
        zoho = [];
      };
    };
  };
  services.mbsync = {
    enable = true;
    frequency = "*:0/15";
    postExec = "${pkgs.mu}/bin/mu index";
  };
  programs.msmtp.enable = true;
  services.imapnotify.enable = true;

  home.packages = with pkgs; [
    mu
    mblaze
  ];
}
