# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# TODO: convert to pf-loader
subpackage oper

eval osetitem oper ovmode Operview modes:;
eval osetitem oper ovsize Operview win size:;
@ bindctl(sequence ^E set parse_command _spageu)
@ bindctl(sequence ^D set parse_command _spaged)

## opervision bindkey funcs scrollback/scrollup
alias _spageu {
	@:_cwin=winnum()
	window ref operview
	parsekey SCROLL_BACKWARD
	window ref $_cwin
}

alias _spaged {
	@:_cwin=winnum()
	window ref operview
	parsekey SCROLL_FORWARD
	window ref $_cwin
}

## compat funcs? //hack?
alias _winnames {
	fe ($winrefs()) n1 {
		if (match($0 $winnam($n1))) {
		return $n1
	}{
		return 0
		}
	}
}

## dynamic config funcs
alias config.ovsize {
	if ( [$0] == [-r] )
	{
		return $_ovsize
	} else if ([$0] == [-s]) {
		if (#>1) {
			@ _ovsize = [$1];
		}
		xecho -v $acban operview window size set to "$_ovsize"
	}
}

alias config.ovmode {
	if ( [$0] == [-r] )
	{
		return $_ovmode
	} else if ([$0] == [-s]) {
		if (#>1) {
			@ _ovmode = [$1];
		}
		xecho -v $acban oper modes set to "$_ovmode"
	}
}

alias ovsize {
	config.ovsize -s $*
}

alias ovmode {
	config.ovmode -s $*
}

alias omode {
	if ([$0]==[on]) {
		umode +sckf
	}
	if ([$0]==[off]) {
		umode -sckf
	}
}

## end config funcs

## gline funcs for Mikey(Alien88)
/on -server_notice "*requesting gline for*" {
	@glineTarget=strip([] [$11]);
	@glineReason=strip([] [$12-]);
}

alias gi {
	input "GLINE $glineTarget for '$glineReason'? (y/n) " {
		if ( [$0] == [y] ) /quote gline $glineTarget :$glineReason
	}
}

## operview func
alias ov operview
alias operview {
	if (winnum(operview) != -1) {
		abecho $banner toggled operview off.
		^window OperView kill
		^umode -$_ovmode
	}{
		abecho $banner toggled operview on.
		^window new double off fixed on size $_ovsize name OperView level snotes,opnotes,wallops;window indent on;umode +$_ovmode
		^set status_format [operview] %> [$servername($winserv(OperView))]
		^window back
	}
}

alias doper {
	umode -o 
}

alias operwall {
	quote operwall :$*
}

alias locops {
	quote locops :$*
}

alias tkline {
	if (![$0]) {
		xecho $acban usage: /tkline <minutes> [nick|hostmask] <reason>
	}{
		quote kline $0 $1 :$2-
	}
}

alias kline {
	if (match(*@* $0)) {
		quote kline $0 :$1-
	}{
		if (getuhost($0)) {
			quote kline $sar(g/*!*//$mask(3 $getuhost($0))) :$1-
		}{
			abecho $0 no such nick. 
		}
	}
}

alias unkline {
	quote unkline $*
}

alias kill {
	quote kill $0 :$1-
}

alias mkill {
	if (![$0]) {
		fe ($remw($N $chanusers($C))) n1 {
		quote kill $n1 :bye
		}
	}{
		fe ($remw($N $chanusers($C))) n1 {
		quote kill $n1 :$*
		}
	}
}

alias mkline {
	if (![$0]) {
	fe ($remw($N $chanusers($C))) n1 {
	kline $n1
	} 
    }{
	fe ($remw($N $chanusers($C))) n1 {
	kline $n1 $*
	}
    }
}

alias dwho {//who -dx $*}

alias gline {
	quote gline $0 :$1-
}

alias dline {
        quote dline $0 :$1-
}

alias zline {
	quote zline $0 :$1-
}

alias unzline {
	quote unzline $*
}

alias undline {
	quote undline $*
}

alias watch {
	quote watch $*
}

alias cjupe {
	quote mode $0 +j
}

alias ucjupe {
	quote mode $0 -j
}

alias modlist {
	quote modlist 
}

alias modload {
	quote modload $*
}

alias modunload {
	quote modunload $*
}

## Silence These servnotice per default for Alien88
## We should however make this toggable as im certain not all opers/admins
## prefer silencing this kind of behavior.
^on ^server_notice "*TRACE requested*" #
^on ^server_notice "*Too many clients*" #
^on ^server_notice "*farcans*nitedog*never*leaves*" #
^on ^server_notice "*locally juped channel*" #
^on ^server_notice "*drone flooder *dcc*" #
^on ^server_notice "*irc.stats.gatherer* being introduced*" #
^on ^server_notice "*irc.stats.gatherer* split from*" #      
^on ^server_notice "*stats.efnet.info* being introduced*" #
^on ^server_notice "*stats.efnet.info* split from*" #      
^on ^server_notice "*stats.blackened.com* being introduced*" #
^on ^server_notice "*stats.blackened.com* split from*" #      
^on ^server_notice "*Temporary K-line for*expired*" #      
^on ^server_notice "*I-line is full for*" #
^on ^server_notice "*john23*spambot*" #

## oper servnotice parses/hooks
^on ^server_notice "% % % % % % % % % /whois*" {
	aecho $fparse(format_timestamp_some $($_timess))[$9] on you requested by $4!$5)
}

^on ^server_notice * {
	aecho $fparse(format_timestamp_some $($_timess))$2-
}

