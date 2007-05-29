# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# based on void/codelogic's autobot 98
# modded by crapple 05
# taken from epic dist scripts dir
subpackage userlist

@frsavefile=word(0 $_modsinfo.userlist.savefiles)

## ugly pad hack.
alias _pad {
       @ function_return = [$1-$repeat(${[$0] - _printlen($1-)})]
}

# /purge <structure name>
# removes all assignments under that name recursively.
alias purge {
  foreach $0 ii
  {
    purge $0.$ii
  }
  ^assign -ii
  ^assign -$0
}
alias clean foreach $0 ii { ^assign -$0[$ii] }

## misc various compat aliases.
alias listuser userlist
alias deluser userdel $*
alias addf adduser $*
alias listf userlist   
alias delf userdel $*   
alias remf userdel $*
alias unuser userdel $*
alias adelay setsec $*
## end compat.

alias adduser {
	if (![$1]) {
		//echo ------------------------------------------------------------------
		//echo syntax: /adduser [nick|ident@host] #channel userlevel1,userlevel2,
		//echo userlevel3 ... password 
		//echo valid userlevels are ops iops invite voice deop
		//echo ------------------------------------------------------------------
	}{
		@ :input1 = [$0]
		^assign -friendhost
		if (ismask($input1)) {
			@ friendhost = input1
		} else { 
			if (!getuhost($input1)) { 
				//echo $banner $input1 is not on irc! 
			}{
				@ friendhost = sar(g/~/\*/$getuhost($input1))
				@ friendnick = [$input1]
			}
		}
		if (friendhost) {
			@ :fchan = [$1]
			@ :pass = [$encode($3)]
			@ :flags = [$2]
			@ setitem(friends 0 !)
			@ setitem(friends $numitems(friends) $friendhost $fchan $flags $pass)
			banner.lchead
			banner.mid added $friendhost $fchan $flags $decode($pass)
			banner.lcfoot
		}
	}
}

alias userlist {
	if (numitems(friends)<2) { 
		banner.lchead
		banner.mid the userlist is empty! 
		banner.lcfoot
		} {
        banner.lchead
	xecho [num] [$_pad(29 userhost)] [$_pad(2 channel)] [flags]

	for (@xx=1, xx<numitems(friends), @xx++)
        {
		@ :chan = word(1 $getitem(friends $xx)) 
       		@ :uhost = word(0 $getitem(friends $xx))
	        @ :pass = word(3 $getitem(friends $xx))
		@ :flags = word(2 $getitem(friends $xx))
	
		xecho [$[3]xx] $[40]uhost $[11]chan $flags
	}	
		banner.lcfoot
	}
}


alias usersave {
	@ rename(${savepath}$frsavefile ${savepath}$frsavefile~)
	@ savec = open(${savepath}$frsavefile W T)
	@ write($savec ** friends file - saved $strftime($time() %D %T))
	for (@xx=0, xx<numitems(friends), @xx++) {
		@ write($savec @friends.$xx=[$getitem(friends $xx)])
	}
	@ close($savec)
	xecho $acban [mod] (userlist).. saved to ${savepath}$frsavefile
}

alias userdel if ([$0]) {
	if (numitems(friends)<=[$0]) {
		//echo $banner no such user! 
	}{ 
		xecho $acban deleted userlist entry $getitem(friends $0)
		@ delitem(friends $0)
	}
}{
	//echo $banner usage: /deluser <user number>
}

alias userload	{
	^eval load ${savepath}$frsavefile
	@ delarray(friends)
	@ setitem(friends 0 !)
	@ ii = 1
    	while (friends[$ii]) {
        @ setitem(friends $ii $friends[$ii])
        @ ii++
        }
}

alias config.aopdelay {
	if ( [$0] == [-r] ) {
		return $_ss
	} else if ([$0] == [-s]) {
		if ([$1] > 0 && [$1] <=40) {
			@_ss=[$1]
		} else if (# > 1) {
			xecho -v $acban time out of range. Valid numbers are 1-40
		}
		xecho -v $acban auto op delay set to "$_ss"
	}
}

alias setsec {
	config.aopdelay -s $*
}

