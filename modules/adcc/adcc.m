# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# TODO: convert to pf-loader
subpackage adcc
@dccsavefile=word(0 $_modsinfo.adcc.savefiles)

alias cdcc adcc
alias xdcc adcc
alias adcc {
	if (![$0]) {
		load $(loadpath)modules/adcc/adcc.ans
	}
		switch ($0) {
		(send) {
			adcc_send $1-
		}
		(offer) {
			adcc.offer
		}
		(doffer) {
			adcc.doffer
		}		
		(save) {
			adcc.save
		}
		(load) {
			adcc.load
		}
		(list) {
			adcc.list
		}
		(timer) {
			adcc.timer
		}
		(stats) {
			adcc.stats
		}
	}	

}

alias adcc.timer {
	if (numitems(offers.files) == 0) {
		xecho (adcc).. no packs offered
	}{
		input "which channel do you want the timer to plist in? <#chan1,#chan2...> " {
		@dcchans=[$0]
		}
		dcc.timer
	}
}	
alias dcc.timer {
	^timer -del 41
		input "time in minutes to plist on channel " {
			if ([$0] == 0 || ![$0]) {
				xecho (adcc).. timer canceled
			}{
				@pts=[$0]
	      			^timer -refnum 41 -rep -1 ${pts * 60} ^plist $dcchans
			}		
		}
}

alias adcc.list {
	if (numitems(offers.files)== 0) {
		xecho (adcc).. no packs current on list
    }{
		xecho -v -- ---------------------------------------------------------------
		xecho -v  |       file                           desc	                     gets
			for (@xx=0, xx<numitems(offers.files), @xx++) {
			@pgets = getitem(gets $xx)
				if (getitem(gets $xx) == []) {
				@pgets = 0
				}
					xecho -v  | $cparse(%K[%n${xx+1}%K]%n) $[27]getitem(offers.files $xx) $[37]getitem(offers.desc $xx) $[4]pgets
			}
        		xecho -v -- ---------------------------------------------------------------
	}
}

alias adcc_send {
	@dnick = sar(g/,/ /$0)
		fe ($dnick) n1 {
			dcc send $n1 $glob($1-)
		}	
	
}
		                
