# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage alias;

## last modified by crapple 1.11.08
## various commands.
alias quit {bye $*;};
alias ismask {return ${@pass(!@ $0) ? 1 : 0}};
alias settings {config $*;};
alias date {time $*;};
alias serverchan {return $winchan($serverwin());};

## more/less info from server.
alias ww {whowas $*;};
alias wi {whois $*;};
alias w {whois $*;};
alias who {//who ${ @ ? (*) : T};};
alias links {quote links $*;};
alias wii {if ( ! @ ) {whois $servernick() $servernick()} {whois $0 $0;}};
alias smsg {quote server :$*;};

## cid(+g)
alias accept { quote accept $*;};
alias cid aclist;
alias rmcid { quote accept -$*;};
alias aclist { quote accept * ;};
alias clist aclist;
alias cdel {rmcid $*;};
alias termtitle (msg) {
      //xecho -r $chr(27)]2\;${msg}$chr(7)
};

# input allowed:
# /invite nick [#chan1 #chan2 #chan3]
# /invite [#chan] nick1 nick2 nick3
alias invite  {
	@:haschan=0;
	fe ($* ) cc {
		if (ischannel($cc)) {
			@:haschan=1;
		};

	};
	if (!@||(haschan==0&&!ischannel($serverchan()))) {
		xecho -b Usage: INVITE [#channel] nick1 nick2 nick3 ...;
		xecho -b Usage: INVITE nick #chan1 #chan2 #chan3 ...;
		return;
	};
# /invite [#chan] nick1 nick2 nick3
	if (ischannel($0)) {
		fe ($1-) nn {
			quote invite $nn $0;
		};
	} else if (haschan==0) {
		fe ($*) nn {
			quote invite $nn $serverchan();
		};
	} {
# /invite nick [#chan1 #chan2 #chan3]
		fe ($1-) cc {
			quote invite $0 $cc;
		};
	};
};

alias inv {invite $*;};

## chan/mem/nickserv/services/irritating ircd stuff
alias ms {quote MemoServ $*;};
alias ns {quote NickServ $*;};
alias cs {quote ChanServ $*;};
alias chanserv {cs $*;};
alias nickserv {ns $*;};
alias memoserv {ms $*;};
alias mserv {msg memoserv $*;};
alias nserv {msg nickserv $*;};
alias cserv {msg chanserv $*;};
alias allow {dccallow $*;};
alias dccallow {quote dccallow $*;};

## to be annoying like xavier.
alias blinky { if (@T)  msg $T $cparse("%F%G$*") ;};
## for xavier with love //zak
alias retard {echo Retard alert, pling pling pling; parsekey stop_irc; echo Retard alert, pling pling pling;};

## general user commands
alias umode {^mode $servernick() $*;};
alias m {msg $*;};
alias d {describe $*;};
alias desc {describe $*;};
alias j {/join $channame($0) $1-;};
alias p {if (@) { ping $*; }{ ping $serverchan() }; };
alias k {kick $*;};
alias l {part $*;};
alias host {//userhost $*;};
alias irchost {hostname $*;};
alias unset {set -$*;};
alias unalias {alias -$*;};
alias ll {lastlog $*;};
alias lll {lastlog -literal $*;};
alias llw {lastlog -window $*;};
alias llt {lastlog -target $*;};
alias llm {lastlog -mangle ALL $*;};
alias verk {massk $*;};
alias csc {clear;sc;}; 
alias a {ahelp $*;};
alias finger {ctcp $0 finger;};
alias about {more $(loadpath)ans/about.ans;};

## toggable aliases
alias arejoin {set auto_rejoin toggle;};
alias aww {set auto_whowas toggle;};
alias debug {set debug $*;};
alias lls {set lastlog $*;};
alias mon {set old_math_parser on;};
alias moff {set old_math_parser off;};
alias ioff {set -input_prompt;};
alias tog {toggle $*;};
alias ircname {set default_realname $*;};
alias realname {set default_realname $*;};
alias username {set default_username $*;};
alias clock24 {set clock_24hour toggle;};

## dumps and reload script, for scripters and adv users
alias adump {
	//dump all;
	fe ($getarrays()) n1 {@delarray($n1)};
	unload * fe;
	bind -defaults;
	load ~/.epicrc;
};

## CrazyEddie's alias
alias comatch return ${match($*)||rmatch($*)};
## end

alias _center {
	@ number = (word(0 $geom()) - printlen($*)) / 2;
	xecho -v $repeat($trunc(0 $number)  )$*;
};

## long complex aliases below here.
alias ibm437 fixterm;
alias fixterm {
	xecho -r $chr(27)\(U;
	parsekey REFRESH_SCREEN;
};

alias latin1 {
	xecho -r $chr(27)\(B;
	parsekey REFRESH_SCREEN;
};

alias cat {
	if (@) {
		@:ansifile = open($0 R T);
		while (!eof($ansifile)) {
			//echo $read($ansifile);
		};
		@close($ansifile);
	};
};

alias evalcat {
	if (@) {
		@:ansifile = open($0 R T);
		while (!eof($ansifile)) {
			eval //echo $read($ansifile);
		};
		@close($ansifile);
	};
};

alias getuhost {
	if (userhost($0)=='<UNKNOWN>@<UNKNOWN>') {
		wait for userhost $0 -cmd {
			if (*4 != '<UNKNOWN>')
				return $3@$4;
			return;
		};
	}{
		return $userhost($0);
	};
};

alias bye {
	if (@) {
		//quit $(J)[$info(i)] - $(a.ver) : $*;
	}{
		//quit $(J)[$info(i)] - $(a.ver) : $randread($(loadpath)reasons/quit.reasons);
	};
};

alias ping (target default "$T") {
	//ping $target;
};

alias part {
         if (@) {
                 switch ($0) {
                         (#*) (&*) (0) (-*) (!*) (+*) {
                                 //part $*;
                         };
                         (*) {
                                 //part $serverchan() $*;
                         };
                 };
         }{
                 //part $serverchan();
         };
};

alias toggle (cset,void) { 
	@:vars = '';
	fe ($symbolctl(PMATCH BUILTIN_VARIABLE $cset*)) symbol { 
		if (symbolctl(GET $symbol 1 BUILTIN_VARIABLE TYPE) == 'BOOL') {
			^push vars $symbol;
		};
	};
	if ( #vars == 0 ) 
		@:vars = cset;
	if ( #vars == 1 ) {
		//set $vars TOGGLE;
	} {
		fe ($vars) symbol {
			//set $symbol;
		};
	};
};

alias rn {
	@_rn='a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5';
        fe ($_rn) n1 {
                @setitem(_rn $numitems(_rn) $n1);
        };
	^nick $(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))))$(getitem(_rn $rand($numitems(_rn))));
};

alias ver (target default "$T"){
	if (@target)
		//ctcp $target version;
};

alias whowas (nick, number default "$num_of_whowas", void) {
	//whowas $nick $number;
};

## script echo //does this still needing cleaning??
alias abwecho {xecho -v $acban $cparse($*);};
alias aecho {//echo $cparse($*);};
alias abecho {xecho -b -- $cparse($*);};
alias ce {//echo $cparse("$*");};
