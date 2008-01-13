# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
subpackage shitlist

alias listshit shitlist
alias listbk shitlist
alias addbk addshit $*
alias rembk shitdel $*
alias delshit shitdel $*

@shitsavefile=word(0 $_modsinfo.shitlist.savefiles)

alias fuck {
	if (![$0]) {
		xecho $acban /fuck nick <reason> [kickbans person and adds them to your shitlist with level 3]
	}{
		if (![$1]) {
			^bankick $0 shitted
				^addshit $0 $C 3 shitted
		}{
			^bankick $0 $1-
            	^addshit $0 $C 3 $1-
        }                                       
	}
}

alias addshit {
	if (![$3]) {
		xecho $acban syntax: /addshit [nick!ident@host] #chan1,#chan2,#chan3... level reason
		xecho $acban valid shitlist levels are 1 - deop users at all time
		xecho $acban                           2 - kick user when they join the channel
		xecho $acban                           3 - Ban/Kick user when they join the channel
	}{
	@ :input1 = [$0]		
		if (ismask($input1)) {
		@ shithost = input1
		}{ 
			if (!getuhost($input1)) { 
				//echo $banner $input1 is not on irc! 
			}{
				@ shithost1 = sar(g/~/\*/$getuhost($input1))
				@ shitnick = [$input1]
				@ shithost = [$(shitnick)!$(shithost1)]
			}		
		}
			if (shithost) {
			@ :schan = [$1]
			@ :slevel = [$2]
			@ :sreason = [$3-]
			@ setitem(shitlist 0 !)
			@ setitem(shitlist $numitems(shitlist) $shithost $schan $slevel)
			@ setitem(shitreas $numitems(shitreas) $sreason)
				//echo $banner added $shithost $schan $slevel $sreason
					if (slevel == 3) {
						fe ($chanusers($schan)) n1 {
							if (rmatch($n1!$userhost($n1) $shithost) > 0) {
					 			^mode $schan -o+b $n1 $mask(3 $n1!$userhost($n1))
                               		^kick $schan $n1 $sreason  
							}
						}
					}
		}
	}
}

alias shitlist {
	if (numitems(shitlist)<2) { 
		//echo $banner the shitlist is empty! 
	}{
	xecho [num] [shithost            ] [shitchan            [lev] [reason              ]
    	for (@xx=1, xx<numitems(shitlist), @xx++) {
		@:schan = word(1 $getitem(shitlist $xx)) 
       	@:shithost = word(0 $getitem(shitlist $xx))
	    @:sreason = getitem(shitreas $xx)
		@ :slevel = word(2 $getitem(shitlist $xx))
			xecho [$xx]    $[20]shithost   $[19]schan   $[4]slevel $sreason
		}
	
	}
}

alias shitsave {
	@ rename(${savepath}$shitsavefile ${savepath}$shitsavefile~)
	@ savec = open(${savepath}$shitsavefile W T)
	@ write($savec ** shitlist file - saved $strftime($time() %D %T))
	for (@xx=0, xx<numitems(shitlist), @xx++) {
		@ write($savec @shitlist.$xx=[$getitem(shitlist $xx)])
		@write($savec @shitreas.$xx=[$getitem(shitreas $xx)])
	}
	@ close($savec)
	xecho $acban shitlist saved to ${savepath}$shitsavefile [mod]
}

alias unshit shitdel $*
alias shitdel if ([$0]) {
	if (numitems(shitlist)<=[$0]) {
		//echo $banner no such user! 
	}{ 
		xecho $acban deleted shitlist entry $getitem(shitlist $0)
		@ delitem(shitlist $0)
		@ delitem(shitreas $0)
	}	
}{
	//echo $banner usage: /shitdel <number>
}

alias shitload	{
	^eval load ${savepath}$shitsavefile
	@delarray(shitlist)
	@delarray(shitreas)
	@setitem(shitlist 0 !)
	@setitem(shitreas 0 !)
	@ii = 1
	while (shitlist[$ii]) {
	        @ setitem(shitlist $ii $shitlist[$ii])
		@ setitem(shitreas $ii $shitreas[$ii])
		@ ii++
	}
}

^on #-join 53 * {
		if (N != [$0]) {
		^local shittemp1
		^local shittemp2
		^local shittemp3
		^local shittemp4
		^local shittemp5
		@ shitchan = [$1]
	   	@ shitblah = getmatches(shitlist *$shitchan*)
  			fe ($shitblah) ii {
			@shithost[$ii] = getitem(shitlist $ii)
			@shitreas[$ii] = getitem(shitreas $ii)
			}
				foreach shithost xx {
					if (rmatch($0!$userhost($0) $word(0 $shithost[$xx])) > 0) {
					@shittemp1 = [$shithost[$xx]]
					@shittemp5 = [$shitreas[$xx]]
					}		
				}
					@shittemp2 = word(0 $shittemp1)
					@shittemp3 = word(2 $shittemp1)
					@shittemp4 = sar(g/,/ /$word(1 $shittemp1))
						if (rmatch($0!$userhost($0) $shittemp2) > 0 && shittemp3 == 2 && match($shitchan $shittemp4) && getmatches(shitlist *$shitchan*) !=[]) {
							^kick $shitchan $0 $shittemp5;clean shithost
						}	
							if (rmatch($0!$userhost($0) $shittemp2) > 0 && shittemp3 == 3 && match($shitchan $shittemp4) && getmatches(shitlist *$shitchan*) !=[]) {
							^mode $shitchan -o+b $0 $mask(3 $shittemp2)
							^kick $shitchan $0 $shittemp5;clean shithost		
							}
	
								if (rmatch($0!$userhost($0) $shittemp2) > 0 && shittemp3 == 4 && match($shitchan $shittemp4) && getmatches(shitlist *$shitchan*) !=[]) {
									^mode $shitchan -o+b $0 $mask(3 $shittemp2)
									^kick $shitchan $0 $shittemp5;clean shithost		
								}
	
	}
}

