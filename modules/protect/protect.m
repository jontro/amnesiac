# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# TODO: convert to pf-loader

subpackage protect
eval osetitem protect unbanself Unbanself when banned

## unbanself protection hook
^on #-mode_stripped 53 "% % +b*" {
	if (ischanop($N $1) && N != [$1]) {
		if (_ubanself == [on] && comatch(*!*$userhost($N) $3) > 0) {
			^mode $1 -b $3
				^kick $1 $0 don't ban me.
				}			
		}
}

## wrappers
alias protect _selfban $*
alias _selfban {
	config.unbanself -s $*
}

## unbanself(protect) conf
alias config.unbanself {
	if ( [$0] == [-r] ) {
		return $_ubanself
	} else if ([$0] == [-s]) {
		config.matchinput on|off _ubanself '$1' unban self protect:
	}
}
