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

subpackage relaysmtp

# /config stuff
alias config.rsmtpstatus {
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.phoneStatus;
	} else if ([$0]==[-s]) {
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
				}
			}
		}
	}
}

alias config.rsmtpemailuser {
	# The username for the outgoing email
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailUser;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailUser = "$1";
	}
}

alias config.rsmtpemailpass {
	# The shared key we put in outgoing email
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailPass;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailPass = "$1";
	}
}

alias config.rsmtpemaildomain {
	# The domain we send email from
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailDomain;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailDomain = "$1";
	}
}

alias config.rsmtpemailsep {
	# What separates the components of the email address
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.emailSep;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.emailSep = "$1";
	}
}

alias config.rsmtpdestaddress {
	# The address we relay messages to
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.destAddress;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.destAddress = "$1";
	}
}

alias config.rsmtpsendmail {
	# The location of the sendmail binary
	if ([$0]==[-r]) {
		return $_modsinfo.relaysmtp.sendmail;
	} else if ([$0]==[-s]) {
		@_modsinfo.relaysmtp.sendmail = "$1";
	}
}

## Aliases refered to by the config
alias rsmtphelp {
	xecho -b Call 999!
}

alias rsmtpload {
}

alias rsmtpunload {
}

alias rsmtpsave {
}

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
}

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
		}
		@smtpQueue = open("${_modsinfo.relaysmtp.cmdQueue}.work" R);
		# FIXME: Doesn't epic have a function for this?
		exec rm ${_modsinfo.relaysmtp.cmdQueue}.work;
		while (1) {
			if (eof($smtpQueue)) {
				break;
			}
			@line = read($smtpQueue)
			if (strip(" " $line)!=[]) {
				xecho -b SMS: /msg $line;
				msg $line;
			}
		}
		@close($smtpQueue);
	}
	timer -ref relaysmtp 10 _smtpQueueProcess;
}

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
	}
}

## Configuration Aliases

# The alias that lets the user turn smtp on and off
alias relaysmtp (status) {
	if ([$status]==[]) {
		xecho -b relaysmtp: Current status is $_modsinfo.relaysmtp.statusType[$_modsinfo.relaysmtp.phoneStatus];
	}{
		config.rsmtpstatus -s $status;
		relaysmtp;
	}
}

# Finish up by starting the queue
_smtpQueueProcess;
