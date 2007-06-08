# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
subpackage wall;

## msg wall(hybrid/ratbox based ircds)
alias wall {
	/msg @$C $*;
};

alias _bwallform (chan,text) {
	@:pf=left(1 $chan);
	@chan=after($pf $chan);
	xecho -l publics -t $chan $fparse(format_bwall $pf $chan $text);
};
alias _wallform (nick,chan,text) {
	@:pf=left(1 $chan);
	@chan=after($pf $chan);
	xecho -l publics -t $chan $fparse(format_wall $pf $nick $chan $text);
};

fe (send_notice send_msg) con {
	fec (@+) cc {
		on ^$con "$cc#*" (chan, text) {
			@_bwallform($chan $text);
		};
	};
};

fe (public public_notice public_other) con {
	fec (@+) cc {
		on ^$con "% $cc#*" (nick, chan, text) {
			@_wallform($nick $chan $text);
		};
	};
};
