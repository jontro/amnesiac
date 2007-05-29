# Copyright (c) 2003-2007 Amnesiac Software Project. 
# See the 'COPYRIGHT' file for more information.     
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage action;

## action hooks
if (info(i) < 1415) {
	## This code block is kept for backwards compability

	## helper function that'll make /me output to the correct window
	## during a dcc chat //kreca 
	## XXX, this is only intended for epic5 and is a temporary solution. 
	## The output handling will change in the future.
	alias myquerywin (wn,void) {
		fe ($winrefs()) cw {
			if ( findw($wn $winnicklist($cw)) != -1) {
				return $cw;
			};
		};
		return -1;
	};

	on ^action * {
		if (winchan($1)) {
			if ( iscurchan($1) ) {
				xecho $fparse(format_action $0 $1 $2-);
			} {
				xecho $fparse(format_action_other $0 $1 $2-);
			};
		} {
			@:wqwin = myquerywin($0);
			if ( wqwin != -1)
			{
				xecho -window $wqwin $fparse(format_desc $0 $1 $2-);
			} {
				xecho $fparse(format_action_other $0 $1 $2-);
			};
		};
	};
}{
	## new code body, this will be the only remaint once epic5 goes
	## production.
	on ^action * (sender, recvr, body) {
		if (winchan($recvr)) {
			if (iscurchan($recvr)) {
				xecho $fparse(format_action $sender $recvr $body);
			} {
				xecho $fparse(format_action_other $sender $recvr $body);
			};
		} {
			xecho $fparse(format_desc $sender $recvr $body);
		};
	};
};

on ^send_action "*" {
	switch ( $0 ) {
        ( $C ) { //echo $fparse(format_action $N $0 $1-);};
        ( #* ) { //echo $fparse(format_action_other $N $0 $1-);};
        ( * )  { //echo $fparse(format_send_desc $0 $N $1-);};
	};
};

alias mypad {
        return $pad(${32-strlen($1-)} =);
};

