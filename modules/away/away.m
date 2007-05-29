# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
subpackage away
eval osetitem away awaytime A-setaway time:;
eval osetitem away awaytog A-setaway on/off:;
eval osetitem away awaymsg A-msg:;
eval osetitem away awaylogmsg A-log msgs:;
eval osetitem away awaylogcrap A-log crap/miscs:;
eval osetitem away awaylognotice A-log notices:;
eval osetitem away awaylogdcc A-log dcc:;
eval osetitem away awaylogpub A-log public:;


#awaystat is per default 0. Without this awaystat will be undefined.
@awaystat=0
@awaysavefile=word(0 $_modsinfo.away.savefiles)
alias awayhelp {
	//echo ----------------------= Away Help =---------------------------
	//echo $cparse("%Wu%nsage%K:%n /remlog         Remove away log")
	//echo $cparse("%Wu%nsage%K:%n /readlog        Read away log")
	//echo $cparse("%Wu%nsage%K:%n /away <reason>  Enter away mode with <reason>")
	//echo $cparse("%Wu%nsage%K:%n /back           Exit away mode")
	//echo $cparse("%Wu%nsage%K:%n /config away    Set away settings")
	//echo $cparse("Away log saved in $(savepath)$awaysavefile")
	//echo ---------------------------------------------------------------
}
alias remlog  {
	if (fexist($(savepath)$awaysavefile) == -1) {
		xecho $acban log file does not exist.
	}{
		input "remove log? [y|n]: " {
			if ([$0]==[y]) {
				exec rm $(savepath)$awaysavefile
					xecho $acban $(savepath)away.log deleted
			}{
				xecho $acban remlog canceled
			}
		}
	}
}

alias readlog {
	decodemore $(savepath)$awaysavefile
}

on -idle * if ([$0]!= 0) { 
	if ([$0]== awayt && awaystat != 1 && togaway != [OFF]) {
		away autoaway after $0 mins
		xecho $acban Auto-Away after $0 minutes
	}
}


^on #-msg 332 * {
	if (awaystat && matchitem(awaymsgs $0) < 0) {
		@setitem(awaymsgs $numitems(awaymsgs) $0)
	}
}

on #-connect 1 * if (awaystat) {
	//away $awaymsg
}

alias away {
	@awayl=[on]
	@awaystat=1                       
	@awaytime=()
	@awaymsg=[$0]?[$*]:awayr
	//away away: \($(awaymsg)\) $fparse(format_away)
	@awaytime=time()
}

alias back {
	if ([$A]) {
		@awayl=[off]
		@awaystat=0
		@delarray(awaymsgs)
		@backtime=time()
		if (awaytime > [0]) {
			@timediff=tdiff2(${backtime - awaytime})
			//away
			if (fexist($(savepath)$awaysavefile)!=-1) {
				xecho -v $acban type /readlog to view log.
			}
		}

	}{
		xecho -v $acban you are not away..
	}
}

#configs
alias config.awaytime {
	if ( [$0] == [-r] )
	{
		return $awayt
	} else if ([$0] == [-s]) {
		if (# >1) {
			@ awayt = [$1]
		}
		xecho -v $acban away time set to "$awayt"
	}
}

alias config.awaymsg {
	if ( [$0] == [-r] )
	{
		return $awayr
	} else if ([$0] == [-s]) {
		if (# >1) {
			@ awayr = [$1-]
		}
		xecho -v $acban away reason set to "$awayr"
	}
}

alias config.awaytog {
	if ( [$0] == [-r] )
	{
		return $togaway
	} else if ([$0] == [-s]) {
		config.matchinput on|off togaway '$1' away toggle
	}
}

alias config.awaylogcrap {
	if ( [$0] == [-r] )
	{
		return $crapl
	} else if ([$0] == [-s]) {
		config.matchinput on|off crapl '$1' misc crap logging
	}
}

alias config.awaylogmsg {
	if ( [$0] == [-r] )
	{
		return $msgl
	} else if ([$0] == [-s]) {
		config.matchinput on|off msgl '$1' msg logging
	}
}

