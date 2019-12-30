var child_process = require('child_process');

function getStdout(cmd) {
  var stdout = child_process.execSync(cmd);
  return stdout.toString().trim();
}

exports.host = "imap.gmail.com";
exports.port = 993;
exports.tls = true;
exports.tlsOptions = { "rejectUnauthorized": false };
exports.username = "denys.pavlov@gmail.com";
exports.password = getStdout("1pass -p gmail | head -n1");
exports.onNotify = "systemctl --user start mbsync@gmail-quick";
exports.onNotifyPost = {
    "mail": "mu index --maildir=/home/meatcar/mail && notify-send -a mail 'gmail: new in %s'",
    "update": "mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'gmail: update %s'",
    "expunge": "mu index --maildir=/home/meatcar/mail && notify-send -a mail -u low 'gmail: expunge %s'"
}
exports.boxes = [ "inbox" ];
