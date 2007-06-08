# Copyright (c) 2003-2007 Amnesiac Software Project. 
# See the 'COPYRIGHT' file for more information.     
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage action;

## action hooks
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

