# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage channel;

## misc op funcs/alias
alias not {^topic -$C;};
alias untopic not;
alias t {topic $*;};
alias c {//mode $C $*;};
alias ik {invkick $*;};
alias ki {invkick $*;};
alias cmode {c $*;};
alias lall partall;
alias chanlock lockchan;
alias lockchan {mode $C +im;};
alias unlock {mode $C -im;};

## chan info.
alias scano {sco $*;};
alias scanv {scv $*;};
alias scann {scn $*;};
alias n {^names $C;};

## misc abstract funcs/aliases
alias epart emopart;
alias emopart {
	part $C $srand$randread($(loadpath)reasons/emopart.reasons);
};

alias partall {
	part $sar(g/ /,/$mychannels());
};

## oper /who in #chan <-- am i the only one who thinks this is ugly? //zak
alias cops {
	^on who -*;
	^on ^who * {
		@:ck=left(2 $2);  
		if ( ck =='G*' || ck == 'H*') {
			xecho $[9]0 $[9]1 $[20]5 $3@$4;
		};
	};
	if (@) {
		who $0;
	}{
		who $C;
	};
	wait;
	^on who -*;
	^on ^who * {
		xecho $fparse(format_who $*);
	};
};

alias unkey {
        if (match(*k* $chanmode())) {
                //mode $C -k;
        } else {
                xecho -b No key on channel $C;
        };
};

alias kick {
	if (ischannel($0) ) {
		@:target=*0;
		@:people=*1;
		@:reason="$2-";
	} {
		@:target=C;
		@:people=*0;
		@:reason="$1-";
	};
	
	if (!numwords($reason)) {
		@:reason=randread($(loadpath)reasons/kick.reasons);
	};

	fe ($split(, $people)) cur {
		//kick $target $cur $reason;
	};
};

alias _massmode (chan,mode,users) {
	@:mm=_maxmodes();
	@:ch=left(1 $mode);
	@:s=rest(1 $mode);
	if (!@s) {
		return;
	};
	@:cs="";
	@:cm="";
	while (@users) {
		@:cu = pop(users);
		fe ($jot(1 $strlen($s))) dummy {
			^push cs $cu;
		};
		@cm= "$(cm)$s";
	};
	while (@cm)
	{
		^quote mode $chan $(ch)$left($mm $cm) $leftw($mm $cs);
		@cs=restw($mm $cs);
		@cm = rest($mm $cm);

	};
};
alias 4op {
	@_massmode($C +oooo $*);
};

alias 4v {
	@_massmode($C +vvvv $*);
};

alias invkick {
	if (@) {
		//mode $C +i;
		kick $*;
		timer 10 mode $C -i;
	};
};

## basic chanop funcs /op /voice /deop /devoice
alias op {
	if (!@) {
		xecho -b Usage: /op <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 +o $1-);
		}{
			@_massmode($C +o $*);
		};
	};
};

alias v {voice $*;};
alias voice {
	if (!@) {
		xecho -b Usage: /voice <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 +v $1-);
		}{
			@_massmode($C +v $*);
		};
	};
};

alias dv {devoice $*;};
alias devoice {
	if (!@) {
		xecho -b Usage: /devoice <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 -v $1-);
		}{
			@_massmode($C -v $*);
		};
	};
};

alias dop {deop $*;};
alias deop {
	if (!@) {
		xecho -b Usage: /deop <nickname|#channel> <nickname>;
	}{
		if (match(*#* $*)) {
			@_massmode($0 -o $1-);
		}{
			@_massmode($C -o $*);
		};
	};
};

## mass chan modes /mv /mdv /mop /mdeop /mreop
alias mv {
	@_massmode($C +v $nochops());
};

## do we really need a massdevoice? needs to be rewritten anyways.

alias mreop {
	@_massmode($C +o $chops());
};

alias allop mop;
alias mop {
	@_massmode($C +o $nochops());
};

alias alldeop mdeop;
alias mdop mdeop;
alias mdeop {
	if (@) {
		@:_chanm=sar(g/,/ /$rest(1 $0-))
		xecho -b mass deoping $C minus $_chanm;
		@_massmode($C -o $remw($servernick() $remws($_chanm / $chops())));
	}{
		xecho -b mass deoping $C;
		@_massmode($C -o $remw($servernick() $chops()));

	};
};

## cycle chan
alias cycle {
	@:chan=ischannel($0)?(*0):C;
	@:key=key($chan);
	if (ischannel($chan)) {
		xecho -b cycling on channel $chan\, one moment...;
		^quote part $chan;wait;join $chan $key;
	};
};

## emo cycle, randreads from emopart.reason
alias ecycle {
        @:chan=ischannel($0)?(*0):C;
        @:key=key($chan);
        xecho -b emo cycling on channel $chan\, one moment...;
        ^emopart $chan;wait;join $chan $key;
};

alias waitop {
	timer $srand($time())$rand(10) {
		if (! [$ischanop($0 $1)]) { 
			mode $1 +o $0 };
		};
	};

## mass kick modes. /lk /mkn /mko /mkn
alias lk {
	if (@) {
		fe ($nochops()) n1 {
			if (!ischanvoice($n1)) {
				k $n1 $*;
				};
		  	};
	}{
		fe ($nochops()) n1 {
			if (!ischanvoice($n1)) {
			k $n1 mass kick;
			};
		};
	};
};

alias mko {
	if (@) {
		fe ($remw($servernick() $chops())) n1 {
			k $n1 $*;
		};
	}{
		fe ($remw($servernick() $chops())) n1 {
			k $n1 mass kick;
	       	};
	};
};

alias mkn {
	if (@) {
		fe ($remw($servernick() $nochops())) n1 {
			k $n1 $*;
		};
	}{
		fe ($remw($servernick() $nochops())) n1 {
			k $n1 mass kick;
		};
	};
};

alias massk {
	if (!@) {
		xecho -b usage: /massk <version string>;
	}{
		@kvar=*0;
		xecho -b kicking all users with $kvar in version reply.;
		^ver $C;
		^on ^ctcp_reply "% % VERSION *" {
			if (ischanop($0 $C)==0 || kickops == 'on') {
				if (match(*$kvar* $2-)) {
					k $0 $kvar is leet!@#$%^&*;
				};
			};
			^timer 50 ^on ^ctcp_reply -"% % VERSION *";
		};
	};
};
