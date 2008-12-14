# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# TODO: convert to pf-loader
subpackage flood

osetitem protect msgflood Msgflood Sensor:;
osetitem protect msgftimer Msgflood Timer:;

## vars
@mfloodtimer=[10]
@msgfloodsensor=[60]

## hooks
^on #-msg 1 * if (msgflood != 1) {
	@msgs++ 
	//timer -refnum 5001 3 {@msgs = 0}
	if (msgs > msgfloodsensor) {
		/umode +g 
		xecho -b msg flood detected setting flood protect umode +g for $mfloodtimer seconds
		@msgflood=1
		//timer -refnum 5002 $mfloodtimer {^xecho -b server protect umode +g lifted after $mfloodtimer seconds;@msgflood=0;^umode -g}
	}
}

alias config.msgflood {
	if ( [$0] == [-r] )
	{
		return $msgfloodsensor
	} else if ([$0] == [-s]) {
		if (#>1) {
			@ msgfloodsensor = [$1];
		}
		xecho -v $acban msg flood sensor set to: "$msgfloodsensor"

	}
}

alias config.msgftimer {
	if ( [$0] == [-r] )
	{
		return $mfloodtimer
	} else if ([$0] == [-s]) {
		if (#>1) {
			@ mfloodtimer = [$1];
		}
		xecho -v $acban protect msg flood time set to: "$mfloodtimer"

	}
}

alias msgflood {
	config.msgflood -s $*
}

alias msgftimer {
	config.msgftimer -s $*
}

alias mtime msgftimer $*
alias mflood msgflood $*
