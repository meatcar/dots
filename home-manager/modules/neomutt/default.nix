{
  pkgs,
  config,
  ...
}: let
  accounts = config.accounts.email.accounts;
  names = builtins.attrNames accounts;
  mailcap = pkgs.writeText "mailcap" ''
    application/msword; ${./view_attachment.sh} %s "-" '${pkgs.catdocx}/bin/catdocx'
    image/jpg; ${./view_attachment.sh} %s jpg
    image/jpeg; ${./view_attachment.sh} %s jpg
    image/pjpeg; ${./view_attachment.sh} %s jpg
    image/png; ${./view_attachment.sh} %s png
    image/gif; ${./view_attachment.sh} %s gif
    application/pdf; ${./view_attachment.sh} %s pdf
    text/html; ${pkgs.python3}/bin/python ${./viewhtmlmail} %s; test=test -n "$DISPLAY"; nametemplate=%s.html; needsterminal;
    text/html; ${pkgs.python3Packages.html2text}/bin/html2text --ignore-links --reference-links --ignore-tables; copiousoutput;
    text/plain; cat; copiousoutput;
    # Unidentified files
    application/octet-stream; ${./view_attachment.sh} %s "-"
  '';

  mkAccountFile = name: let
    account = builtins.getAttr name accounts;
    mbox = builtins.getAttr name {
      gmail = "[Gmail]/All\\ Mail";
      fastmail = "Archive";
      zoho = "Archives";
    };
    archive = builtins.getAttr name {
      gmail = "[Gmail]/All ";
      fastmail = "Archive";
      zoho = "Archives";
    };
    drafts = builtins.getAttr name {
      gmail = "[Gmail]/Drafts";
      fastmail = "Drafts";
      zoho = "Drafts";
    };
    trash = builtins.getAttr name {
      gmail = "[Gmail]/Trash";
      fastmail = "Trash";
      zoho = "Trash";
    };
    spam = builtins.getAttr name {
      gmail = "[Gmail]/Spam";
      fastmail = "Spam";
      zoho = "Spam";
    };
    sent = builtins.getAttr name {
      gmail = "[Gmail]/Sent\\ Mail";
      fastmail = "Sent";
      zoho = "Sent";
    };
    color = builtins.getAttr name {
      gmail = "white";
      fastmail = "blue";
      zoho = "red";
    };
  in
    pkgs.writeText "${name}_account" ''
      # vim: ft=muttrc
      set realname  = "${account.realName}"
      set from      = "${account.address}"
      set spoolfile = "+${name}/INBOX"
      set mbox      = "+${name}/${mbox}"
      set postponed = "+${name}/${drafts}"
      set trash     = "+${name}/${trash}"
      set sendmail  = "msmtpq -a ${name}"

      unalternates *
      alternates ${builtins.toString account.aliases}

      unmailboxes *
      named-mailboxes \
        INBOX +${name}/INBOX \
        Archive +${name}/${mbox} \
        Sent +${name}/${sent} \
        Drafts +${name}/${drafts}

      color status ${color} default

      macro index,pager o "<shell-escape>mbsync ${name}<enter>" "run offlineimap to sync mail"

      # TODO: save to folder, fix weird trailing path added in gmail
      macro index,pager ma \
      "<tag-prefix><save-message>+${name}/${archive}<enter><sync-mailbox>" \
      "archive message"

      macro index,pager mt \
      "<tag-prefix><save-message>+${name}/${trash}<enter><sync-mailbox>" \
      "move message to the trash"

      macro index,pager ms \
      "<tag-prefix><save-message>+${name}/${spam}<enter><sync-mailbox>" \
      "mark message as spam"

      macro index,pager \cf \
      "<shell-escape>${./mutt-mu} ${name}<enter><change-folder-readonly>~/.cache/mu/search<enter>" \
      "search mail (using mu)"
    '';
  mkFolderHook = name: let
    key = builtins.substring 0 1 name;
    file = mkAccountFile name;
  in ''
    source ${file}
    folder-hook =+${name}/.* source ${file}
    macro index,pager \\${key} "<change-folder>+${name}/INBOX<enter>" "change accounts ${name}"

  '';
  accountSettings = let
    primary = builtins.filter (n: (builtins.getAttr n accounts).primary) names;
  in ''
    # \\+<first letter> to switch between accounts
    bind index,pager \\ noop
    ${builtins.toString (builtins.map mkFolderHook names)}

    ${builtins.toString (builtins.map (name: "source ${mkAccountFile name}") primary)}

    # Mailboxes to always show in the sidebar.
    folder-hook .* mailboxes "+_" \
    ${builtins.toString (builtins.map (name: "+${name}/INBOX") names)}

  '';
in {
  home.packages = with pkgs; [neomutt urlscan mu];
  xdg.configFile."neomutt/meatcar.mutt".source = ./meatcar.mutt;
  xdg.configFile."neomutt/neomuttrc".text = ''
    set mailcap_path = ${mailcap}
    set folder = ${config.accounts.email.maildirBasePath}
    ${builtins.readFile ./neomuttrc}
    ${builtins.readFile ./bindings}
    # Links
    macro index,pager,attach,compose gl "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>" "View all links in message"
    macro index,pager gb "<shell-escape>mkdir -p /tmp/mutttmpbox<enter><copy-message>/tmp/mutttmpbox<enter><shell-escape>${pkgs.python3}/bin/python ${./viewhtmlmail} /tmp/mutttmpbox<enter><shell-escape>rm -rf /tmp/muttmpbox<enter>" "View message in Browser"

    # Account Settings -----------------------------------
    ${accountSettings}
  '';
}
