####
#
# Copyright (c) 2012, Christian "crshd" Brassat
# All rights reserved.
#
# See below for full license text
#
#------
#
# v0.1: first release
#
###

use strict;
use Irssi;
use Irssi::TextUI;

my $VERSION = "0.3";

my %IRSSI = (
    name        => 'ichat',
    authors     => 'Christian "crshd" Brassat',
    contact     => 'crshd@mail.com',
    license     => 'BSD',
    description => 'Print iChat-style timestamps',
    url         => 'http://crshd.anapnea.net/',
    changed     => '2012-10-02',
);

my %config;

Irssi::settings_add_str("ichat", "ichat_timestamp_prefix" => "          [");
$config{"prefix"} = Irssi::settings_get_str("ichat_timestamp_prefix");
Irssi::settings_add_str("ichat", "ichat_timestamp_suffix" => "]");
$config{"suffix"} = Irssi::settings_get_str("ichat_timestamp_suffix");
Irssi::settings_add_str("ichat", "ichat_timestamp_timeout" => "600");
$config{"timeout"} = Irssi::settings_get_str("ichat_timestamp_timeout");

Irssi::theme_register([
    'ichat_timestamp', '%K$0%Y$1$n%K$2%n'
]);

my $window_dates = {};

sub time_string {
    my @time = localtime($_[0]);
    return sprintf("%02d:%02d", $time[2], $time[1]);
}

sub event_hook {
    my ($server, $data, $nick, $address) = @_;

    # Find buffer
    my ( $window, undef ) = split(/ /, $data);

    # Current time
    my $time = time();

    # Print timestamp
    if (exists $window_dates->{$window}) {
        $server->printformat($window, MSGLEVEL_CLIENTCRAP, 'ichat_timestamp', $config{'prefix'}, time_string($time), $config{'suffix'}) if ($window_dates->{$window} <= ($time - $config{"timeout"}));
    }

    # Update date in $window_dates hash
    $window_dates->{$window} = $time;

    # All is good...
}

Irssi::signal_add("event privmsg", \&event_hook);

__END__

LICENSE:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

CHANGELOG:

v0.3:
    * Using printformat
    -- 2012-10-02

v0.2:
    * Added option for timeout
    -- 2012-02-15

v0.1
    * Initial release
    -- 2012-02-09