on #-join 34 * {
	if (N != [$0]) {
		^local ojchan $1
		^local ojblah1 $getmatches(friends *$ojchan* iops*)
		^local ojblah2 $getmatches(friends % \\* *iops *)
		fe ($ojblah1 $ojblah2) ii {
			@ojhost[$ii] = getitem(friends $ii)
		}
		foreach ojhost xx {
			if (rmatch($userhost($0) $word(0 $ojhost[$xx])) > 0) {
				^local ojtemp1 $ojhost[$xx]
				^clean ojhost
			}
		}
		^local ojtemp2 $word(0 $ojtemp1)
		^local ojtemp4 $sar(g/,/ /$word(2 $ojtemp1))
		if (match(iops $ojtemp4) > 0) {
			@ojtemp3 = word(1 $ojtemp1)
			if (ischanop($N $1) && match($ojtemp3 $1) > 0 && match($ojtemp2 $userhost($0)) > 0) {
				^local _opdelay $rand($_ss)
				aecho $acban Userlist matched hostmask: $sar(g/@/%K@%n/$ojtemp2) has joined $1
				aecho $acban Auto-oping if not oped in $_opdelay seconds.
				^timer $_opdelay {
					if (!ischanop($0 $1)) {
						^mode $1 +o $0;^timer -delete 451;^timer -refnum 451 5 {^assign -ojtemp3}
					}
				}			
			}
		}
	}
}

^on #-join 23 * {
	if (N != [$0]) {
		^local avchan $1
		^local avblah1 $getmatches(friends *$avchan* voice *)
		^local avblah2 $getmatches(friends % \\* *voice *)
  		fe ($avblah1 $avblah2) ii {
			@avhost[$ii] = getitem(friends $ii)
		}
		foreach avhost xx {
			if (rmatch($userhost($0) $word(0 $avhost[$xx])) > 0) {
				^local avtemp1 $avhost[$xx]
			}	
		}
		^local avtemp2 $word(0 $avtemp1)
		^local avtemp3 $word(1 $avtemp1)
		^local avtemp4 $sar(g/,/ /$word(2 $avtemp1))
		if (ischanop($N $avchan) && match($avtemp3 $avchan) > 0 && match(voice $avtemp4) > 0 && match($avtemp2 $userhost($0)) > 0) {
			aecho $acban Userlist matched hostmask: $sar(g/@/%K@%n/$avtemp2) voicing user on $1
			^mode $avtemp3 +v $0;clean avhost
		}
	}	
}


^on #-ctcp 43 "% % INVITE*" {
	^local ichan $3
	^local ipass $4
	^userhost $0 -cmd {
		if ([$3@$4] != [<UNKNOWN>@<UNKNOWN>]) {
			^local invhost $3@$4
			^local iblah1 $getmatches(friends *$ichan* *)
			^local iblah2 $getmatches(friends % \\* *)
			fe ($iblah1 $iblah2) ii {
				@ihost[$ii] = getitem(friends $ii)
			}
			foreach ihost xx {
				if (rmatch($invhost $word(0 $ihost[$xx])) > 0) {
					^local itemp1 $ihost[$xx]
				}
			}
			^local itemp2 $word(0 $itemp1)
			^local itemp3 $word(1 $itemp1)
			^local itemp4 $sar(g/,/ /$word(2 $itemp1))
			^local itemp5 $decode($word(3 $itemp1))
			if (ischanop($N $ichan) && match($itemp3 $ichan) > 0 && match(invite $itemp4) > 0 && ipass == itemp5 && match($itemp2 $invhost) > 0) {
				aecho $acban $0!$invhost matches userlist, inviting him to $vchan
				^notice $0 inviting you to $ichan 
				^invite $0 $itemp3;clean ihost
			}{
				^notice $0 [a+c] bad password or channel or you are not on my userlist 
			}	
			
		}
	}
}

^on #-ctcp 43 "% % OP*" {
	^local ochan $3
	^local opass $4
	^userhost $0 -cmd {
        	if ([$3@$4] != [<UNKNOWN>@<UNKNOWN>]) {
			^local ophost $3@$4
			@ oblah1 = getmatches(friends *$ochan* *ops*)
			@ oblah2 = getmatches(friends % \\* *ops*)
			fe ($oblah1 $oblah2) ii {
				@ohost[$ii] = getitem(friends $ii)
			}
                	foreach ohost xx {
                		if (rmatch($ophost $word(0 $ohost[$xx])) > 0) {
					^local otemp1 $ohost[$xx]
				}
			}
			^local otemp2 $word(0 $otemp1)
			^local otemp3 $word(1 $otemp1)
			^local otemp4 $sar(g/,/ /$word(2 $otemp1))
			^local otemp5 $decode($word(3 $otemp1))
			if (ischanop($N $ochan) && match($otemp3 $ochan) > 0 && match(ops $otemp4) > 0 && opass == otemp5 && rmatch($ophost $otemp2) > 0) {
				abecho  $0!$ophost matches userlist, oping on $ochan
				^mode $otemp3 +o $0;clean ohost
			}{
				^notice $0 [a+c] bad password or channel or you are not on my userlist
			}
		}
	}
}

