var child_process = require('child_process');

function getStdout(cmd) {
  var stdout = child_process.execSync(cmd);
  return stdout.toString().trim();
}

exports.host = "imap.zoho.com";
exports.port = 993;
exports.tls = true;
exports.tlsOptions = { "rejectUnauthorized": false };
exports.username = "denys.pavlov@gmail.com";
exports.password = getStdout("pass show email/offlineimap/zoho | head -n1");
exports.onNewMail = "/usr/bin/systemctl --user start mbsync@zoho";
exports.onNewMailPost = {
    "mail": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail 'zoho: new in %s'",
    "update": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'zoho: update %s'",
    "expunge": "/usr/bin/mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'zoho: expunge %s'",
}
exports.boxes = [ "inbox" ];
