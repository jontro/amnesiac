# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

## compat/missing functions/things to make the script work well with epic5.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage compat;

## addset (original addset alias from BlackJac)
alias addset (name, type, args) {
	if (@name && type) {
		@ symbolctl(create $name);
		@ symbolctl(set $name 1 builtin_variable type $type);
		if (args) {
			@ symbolctl(set $name 1 builtin_variable script $args);
		};
	};	
};

alias delset (name, void) {
	if (@name) {
		@ symbolctl(delete $name builtin_variable);
		@ symbolctl(check $name);
	};
};
alias decode (...) {
	return $xform(-ENC $*);
};

alias encode (...) {
	return $xform(+ENC $*);
};

# The following functions were all pulled from the 'builtins' script
# written by David B. Kratter and distributed with EPIC5.
# Thanks BlackJac!

alias igmask (pattern, void) {
	return $ignorectl(pattern $pattern);
};

alias igtype (pattern, void) {
	fe ($ignorectl(get $ignorectl(refnum $pattern) levels)) ii {
		push function_return ${ii =~ '+*' ? "$rest(1 $ii)" : sar(#/##$sar(#^#DONT-#$ii))};
	};
};

alias servername (refnum default "$serverctl(from_server)", void) {
	if (:name = serverctl(get $refnum itsname)) {
		return $name;
	};
	return <none>;
};

alias servernick (refnum default "$serverctl(from_server)", void) {
	return $serverctl(get $refnum nickname);
};

alias servernum (refnum default "$serverctl(from_server)", void) {
	if ((:num = serverctl(refnum $refnum)) >= -1) {
		return $num;
	};
	return -1;
};

alias servertype (refnum default "$serverctl(from_server)", void) {
	return $serverctl(get $refnum protocol);
};

alias servports (refnum default "$serverctl(from_server)", void) {
	return $serverctl(get $refnum port) $serverctl(get $refnum localport);
};

alias winlevel (winnum default 0, void) {
	return $windowctl(get $windowctl(refnum $winnum) window_level);
};

alias winnicklist (winnum default 0, void) {
	return $windowctl(get $windowctl(refnum $winnum) nicklist);
};

alias winnum (winnum default 0, void) {
	if (:num = windowctl(get $windowctl(refnum $winnum) refnum)) {
		return $num;
	};
	return -1;
};

alias winrefs (void) {
	return $windowctl(refnums);
};

alias winserv (winnum default 0, void) {
	if ((:serv = windowctl(get $windowctl(refnum $winnum) server)) >= -2) {
		return $serv;
	};
	return -1;
};

alias myservers (arg, void) {
	fe ($serverctl(omatch *)) mm {
		if (serverctl(get $mm connected)) {
			push :servers $mm;
		};
	};
	fe ($servers) nn {
		push function_return ${@arg ? nn : servername($nn)};
	};
		
};

alias notifywindows (void) {
	fe ($windowctl(refnums)) nn {
		if (windowctl(get $nn notified)) {
			push function_return $nn;
		};
	};
};

alias lastserver (void) {
	return $serverctl(last_server);
};

alias winsize (winnum default 0, void) {
	return $windowctl(get $windowctl(refnum $winnum) display_size);
};

alias winstatsize (winnum default 0, void) {
	if ((:statsize = windowctl(get $windowctl(refnum $winnum) double)) > -1) {
		return ${statsize + 1};
	};
	return -1;
};

alias winvisible (winnum default 0, void) {
	if ((:visible = windowctl(get $windowctl(refnum $winnum) visible)) >= -1) {
		return $visible;
	};
	return -1;
};

## misc aliases/to go with functs that common people use.

^on #-kick 1 '$$servernick() *' {
	if (getset(auto_rejoin) == 'on') {
		if (:delay = getset(auto_rejoin_delay)) {
			timer -w $winnum() $delay join $2;
		} else {
			defer join $2;
		};
	};
};

## annoying client beep functionality requested by some taken from
## builtins src/epic5/scripts by BlackJac.
##      Copyright (c) 2005 David B. Kratter (BlackJac@EFNet)

# BEEP_ON_MSG
^on #-action 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(action $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-ctcp 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(ctcp $getset(beep_on_msg)) > -1) {
		beep;
	};
};


^on #-msg 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(msgs $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-notice 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(notices $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-oper_notice 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(opnotes $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-server_notice 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(snotes $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-wallop 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(wallops $getset(beep_on_msg)) > -1) {
		beep;
	};
};

^on #-who 1 "*" {
	if (getset(beep_on_msg) == 'all' || findw(crap $getset(beep_on_msg)) > -1) {
		beep;
	};
};
