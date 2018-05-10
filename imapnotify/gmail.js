var child_process = require('child_process');

function getStdout(cmd) {
  var stdout = child_process.execSync(cmd);
  return stdout.toString().trim();
}

const options = module.exports = {};

options.host = "imap.gmail.com";
options.port = 993;
options.tls = true;
options.tlsOptions = { "rejectUnauthorized": false };
options.username = "denys.pavlov@gmail.com";
options.password = getStdout("pass show email/offlineimap/gmail | head -n1");
options.onNewMail = "/usr/bin/systemctl --user start mbsync@gmail-quick";
options.onNewMailPost = {
    "mail": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail 'gmail: new in %s'",
    "update": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'gmail: update %s'",
    "expunge": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'gmail: expunge %s'"
}
options.boxes = [ "inbox" ];
