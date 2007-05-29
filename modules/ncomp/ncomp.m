# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
subpackage ncomp

^on ^input "*" {  
	if (strlen($before(: $0)) > 1&&right(1 $0)==[:]) {
	@ txt = before(: $0)	
		if (pattern($txt* $chanusers($C))) {
        @ per = pattern($txt* $chanusers($C))
	  		if (numwords($per) > 1) {  
            	xecho $acban Ambiguous matches: $per
            		sendline $*
			}{
					sendline $stripansicodes($per$format_nick_comp $1-)
			}
		}	
					if (!pattern($txt* $chanusers($C)) && pattern(*$txt* $chanusers($C))) { 
        			@ per = pattern(*$txt* $chanusers($C))
						if (numwords($per) > 1) {
							xecho $acban Ambiguous matches: $per
								sendline $*
						}{ 
  							sendline $stripansicodes($per$format_nick_comp $1-)
          			}
	}
		if (!pattern($txt* $chanusers($C)) && !pattern(*$txt* $chanusers($C)))	{
			sendline $* 
        }
}{
	sendline $*
}
}
