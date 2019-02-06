var child_process = require('child_process');

function getStdout(cmd) {
  var stdout = child_process.execSync(cmd);
  return stdout.toString().trim();
}

exports.host = "imap.fastmail.com";
exports.port = 993;
exports.tls = true;
exports.tlsOptions = { "rejectUnauthorized": false };
exports.username = "denys@fastmail.com";
exports.password = getStdout("pass show email/offlineimap/fastmail | head -n1");
exports.onNewMail = "/usr/bin/systemctl --user start mbsync@fastmail";
exports.onNewMailPost = {
    "mail": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail 'fastmail: new in %s'",
    "update": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'fastmail: update %s'",
    "expunge": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'fastmail: expunge %s'",
}
exports.boxes = [ "inbox" ];
