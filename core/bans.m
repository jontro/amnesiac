# Copyright (c) 2003-2010 Amnesiac Software Project. 
# See the 'COPYRIGHT' file for more information.     
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage bans;

## bans funcs
alias bki {bk $*;ignore $0 msgs;};
alias kbi {kb $*;ignore $0 msgs;};
alias bkt {qk $*;};
alias bk {bankick $*;};
alias kb {bankick $*;};
alias unban {ub $*;}
alias clearbans {ub $*;};

alias banstat bans;
alias sb bans;

## ban aliases.
alias fuckem lban;
alias lban {
	//mode $serverchan() +bbb *!*@0.0.0.0/1 *!*@128.0.0.0/1 *!*@0000::/1 $0 $0 $0 $0;
};

## generic mode +b alias. Used all over the place
alias _uhbmode (bt,chan, ...) {
	if ("$3@$4"!='<UNKNOWN>@<UNKNOWN>') {
		//mode $chan +b $mask($bt $0!$3@$4);
	};
};
alias _bmode (bt,nick ,void) {
	fe ($split(, $nick)) cn {
		if (userhost($cn) == '<UNKNOWN>@<UNKNOWN>') {
			userhost $cn -cmd  \{ @ _uhbmode\($bt $serverchan() $$*\)\};
		}{
			//mode $serverchan() +b $mask($bt $cn!$userhost($cn));
		};
	};
};

## Different ban aliases starting here
alias ban (nick,void){
	if (!@nick) {
		xecho -b Usage: /ban nick;
	}{
		fe ($split(, $nick)) cn {
			if (match(*!*@* $cn)) {
				//mode $serverchan() +b $cn;
			}{
				@_bmode($_bt $cn);
			};
		};
	};
};

# Generic bk alias. Used below
alias _bk (aliasname,bt,nick, reason){
	if (!@bt || !@nick) {
		xecho -b Usage: /$aliasname nick1,nick2 [reason];
		return;
	};
	@_bmode($bt $nick);
	if (@reason) {
		kick $nick $reason;
	}{
		kick $nick;
	};
};

alias bankick (nick, reason) {
	@_bk(bankick $_bt $nick $reason);
};

## basically this allows you to specify the bantype you want to
## use on the fly without needing to set /bantype instead now we have
## /bkh(host) /bkb(better) /bkn(normal) /bkd(domain) followed by nick.
## Numbers used below is $mask(...) types
alias bkh (nick, reason){@_bk(bkh 2 $nick $reason);};
alias bkb (nick, reason){@_bk(bkb 3 $nick $reason);};
alias bkn (nick, reason){@_bk(bkn 6 $nick $reason);};
alias bkd (nick, reason){@_bk(bkd 4 $nick $reason);};
## iban alias. (i stands for ident)
alias iban (nick, reason){@_bk(iban 10 $nick $reason);};

## end bankick type on the fly.
alias kickban (nick,reason){
	if (!@nick) {
		xecho -b Usage: /kickban nick1,nick2 [reason];
        }{
		if ( @reason) {
			kick $serverchan() $nick $reason;
		}{
			kick $serverchan() $nick;
                };
		@_bmode($_bt $nick);
	};

};

## temp bk
alias qk (nick,reason) {
	if (!@nick) {
		xecho $acban Usage: /qk <nick> <reason> - will bankick specified nick then unban them after 5 seconds.;
	}{
		if (@reason) {
			@bankick($nick $reason);
		}{
			@bankick($nick);
		};
		^timer 5 \{ub $nick\};
	};
};

## end kicks.

## config

alias kops {
	config.kickops -s $*;
};

alias config.kickops {
	if ( *0 == '-r' ) {
		return $kickops;
	} else if (*0 == '-s') {
		config.matchinput on|off kickops '$1' kick ops on ban;
	};
};

alias bantype {
	config.bantype -s $*;
};

## bantype config. [Norm/Better/Host/Domain]
alias config.bantype {
	if ( *0 == '-r' ) {
		return $bt_;
	} else if (*0 == '-s') {
		if (# == 1) {
			xecho -v $acban bantype set to $bt_;
			xecho -v $acban /bantype <Normal|Better|Host|Domain>;
		}{
			switch ($1) {
			(normal){@bt_='normal';@_bt=6;xecho -v $acban bantype set to normal (n!*u@h.d n!*u@d.h);}
			(better) {@bt_='better';@_bt=3;xecho -v $acban bantype set to better (*!*u@*.d *!*u@d.*);}
			(host) {@bt_='host';@_bt=2;xecho -v $acban bantype set to host (*!*@h.d *!*@d.h);}
			(domain) {@bt_='domain';@_bt=4;xecho -v $acban bantype set to domain (*!*@*.d *!*@d.*);}
			() {xecho -v $acban invalid choice <Normal|Better|Host|Domain>;}
			};
		};
	};
};

osetitem protect kickops Kick ops:;
osetitem protect bantype Ban Type:;