alias adcc.offer {
	@fuk=0
		input "file to offer: " {
			if (fexist($glob($*)) == [-1]) {
	
			@fuk=1
				xecho (adcc).. file not found
			}{ 
				if (match(*/* $*)) {	
				@setitem(gets $numitems(gets) 0)
				@setitem(offers.files $numitems(offers.files) $glob($*))
			}{
	   			@dcpath=[~/]
				@setitem(gets $numitems(gets) 0)
        		@setitem(offers.files $numitems(offers.files) $glob($(dcpath)$*))           
			}
				^suckme
			}
			}
	
}
	
alias suckme {	
	input "desc of pack: " {
	@setitem(offers.desc $numitems(offers.desc) $*)
	}
		input "note to add to pack: " {
		@setitem(offers.note $numitems(offers.note) $*)
		}

}

## fixsize taken from psykotyk's xdcc script
alias fixsize {^local _size
^stack push set floating_point_math
^set floating_point_math on
@ _size = [$0];if (!_size) {@ function_return = [0b]}
if (_size<1000) {@ function_return = trunc(3 ${_size / 1024}) ## [b]}
if (_size>=1000&&_size<1000000) {@ function_return = trunc(2 ${_size / 1024}) ## [kb]}
if (_size>=1000000) {@ function_return = trunc(2 ${_size / 1048576}) ## [mb]}
^stack pop set floating_point_math}


## end 
alias plist {
	if (numitems(offers.files) == 0) {
		xecho (adcc).. no packs being offered
	}{
		if (![$0]) {
		@pl=[$serverchan()]
		}{
		@pl=[$0]
		}

	
		msg $pl [amn/adcc] $numitems(offers.files) file(s) offered \; /ctcp $servernick() xdcc send #num  
			for (@xx=0,xx<numitems(offers.files),@xx++) {
			@pgets = getitem(gets $xx)
				if (getitem(gets $xx) == []) {
				@pgets = 0
				}
					msg $pl [#${xx+1} \($[7]fixsize($fsize($getitem(offers.files $xx)))) $pgets get(s) ] $getitem(offers.desc $xx)
		 				if (getitem(offers.note $xx)) {
							msg $pl        - $getitem(offers.note $xx)
						}
			}
				if (!getitem(total 0)) {
				@lch=[0kb]
				}{
				@lch=fixsize($getitem(total 0))
				}	
					if (!getitem(speed 0)) {
					@spd=[0]
					}{
					@spd=trunc(1 $getitem(speed 0))
					}
						msg $pl     [% leeched $lch / top speed $(spd)kbs %] 	
}		}


alias adcc.save {
        @ rename($(savepath)$dccsavefile $(savepath)$dccsavefile~)
        @ savec = open($(savepath)$dccsavefile W T)
        @ write($savec ** dcc save file - saved $strftime($time() %D %T))
       	for (@xx=0, xx<numitems(offers.files), @xx++) {
		@ write($savec @files.$xx=[$getitem(offers.files $xx)])
	}
	for (@xx=0, xx<numitems(offers.desc), @xx++) {
		@ write($savec @desc.$xx=[$getitem(offers.desc $xx)])
	}
	for (@xx=0, xx<numitems(offers.note), @xx++) {
		@ write($savec @note.$xx=[$getitem(offers.note $xx)])
	}
	for (@xx=0, xx<numitems(gets), @xx++) {
		@ write($savec @gets.$xx=[$getitem(gets $xx)])
	}
	@ write($savec @speed=[$getitem(speed 0)])
	@ write($savec @total=[$getitem(total 0)])
	@ close($savec)
	xecho [mod] (odcc).. adcc settings saved to $(savepath)$dccsavefile
}

alias adcc.load {
	^eval ^load $(savepath)$dccsavefile
	@ delarray(offers.files)
	@ delarray(offers.desc)
	@ delarray(offers.note)
	@ delarray(gets)
	@ delarray(total)
	@ delarray(speed)
	@ xx = 0
	@ yy = 0
	@ ii = 0
	@ zz = 0
	@setitem(total 0 $total)
	@setitem(speed 0 $speed)
	while (files[$ii]) {
	        @ setitem(offers.files $ii $files[$ii])
	        @files[$ii]=[]
		@ ii++
        }
       	while (desc[$xx]) {
                @ setitem(offers.desc $xx $desc[$xx])
                @ xx++
       	}
	while (note[$yy]) {
                @ setitem(offers.note $yy $note[$yy])
                @ yy++
	}
	while (gets[$zz]) {
               	@ setitem(gets $zz $gets[$zz])
               	@ zz++
	}
	xecho (adcc).. odcc file loaded 
}

alias adcc.doffer {
	input "which pack to delete, * for all: " {
		if ([$0] == [*]) {
		@delarray(offers.files)
		@delarray(offers.desc)
		@delarray(offers.note)
		@delarray(gets)
		@delarray(speed)
		@delarray(total)
			xecho (adcc).. all packs deleted
		}{
			@numer=[$0]
			@delitem(offers.files ${numer-1})
			@delitem(offers.desc ${numer-1})
			@delitem(offers.note ${numer-1})	
			@delitem(gets ${numer-1})
				xecho (adcc).. pack $numer deleted
		}
	} 
}

^on #-raw_irc 12 "% PRIVMSG % :?DCC list" {
	if (numitems(offers.files) == 0) {
    }{                                           
		^notice $before(! $0) [amn/adcc] $numitems(offers.files) file(s) offered \; /ctcp $servernick() xdcc send #num  
			for (@:xx=0,xx<numitems(offers.desc),@xx++) {
			@pgets = getitem(gets $xx)
				if (getitem(gets $xx) == []) {
				@pgets = 0
				}
					^notice $before(! $0)  [#${xx+1} \($[7]fixsize($fsize($getitem(offers.files $xx)))) $pgets get(s) ] $getitem(offers.desc $xx)
						if (getitem(offers.note $xx)) {
							^notice $before(! $0)       - $getitem(offers.note $xx)
						}
			}
				if (!getitem(total 0)) {
				@lch=[0kb]
				}{
				@lch=fixsize($getitem(total 0))
				}
					if (!getitem(speed 0)) {
					@spd=0
					}{
					@spd=trunc(1 $getitem(speed 0))
					}   
						^notice $before(! $0)     [% leeched $lch / top speed $(spd)kbs %] 

	}
}

^on #-raw_irc 12 "% PRIVMSG % :?DCC list" {
	if (numitems(offers.files) == 0) {
    }{                                           
		^notice $before(! $0) [amn/adcc] $numitems(offers.files) file(s) offered \; /ctcp $servernick() xdcc send #num  
			for (@:xx=0,xx<numitems(offers.desc),@xx++) {
			@pgets = getitem(gets $xx)
				if (getitem(gets $xx) == []) {
				@pgets = 0
				}
					^notice $before(! $0)  [#${xx+1} \($[7]fixsize($fsize($getitem(offers.files $xx)))) $pgets get(s) ] $getitem(offers.desc $xx)
						if (getitem(offers.note $xx)) {
							^notice $before(! $0)       - $getitem(offers.note $xx)
						}
			}
				if (!getitem(total 0)) {
				@lch=[0kb]
				}{
				@lch=fixsize($getitem(total 0))
				}
					if (!getitem(speed 0)) {
					@spd=0
					}{
					@spd=trunc(1 $getitem(speed 0))
					}   
						^notice $before(! $0)     [% leeched $lch / top speed $(spd)kbs %] 

	}
}


^on #-raw_irc 12 "% PRIVMSG % :ADCC send *" {
	if (numitems(offers.files) == 0) {
	}{
 		if (match(*#* $5) == 1) {
  		@filnum=[$after(# $5)]   
  			^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  		}
  			if (match(*#* $5) == 0) {
  			@filnum=[$5]
  				^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  			}

	}	
}

^on #-raw_irc 12 "% PRIVMSG % :ADCC send *" {
	if (numitems(offers.files) == 0) {
	}{
 		if (match(*#* $5) == 1) {
  		@filnum=[$after(# $5)]   
  			^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  		}
  			if (match(*#* $5) == 0) {
  			@filnum=[$5]
  				^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  			}

	}
}

^on #-raw_irc 12 "% PRIVMSG % :XDCC send *" {
	if (numitems(offers.files) == 0) {
	}{
		if (match(*#* $5) == 1) {
		@filnum=[$after(# $5)]
			^dcc send $before(! $0) $getitem(offers.files ${filnum -1}) 
		}
			if (match(*#* $5) == 0) {
			@filnum=[$5]
				^dcc send $before(! $0) $getitem(offers.files ${filnum -1})		
			}
	}
}
^on #-raw_irc 12 "% PRIVMSG % :XDCC send *" {
	if (numitems(offers.files) == 0) {
	}{
  		if (match(*#* $5) == 1) {
  		@filnum=[$after(# $5)]
  			^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  		}                     
  			if (match(*#* $5) == 0) {
  			@filnum=[$5]          
  			^dcc send $before(! $0) $getitem(offers.files ${filnum -1})  
  			}


	}
}

^on #-raw_irc 12 "% PRIVMSG % :CDCC send *" {
	if (numitems(offers.files) == 0) {
	}{
		if (match(*#* $5) == 1) {
  		@filnum=[$after(# $5)]
  			^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  		}                     
  			if (match(*#* $5) == 0) {
  			@filnum=[$5]          
  				^dcc send $before(! $0) $getitem(offers.files ${filnum -1})  
  			}
	}
}

^on #-raw_irc 12 "% PRIVMSG % :CDCC send *" {
	if (numitems(offers.files) == 0) {
	}{
		if (match(*#* $5) == 1) {
  		@filnum=[$after(# $5)]
  			^dcc send $before(! $0) $getitem(offers.files ${filnum -1})
  		}		                     
  			if (match(*#* $5) == 0) {
 			@filnum=[$5]          
  				^dcc send $before(! $0) $getitem(offers.files ${filnum -1})  
  			}
	}
}
^on #-dcc_lost 43 "% SEND % % TRANSFER COMPLETE" {
	if (rmatchitem(offers.files $2) >= 0) {
	@setitem(gets $rmatchitem(offers.files $2) ${getitem(gets $rmatchitem(offers.files $2)) + 1})	
	@setitem(total 0 ${fsize($2) + getitem(total 0)})	
		if (getitem(speed 0) < [$3]) {
		@setitem(speed 0 $3)
		}

	}	
}

^on ^dcc_list "*" {
	if ([$0] == [start]) { 
		xecho   $cparse($(c1)ÚÄÄÄÄÄÄÄÄÄÄÄ)$(hblk)----$cparse($(c1)ÄÄÄÄÄÄÄÄ)$(hblk)-$cparse($(c1)ÄÄ)$(hblk)-$cparse($(c1)ÄÄÄÄÄÄ-)$(hblk)ÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ        Ä
		xecho  $(hblk)[$cparse($(c1)³)$(hblk)]$(cl) type     nick       size   kbs        percent           file 
	}
	if ([$0] != [start] && [$0] != [end] && [$0] != [CHAT])	{
	@vary=[$5]
	@varx=[$6]
		xecho  $(hblk)[$cparse($(c1)³)$(hblk)]$(cl) $[4]0     $[9]2  $[5]fixsize($5)  $fixsize(${[$6]/(time()-[$4])})    $fixmeter($before(. ${(varx/vary)*100})) $(hblk)[$(cl)$before(. ${(varx/vary)*100})$(cl)%$(hblk)]$(cl) $7
	}
	if ([$0] != [start] && [$0] != [end] && [$0] == [CHAT])	{
		xecho  $(hblk)[$cparse($(c1)³)$(hblk)]$(cl) $[4]0     $[9]2  
	}

	if ([$0] == [end]) {
		xecho  $(hblk) À---Ä-Ä-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	}

}

alias fixmeter if (isdigit($0)) {
    @ fixp = [$0]
	@ hc1 = hcyn
		if (fixp < 10) {
			return $(hblk)±°°°°°°°°°°$(cl)
		}
			if ((fixp < 20)&& (fixp >= 10)) {
				return $(hblk)±²°°°°°°°°°$(cl)
			}
				if ((fixp < 30)&& (fixp >= 20)) {
					return $(hblk)±²Û°°°°°°°°$(cl)
				}
					if ((fixp < 40)&& (fixp >= 30)) {
						return $(hblk)±²Û$cparse($(c1)²)$(hblk)°°°°°°°$(cl)
					}
if ((fixp < 50)&& (fixp >= 40)) {return $(hblk)±²Û$cparse($(c1)²±)$(hblk)°°°°°°$(cl)}
if ((fixp < 60)&& (fixp >= 50)) {return $(hblk)±²Û$cparse($(c1)²±°)$(hblk)°°°°°$(cl)}
if ((fixp < 70)&& (fixp >= 60)) {return $(hblk)±²Û$cparse($(c1)²±°°)$(hblk)°°°°$(cl)}
if ((fixp < 80)&& (fixp >= 70)) {return $(hblk)±²Û$cparse($(c1)²±°°°)$(hblk)°°°$(cl)}
if ((fixp < 90)&& (fixp >= 80)) {return $(hblk)±²Û$cparse($(c1)²±°°°°)$(hblk)°°$(cl)}
if ((fixp < 100)&& (fixp >= 90)){return $(hblk)±²Û$cparse($(c1)²±°°°°°)$(hblk)°$(cl)} 
if (fixp == 100) {return $(hblk)±²Û$cparse($(c1)²±°°°°°)$(hblk)$(cl)}
}


alias adcc.stats {
	load $(loadpath)modules/adcc/astats.ans
}
