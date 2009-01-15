# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
## last modified by rylan on 11.05.06

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage users;

alias chops {
	if (!@) {
		@:chan = "$1" ? "$1" : "$serverchan()";
		fe ($chops($chan)) _foi {
			xecho -v$fparse(format_chops $_foi $chan);
		};
	}{
		if ('$0'=~'*!*@*') {
		@:chan = "$1" ? "$1" : "$serverchan()";
		fe ($chops($chan)) _n1 {
		if (match($0 $_n1!$userhost($_n1))) {
			xecho -v$fparse(format_chops $_n1 $chan);
		};};
	};};
};

alias nops {
	@:chan = "$1" ? "$1" : "$serverchan()";
	fe ($nochops($chan)) _foi {
	if (!@) {
		xecho -v$fparse(format_user_non $_foi $chan);
		};
			
	if ('$0'=~'*!*@*' && match($0 $_foi!$userhost($_foi))) {
		xecho -v$fparse(format_user_non $_foi $chan);
		};
	};
};

alias vocs {
	@:chan = "$1" ? "$1" : "$serverchan()";
	fe ($nochops($chan)) _foi {
	if (!@) {
		if (ischanvoice($_foi $serverchan())) {
		xecho -v$fparse(format_user_vocs $_foi $chan);
		};
	};
	if ('$0'=~'*!*@*' && match($0 $_foi!$userhost($_foi))) {
		if (ischanvoice($_foi $chan) && !ischanop($_foi $chan)) {
		xecho -v$fparse(format_user_vocs $_foi $chan);
		};
	};};
};

## common alias done by adam.
#silence it up some by crapple.
alias common {
	if (*0 =='-q') {
		^local _quiet 1;
		^local _channel1 $1;
		if ([$2]) {
			^local _channel2 $2;
		}{
			^local _channel2 $serverchan();
		};
	}{
		^local _channel1 $0;
		if ([$1]) {
			^local _channel2 $1;
		}{
			^local _channel2 $serverchan();
		};
	};
	if (_channel1) {
		^local common_users $common($chanusers($_channel1) / $chanusers($_channel2));
		unless ((_quiet) && (common_users == N)) {
			xecho -v -b Common users on $_channel1 and $_channel2 \($numwords($common_users)\);
			printnames 0 0 $common_users;
		};
	}{
		xecho -b Usage: /common [-q] <channel1> [channel2];
		xecho -b Shows you the common users between channel1 and channel2, or channel1 and your current channel.;
		xecho -b If -q is passed, only output if there is more than one match.;
	};
};

# props to crapple for the name. -skullY
alias stalker {
	fe ($mychannels()) _channel {
		if (_channel != serverchan()) {
			common -q $_channel;
		};
	};
};
