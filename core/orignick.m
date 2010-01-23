# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage orignick;

## cmd
alias otime {setorig $*;};
alias jupe {orignick $*;};

## vars
^timer -del 45;
@keepnick=0;

alias orignick {
	if (!@) {
		xecho $acban /orignick <nick> /staynick to cancel;
	}{
		^timer -delete 45;
		@nic="$0";
		@keepnick=1;
		^timer -window -1 -refnum 45 -rep -1 $_ort {
			^getnick $nic
		};
		xecho $acban attempting to jupe $nic /staynick to cancel;
	};
};

alias getnick {
	^userhost $nic -cmd {
		if ("$3@$4" == '<UNKNOWN>@<UNKNOWN>') {
			^nick $nic;
			xecho $acban congrads nick juped. /staynick to cancel;
		}
	};
};

alias staynick {
	^assign -nic;
	@keepnick=1;
	^timer -delete 45;
	xecho $acban /orignick request canceled.;
};

## config output
alias config.origdelay {
	if ( *0 == '-r' ) {
		return $_ort;
	} else if (*0 == '-s') {
		if ("$1" > 0 && "$1" <=10) {
			@_ort="$1";
		} else if (# > 1) {
			xecho -v $acban time out of range. Valid numbers are 1-10;
		};
		xecho -v $acban orignick delay set to "$_ort";
	};
};

alias setorig {
	config.origdelay -s $*;
};

## orignick hooks.
on #-channel_signoff 42 "*" {
	if (keepnick == 1 && '$1' == nic) {
		^nick $nic;
		xecho $acban congrads nick juped. /staynick to cancel;
	};
};

^on #-nickname 33 * {
	if (keepnick == 1 && '$0'== nic) {
		^nick $nic;
		xecho $acban congrads nick juped. /staynick to cancel;
	};
};
