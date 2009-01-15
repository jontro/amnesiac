# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage lag;

## from psykotyk's orb
## This code does not support multiple servers
alias _relag {
	@ _rlt = time();
	//quote ping $S;
};

^on ^pong * {
	if (*1 == S) {
		if (time()-_rlt > 400) {
			^set status_user1 ??;
		}{ 
			^set status_user1 ${time()-_rlt};
		};
	};
	^assign -_rlt;
	timer -window -1 -refnum 43 15 _relag;
};
_relag;
## end psykotyk's orb.

alias sping (svar default "$S", void) {
	@pstart = time();
	//quote ping $svar :$svar;
	@_pong($svar);
};

alias _pong (svar) {
	^on #-pong 10 "$svar *" {
		xecho -b your lag to $0 is: ${time() - pstart} second(s);
		^on #-pong 10 -"$0 *";
	};
};