^on ^server_notice "% % % % LINKS*" {
	aecho $fparse(format_timestamp_some $($_timess))[links $5] requested by $8!$9 $10
}

^on ^server_notice "% % % % STATS*" {
	aecho $fparse(format_timestamp_some $($_timess))[stats '$5'] requested by $8!$9) $10
}

^on ^server_notice "% % % % % % % % % (O)*" {
	aecho $fparse(format_timestamp_some $($_timess))$4!$5 is now a $8 $9
}

^on ^server_notice "% % % % % exiting:*" {
	aecho $fparse(format_timestamp_some $($_timess))Client exiting: $6!$7 $8-
}

^on ^server_notice "% % % % % connecting:*" {
	aecho $fparse(format_timestamp_some $($_timess))Client connecting: $6!$7 $8-
}

^on ^server_notice "% % % % % % rehashing*" {
	aecho $fparse(format_timestamp_some $($_timess))$4 is rehashing $7- 
}

^on ^server_notice "% % % % ADMIN*" {
	aecho $fparse(format_timestamp_some $($_timess))[Admin] requested by $7!$8 $9-
}

^on ^server_notice "% % % % % SQUIT*" {
	aecho $fparse(format_timestamp_some $($_timess))$4 $5 $6 from $8 $9-
}

^on ^server_notice "% % % % % was connected*" {
	aecho $fparse(format_timestamp_some $($_timess)) $4 $5 $6 $7 $8 $9 $10-
}

^on ^server_notice "% % % % Link with*" {
	aecho $fparse(format_timestamp_some $($_timess))Link $5 $6 $7-
}

^on ^server_notice "% % % % % % already present*" {
	aecho $4$fparse(format_timestamp_some $($_timess))$5 $6 $7 from $9
}

## elite format to determine diffs on kills in opervision
^on ^server_notice "* removed * ?-Line *" {
	switch ($8) {
		(K-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$8%n] $4 $5 $6 $7 %b$8%n $9 %R$10%n)
		}
		(G-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%g$8%n] $4 $5 $6 $7 %g$8%n $9 %R$10%n)
		}
		(D-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$8%n] $4 $5 $6 $7 %c$8%n $9 %R$10%n)
		}
		(X-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%p$8%n] $4 $5 $6 $7 %p$8%n $9 %R$10%n)
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%y$8%n] $4 $5 $6 $7 %y$8%n $9 %R$10%n)
		}
	}
}

^on ^server_notice "* added ?-Line for *" {
	switch ($6) {
		(K-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$6%n] $4 $5 %b$6%n $7 %R$8%n %m$9-%n)
		}
		(G-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%g$6%n] $4 $5 %g$6%n $7 %R$8%n %m$9-%n)
		}
		(D-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$6%n] $4 $5 %c$6%n $7 %R$8%n %m$9-%n)
		}
		(X-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%p$6%n] $4 $5 %p$6%n $7 %R$8%n %m$9-%n)
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%y$6%n] $4 $5 %y$6%n $7 %R$8%n %m$9-%n)
		}
	}
}

^on ^server_notice "* added temporary * ?-Line for *" {
	switch ($9) {
		(K-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$9%n] $4 $5 $6 %b$7 $8 $9%n $10 %R$11%n %m$12-%n)
		}
		(D-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$9%n] $4 $5 $6 %c$7 $8 $9%n $10 %R$11%n %m$12-%n)
		}
		(X-Line) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%p$9%n] $4 $5 $6 %p$7 $8 $9%n $10 %R$11%n %m$12-%n)
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([$y$9%n] $4 $5 $6 $y$7 $8 $9%n $10 %R$11%n %m$12-%n)
		}
	}
}

^on ^server_notice "* ?LINE active for *" {
	switch ($4) {
		(DLINE) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%c$4%n] $5 $6 %R$7%n $8-)
		}
		(KLINE) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%b$4%n] $5 $6 %R$7%n $8-)
		}
		(*) {
			xecho -b $fparse(format_timestamp_some $($_timess)) $cparse([%y$4%n] $5 $6 %R$7%n $8-)
		}
	}
}
## End elite kill formatting.

## cosmetic/silencing hooks for activated server numerics
^on ^382 * {
	aecho $1-
}

^on ^365 * {
	aecho $1 $2 of links list.
} 

^on ^243 * {
	aecho $1-
}

^on ^219 * #

## oper help menu
alias ohelp {
//echo -----------------------= Oper Help =--------------------------

//echo /tkline <minutes> [nick|ident@host] <reason> will temp kline for 
//echo specified minutes.
//echo /unkline <ident@host> will remove kline from server list.
//echo /operwall <text> will send a operwall with specified text to the server.
//echo /ov will open up a split window will the level WALLOPS OPNOTES SNOTES 
//echo so all server msgs will go to that window.
//echo /mkline <reason> will mass kline current channel for specified reason
//echo /mkill <reason> will mass kill current channel
//echo /locops <text> will send a msg to all operators on current server
//echo /kline <nick|ident@host> will set a kline for nick or specified ident@host
//echo /modlist view ircd modules.
//echo /modload <text> loads specified ircd module.
//echo /modunload <text> unloads specified ircd module.
//echo /dline <ip> reason.  will set a dline with reason. (ratbox)
//echo /undline <ip> will remove a dline. (ratbox)
//echo binds ^E scroll_backward in ovwin ^D scroll_forward in ovwin
                                       
//echo -------------------------------------------------------------------
}