^on #-mode_stripped 53 "% % +o*" {
		^local shittemp2
		^local shittemp3
		^local shittemp4
		^local shittemp5
		@shitchan = [$1]
	    @shitblah = getmatches(shitlist *$shitchan*)
  			fe ($shitblah) ii {
			@shithost[$ii] = getitem(shitlist $ii)
			@shitreas[$ii] - getitem(shitreas $ii)
			}
				foreach shithost xx {
					if (rmatch($3!$userhost($3) $word(0 $shithost[$xx])) > 0) {
					@shittemp1 = [$shithost[$xx]]
					@shittemp5 = [$shitreas[$xx]]
					}			
				}
					@shittemp2 = word(0 $shittemp1)
					@shittemp3 = word(2 $shittemp1)
					@shittemp4 = sar(g/,/ /$word(1 $shittemp1))
						if (rmatch($3!$userhost($3) $shittemp2) > 0 && shittemp3 == 1 && match($shitchan $shittemp4) && getmatches(shitlist *$shitchan*) !=[]) {
							^mode $shitchan -o $3;clean shithost
						}
	
}

		

^on #-mode_stripped 673 "% % -b*" {
		^local shittemp2
		^local shittemp3
		^local shittemp4
		^local shittemp5
		@shitchan = [$1]
	    @shitblah = getmatches(shitlist *$shitchan*)
  			fe ($shitblah) ii {
			@shithost[$ii] = getitem(shitlist $ii)
			@shitreas[$ii] - getitem(shitreas $ii)
			}
		
				foreach shithost xx {
					if (rmatch($3 $word(0 $shithost[$xx])) > 0) {
					@shittemp1 = [$shithost[$xx]]
					@shittemp5 = [$shitreas[$xx]]
					}	
				}
					@shittemp2 = word(0 $shittemp1)
					@shittemp3 = word(2 $shittemp1)
					@shittemp4 = sar(g/,/ /$word(1 $shittemp1))
						if ([$3] == mask(3 $shittemp2) && shittemp3 == 4 && match($shitchan $shittemp4) && getmatches(shitlist *$shitchan*) !=[]) {
							^mode $shitchan +b $mask(3 $shittemp2);clean shithost
						}
	
}

alias shithelp shelp
alias shelp {
//echo -----------------------= Shitlist Help =--------------------------

//echo addshit /addshit [nick|ident@host] #chan1,#chan2,#chan3... level reason
//echo shitlevels 1 - deop users at all time, 2 - kick user when they
//echo join the channel, 3 - Ban/Kick user when they join the channel
//echo fuck /fuck nick will kickban nick and add nick to your shitlist level 3
//echo listshit /listshit view current users on the shitlist.
//echo delshit  /delshit # removes user from the shitlist.
//echo                   -= Shitlist Quick Alias =-
//echo listbk/listshit
//echo addbk/addshit
//echo rembk/delshit
                
//echo -------------------------------------------------------------------
}