^on #-ctcp 43 "% % VOICE*" {
	^local vchan $3
	^local vpass $4
	^userhost $0 -cmd {
		if ([$3@$4] != [<UNKNOWN>@<UNKNOWN>]) {
			^local vphost $3@$4
			^local vblah1 $getmatches(friends *$vchan* voice*)
			^local vblah2 $getmatches(friends % \\* *voice*)
			fe ($vblah1 $vblah2) ii {
				@vhost[$ii] = getitem(friends $ii)
			}
                	foreach vhost xx {
                		if (rmatch($vphost $word(0 $vhost[$xx])) > 0) {
					^local vtemp1 $vhost[$xx]
				}
			}
			^local vtemp2 $word(0 $vtemp1)
			^local vtemp3 $word(1 $vtemp1)
			^local vtemp4 $sar(g/,/ /$word(2 $vtemp1))
			^local vtemp5 $decode($word(3 $vtemp1))
			if (ischanop($N $vchan) && match($vtemp3 $vchan) > 0 && match(voice $vtemp4) > 0 && vpass == vtemp5 && rmatch($vphost $vtemp2) > 0) {
				aecho $acban $0%K!%n$vphost matches userlist, voicing on $vchan
				^mode $vtemp3 +v $0;clean vhost
			}{
				^notice $0 [a+c] bad password or channel or you are not on my userlist 
			}
		}
	}
}

^on #-mode_stripped 3 "% % -o %" {
	if (N != [$0]) {
		^local odeopnick $0
		^local deopchan $1
		^local deopnick $3
		^local deophost $userhost($3)
		^local deopmatch1 $getmatches(friends *$deopchan* ops*)
		^local deopmatch2 $getmatches(friends % \\* *ops*)
		fe ($deopmatch1 $deopmatch2) ii {
			@deopline[$ii] = [$getitem(friends $ii)]
		}
		foreach deopline xx {
			if (rmatch($deophost $word(0 $deopline[$xx])) > 0) {
				^local deoptemp1 $deopline[$xx] 
			}
		}
		^local deoptemp2 $word(0 $deoptemp1)
		^local deoptemp3 $word(1 $deoptemp1)
		^local deoptemp4 $sar(g/,/ /$word(2 $deoptemp1))
		if (ischanop($N $deoptemp3) && deoptemp3 == deopchan && match(deop $deoptemp4) > 0 && rmatch($deophost $deoptemp2) > 0) {
			aecho $acban $deopnick%K!%n$deophost matches userlist, deoping $odeopnick on $deopchan
			^mode $deoptemp3 -o $odeopnick
			^mode $deoptemp3 +o $deopnick;clean deopline
			^notice $odeopnick deoped protected user $deopnick on $deoptemp3
		}
	}
}

^on #-mode_stripped 3 "% % +b %" {
	if (N != [$0]) {
		^local _obannick $0
		^local _banchan $1
		^local _banuhost $after(! $3)
		^local _banmatch1 $getmatches(friends *$_banchan*)
		^local _banmatch2 $getmatches(friends % \\* *)
		fe ($_banmatch1 $_banmatch2) ii {
			@_banline[$ii] = [$getitem(friends $ii)]
		}
		foreach _banline xx {
			if (comatch($_banuhost $word(0 $_banline[$xx])) > 0) {
				^local _bantemp1 $_banline[$xx] 
                	}
            	}
		^local _bantemp2 $word(0 $_bantemp1)
		^local _bantemp3 $word(1 $_bantemp1)
		^local _bantemp4 $sar(g/,/ /$word(2 $_bantemp1))
		if (ischanop($N $_bantemp3) && match($_banchan $_bantemp3) > 0 && match(unban $_bantemp4) > 0 && comatch($_bantemp2 $_banuhost)) {
			aecho $acban %K[%na+c%K]%n $_banuhost%K!%n$_banhost matches userlist, unbanning $_banuhost on $_banchan
			^mode $_bantemp3 -b $3
			^mode $_bantemp3 -o $_obannick;clean _banline
			^notice $_obannick banned protected usermask $3 on $_bantemp3
		}
	}
}

alias userhelp uhelp
alias uhelp {
//echo -----------------------= Userlist Help =--------------------------
 
//echo userlist /userlist will display users from the userlist.
//echo adduser  /adduser [nick|ident@host] #channel userlevel1,userlevel2,
//echo userlevel3 .. password.
//echo userlevels ops - will op person requesting for ops ,iops - will
//echo instantly op someone when they enter the channel, invite - upon ctcp
//echo request, will invite user to channel, voice - will voice person when
//echo enters the channel
//echo listuser /listuser will display users from the userlist.
//echo deluser  /deluser # will delete the user from the userlist.
//echo addf     /addf same as /adduser
//echo listf    /listf same as /userlist
//echo delf     /delf same as /deluser
//echo remf     /remf same as /deluser

//echo -------------------------------------------------------------------
}