alias config.awaylogdcc {
	if ( [$0] == [-r] )
	{
		return $dccl
	} else if ([$0] == [-s]) {
		config.matchinput on|off dccl '$1' dcc logging
	}
}

alias config.awaylognotice {
	if ( [$0] == [-r] )
	{
		return $notl
	} else if ([$0] == [-s]) {
		config.matchinput on|off notl '$1' notice logging
	}
}

alias config.awaylogpub {
	if ( [$0] == [-r] )
	{
		return $plog
	} else if ([$0] == [-s]) {
		config.matchinput on|off plog '$1' public logging
	}
}

## Wrappers
alias awaytime {
	config.awaytime -s $*
}

alias awaymsg {
	config.awaymsg -s $*
}

alias awaytog {
	config.awaytog -s $*
}

alias logcrap {
	config.awaylogcrap -s $*
}            

alias logm {
	config.awaylogmsg -s $*
}            

alias logd {
	config.awaylogdcc -s $*
}            

alias logn {
	config.awaylognotice -s $*
}            

alias logpub {
	config.awaylogpub -s $*
}            

## cmd line aliases.
alias mlog logm $*
alias clog logcrap $*
alias nlog logn $*
alias dlog logd $*
alias playback readlog
alias atog awaytog $*
alias awayt awaytime $*
alias awayr awaymsg $*

## away hook func
alias _awaylog {
	@fd = open($(savepath)$awaysavefile W)
	@write($fd $encode($0 $strftime(%x at %I:%M:%S %p) $1-))
	@close($fd)
}
## logging hooks
on #-ctcp 2 "*" if (crapl ==[ON] && awaystat && awayl ==[ON]) {
	^_awaylog CTCP $0 \($userhost()\) requested $2 $3- from $1
}
on #-msg 4 "*" if (msgl ==[ON] && awaystat && awayl ==[ON]) {
	^_awaylog MSG $0 \($userhost()\) $1-
}
on #-notice 3 "*" if (notl==[ON]&&awaystat&&awayl==[ON]&&match(*[*#*]* $1-)==[0]) {
	^_awaylog NOTICE $0 \($userhost()\) $1-
}

on #-notice 4 "*[*#*]*" if (crapl==[ON]&&awaystat&&awayl==[ON]) { 
	^_awaylog WALL $*
}

on #-dcc_request 6 "*" if (dccl ==[ON] && awaystat && awayl ==[ON]) {
	^_awaylog DCC dcc $1 request from $0 \($userhost()\))
}

on #-dcc_chat 4 "*" if (dccl ==[ON] && awaystat && awayl ==[ON]) {
	^_awaylog DCC_MSG $*
}

on #-public_other 4 * if (awayl==[ON]&&awaystat&&match(*$N* $2-)&&plog==[ON]) {
	^_awaylog PUBLIC <$0:$1> $2-
}

on #-public 5 * if (awayl==[ON]&&awaystat&&match(*$N* $2-)&&plog==[ON]) {
	^_awaylog PUBLIC <$0:$1> $2-
}

on #-kick 33 '$N' {
	if (awayl==[ON]&&awaystat&&crapl==[ON]) {
		^_awaylog KICK $1 kicked you off $2 for reason $3-
	}
}

##away decode func
alias decodemore
{
	if ([$0]) 
	{
		@ line = 0
		@ done = 0
		@ rows = winsize() - 1
		if (fexist($0) == 1) 
		{
			@ fd = open($0 R)
			while (!eof($fd) && (pause!=[q])) 
			{
				while (line++ != rows) 
				{
					@ ugh = decode($read($fd))
					if (eof($fd)) 
					{
						@ line = rows
						@ done = 1
					}
					{
						xecho $ugh
					}
				}
				if (!done) 
				{
		^assign pause $"Enter q to quit, or anything else to continue "
		@ line = 0
				}
			}
			@ close($fd)
			@ fd = line = done = rows = pause = ugh = []
		}
		{
			xecho -b $0\: no such file.
		}
	}
}
#archon'96

