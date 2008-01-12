# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# last modified by skullY 01.12.08 - initial commit
# relaysmtp - Relay messages to and from irc using email
# Original implementation 2007 Aug 12, Zach White (skullY@EFnet)
# Cleaned up and contributed to amnesiac, 2008 Jan 12
#
# This script lets you send and receive irc messages via smtp. You must have
# a way to get email to your irc client. Many carriers support sending email
# via sms, allowing you to use this script to relay via sms.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage relaysmtp;

# /config stuff
osetitem relaysmtp rsmtpstatus SMTP relay on/off:;
alias config.rsmtpstatus {
	if ([$0]==[-r]) {
		if ([$_modsinfo.relaysmtp.phoneStatus]==[0]) {
			return off;
		} else {
			return on;
		};
	} elif ([$0]==[-s]) {
		# Change or toggle the current status (on/off)
		switch ($1) {
			(on) {
				@_modsinfo.relaysmtp.phoneStatus = 1;
			}
			(off) {
				@_modsinfo.relaysmtp.phoneStatus = 0;
			}
			(toggle) {
				if (_modsinfo.relaysmtp.phoneStatus==0) {
					@_modsinfo.relaysmtp.phoneStatus = 1;
				}{
					@_modsinfo.relaysmtp.phoneStatus = 0;
				};
			};
		};
		xecho -b relaysmtp: Current status is $_modsinfo.relaysmtp.statusType[$_modsinfo.relaysmtp.phoneStatus];
	};
};

osetitem relaysmtp rsmtpemailuser Email username:;
alias config.rsmtpemailuser {
	# The username for the outgoing email
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailUser;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailUser = "$1";
		xecho -b relaysmtp: Current email username is $_modsinfo.relaysmtp.emailUser;
	};
};

osetitem relaysmtp rsmtpemailpass Email shared key:;
alias config.rsmtpemailpass {
	# The shared key we put in outgoing email
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailPass;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailPass = "$1";
		xecho -b relaysmtp: Current email shared key is $_modsinfo.relaysmtp.emailPass;
	};
};

osetitem relaysmtp rsmtpemaildomain Email domain:;
alias config.rsmtpemaildomain {
	# The domain we send email from
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailDomain;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailDomain = "$1";
		xecho -b relaysmtp: Current email domain is $_modsinfo.relaysmtp.emailDomain;
	};
};

osetitem relaysmtp rsmtpemailsep Email separator:;
alias config.rsmtpemailsep {
	# What separates the components of the email address
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailSep;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailSep = "$1";
		xecho -b relaysmtp: Current email separator is $_modsinfo.relaysmtp.emailSep;
	};
};

osetitem relaysmtp rsmtpdestaddress Relay destination:;
alias config.rsmtpdestaddress {
	# The address we relay messages to
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.destAddress;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.destAddress = "$1";
		xecho -b relaysmtp: Current relay destination is $_modsinfo.relaysmtp.destAddress;
	};
};

osetitem relaysmtp rsmtpsendmail Sendmail:;
alias config.rsmtpsendmail {
	# The location of the sendmail binary
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.sendmail;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.sendmail = "$1";
		xecho -b relaysmtp: Current sendmail location is $_modsinfo.relaysmtp.sendmail;
	};
};

## Aliases refered to by the config
alias rsmtphelp {
	xecho -b Call 999!;
};

alias rsmtpload {
	xecho -b Not implemented (rsmtpload);
};

alias rsmtpunload {
	xecho -b Not implemented (rsmtpunload);
};

alias rsmtpsave {
	xecho -b Not implemented (rsmtpsave);
};

## Internal aliases

# Send mail to the phone
alias _sendmail (ircDest, msg) {
	local emailAddress ${_modsinfo.relaysmtp.emailUser}${_modsinfo.relaysmtp.emailSep}${_modsinfo.relaysmtp.emailPass}${_modsinfo.relaysmtp.emailSep}${ircDest}@${_modsinfo.relaysmtp.emailDomain}
	fe ($exec($_modsinfo.relaysmtp.sendmail -f $emailAddress $_modsinfo.relaysmtp.destAddress)) in out err {break};
	@close($err);
	@write($in, To: $_modsinfo.relaysmtp.destAddress);
	@write($in, From: $emailAddress);
	@write($in, Subject: ${ircDest}!$userhost($ircDest));
	@write($in, );
	@write($in, $msg);
	@close($in);
	@close($out);
	# FIXME: Do we need error checking here?
};

# The alias that processes the queue
alias _smtpQueueProcess (void) {
	if (fexist($_modsinfo.relaysmtp.cmdQueue) == 1) {
		exec mv $_modsinfo.relaysmtp.cmdQueue ${_modsinfo.relaysmtp.cmdQueue}.work;
		# FIXME: Properly check for the exec's return
		local x 5;
		while (x > 0) {
			if (!fexist($_modsinfo.relaysmtp.cmdQueue)) {
				break;
			}
			sleep 1;
			@x--;
		};
		@smtpQueue = open("${_modsinfo.relaysmtp.cmdQueue}.work" R);
		# FIXME: Doesn't epic have a function for this?
		exec rm ${_modsinfo.relaysmtp.cmdQueue}.work;
		while (1) {
			if (eof($smtpQueue)) {
				break;
			}
			@line = read($smtpQueue)
			if (strip(" " $line)!=[]) {
				xecho -b relaysmtp: /msg $line;
				msg $line;
			}
		};
		@close($smtpQueue);
	}
	timer -ref relaysmtp 10 _smtpQueueProcess;
};

# The hook to send messages to our phone.
^on -MSG * (ircDest, msg) {
	if (msg=[on]) {
		smtp on;
	} elif (msg=[off]) {
		smtp off;
	} elif (cw_modsinfo.relaysmtp.phoneStatus == 1) {
		_sendmail $ircDest $msg;
	} elif (cw_modsinfo.relaysmtp.phoneStatus == 2) {
		# This will eventually be for only getting msged from certain
		# people
		_sendmail $ircDest $msg;
	};
};

## Configuration Aliases

# The alias that lets the user turn smtp on and off
alias relaysmtp (status) {
	if ([$status]==[]) {
		xecho -b relaysmtp: Current status is $_modsinfo.relaysmtp.statusType[$_modsinfo.relaysmtp.phoneStatus];
	}{
		config.rsmtpstatus -s $status;
	};
};

# Finish up by starting the queue
_smtpQueueProcess;
