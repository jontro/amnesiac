# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# last modified by crapple 9.2.05
# windowing stuff
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage window;

## more complex windowing stuff here.
alias channame (cn , void) {
	if (ischannel($cn))
		return $cn;
	return #$cn;
};

alias wj (cn,...){
	if (@cn) {
		^window new channel "$channame($cn) $*" hide swap last;
	}{
		xecho -v $acban usage: /wj <channel> [key];	
        };
};

alias wjn (n , cn, ...){
	if (@n && @cn) {
		if ( @windowctl(GET $n REFNUM) == 0) {
			^window new hide swap last number $n;
		};
		^window $n channel "$channame($cn) $*" swap last;
	}{
		xecho -v $acban usage: /wj <number> <channel> [key];
        };
};

alias mw {
	if (@) {
		switch ($0) {
			(-hidden) {^window new hide swap last level msgs,dccs name msgs;};
			(-split) {^window new double off fixed on size 7 level msgs,dccs status_format %>[msgs] name msgs;^window back;};
			(-kill) {^window msgs kill;};
		};
	}{
		xecho -v $acban /mw -hidden|split|kill <will create/kill a window bound to msgs>;
	};
};

alias winmsg {
	^window new;
	^window level msgs;
	^window size 5;
	^window refnum 1;
};

alias wq {
        if (#) {
                window new_hide swap last query $0;
        } elsif (Q) {
                query;
                ^window $winnum() kill;
        };
};

alias wlk (void) {
	if (@C)
		part $C;
	wk;
};

# Have F3 go to the oldest window, not the newest window.
alias _WSACT {^window swap $rightw(1 $notifywindows());};

## shortend aliases.
alias wc {^window new hide swap last};
alias msgwin {wc;wsl;window level msgs,notices;window name messages;};
alias wsa _wsact;
alias s {window swap $*;};

## misc.
alias wflush window flush_scrollback;
alias cls clear;
alias clsa clear -ALL;

## for Alien88
alias wnc2 {window new hide swap last split off channel $0 $1 $2;};

## misc query qwin/name aliases.
alias qw {wq $*;};
alias q {query $*;};
alias dq {window remove $*;};
alias wadd {window add $*;};

## window shortcuts.
alias wsl window swap last;
alias wka wkh;
alias wkh window kill_all_hidden;
alias wko window kill_others;
alias wsg window grow;
alias wss window shrink;
alias ws window swap;
alias wn window next;
alias wp window previous;
alias wk window killswap;
alias wl window list;

## window toggles/config/options
alias wname {window name $*;};
alias wlog window log toggle;
alias wfile {window logfile $*;};
alias wlevel {window level $*;};
alias wnotify window notify toggle;
alias wnlevel {window notify_level $*;};
alias wskip window skip toggle;
alias windent window indent toggle;
alias indent {set indent $*;};
alias wswap window swappable toggle;
alias wfix window fixed toggle;
alias wlast {window lastlog $*;};
alias whold window hold_mode toggle;

## window toggle simplification.
:{
/*
	Copyright (c) 2003 David B. Kratter (BlackJac@EFNet)
	This will allow you to toggle between hidden windows 1 through 20 more
	easily. Press Esc+1 to toggle between windows 1 and 11, Esc+2 for win-
	dows 2 and 12, etc., up through Esc+0 for windows 10 and 20.

	Simplifications by kreca
*/
};

alias toggle.window (number, void) {
	if (@number) {
		@number= number ? number : 10;
		@ :wn = winnum() == number ? number+10 : number;
		if (winnum($wn) != -1) {
			^window swap $wn;
		} else {
			if ( wn <= 10 && winnum(${wn+10}) != -1) {
				^window swap ${wn+10};
			} else if (wn > 10 && winnum($number) != -1) {
				^window swap $number;
			};
		};
	};
};

on #-window_create 123 "*" {
	if ( windowdoubles == 'on' ) {
		window $0 double on;
	};
};

#bind meta-0 to meta-9 to toggle.window
fe ($jot(0 9 1)) tt {
	bind ^[$tt parse_command toggle.window $tt;
};

# alias /0 - /25 to swap to that window (/10 is nonexistent by purpose,
# use /0 instead)
fe ($jot(1 25 1)) tt {
	@:t2= tt != 10 ? tt : 0;
	alias $t2 ^window swap $tt;
};
