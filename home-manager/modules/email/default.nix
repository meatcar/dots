{
  pkgs,
  ...
}:
let
  mkAccount = name: email: {
    address = email;
    userName = email;
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email ${email}";
    folders.inbox = "INBOX";
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
      boxes = [ "INBOX" ];
      onNotify = "${pkgs.isync}/bin/mbsync ${name}:INBOX && ${pkgs.mu}/bin/mu index";
      onNotifyPost = "${pkgs.libnotify}/bin/notify-send -a mail '${name}: new in %s'";
    };
  };
in
{
  imports = [
    ../gnome-keyring.nix
    ../neomutt
  ];
  accounts.email.accounts = {
    fastmail = (mkAccount "fastmail" "denys@fastmail.com") // {
      primary = true;
      address = "me@denys.me";
      aliases = [
        ".*@denys.me"
        ".*@dnka.ca"
      ]; # regex gets passed to neomutt
      realName = "Denys Pavlov";
      flavor = "fastmail.com";
    };
    gmail = (mkAccount "gmail" "denys.pavlov@gmail.com") // {
      aliases = [
        "denys.pavlo(v|v\\+.*)@gmail.com"
        "shagydo(g|g\\+.*)@gmail.com"
      ];
      realName = "Denys Pavlov";
      flavor = "gmail.com";
    };
    zoho = (mkAccount "zoho" "denys.pavlov@zoho.com") // {
      address = "denys@dnka.ca";
      aliases = [ "denys.pavlov@zoho.com" ];
      realName = "Denys";
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
        fastmail = [ ]; # all
        gmail = [
          "INBOX"
          "[Gmail]"
        ];
        zoho = [ ]; # all
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
    neomutt
    isync
    msmtp
  ];
}
