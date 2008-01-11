# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage scan;

^on ^names * {};

## fixups
alias pad.nick {
	if (left(1 $*) != '@' && left(1 $*) != '+') {
		return $[10]*;
	};
	return $[10]*;
};

alias fix.scan2 {
	return $msar(g/@/@/+/+/$pad.nick($0));
};

# Quite usless alias eh, unfortunatley some scans in sc/ depends on this
# which means all user save files
alias fix.scan3 {
	return $0;
};

alias printnames (printstats,lchan,lnick) {
	@:lnick=sar(g/?//$sar(g/.//$lnick));
	if (@lchan && printstats != 2) {
		@:xevars = "-w $winchan($lchan)";
	}{
		@:xevars = '-v';
	};
	@:scan1 = pattern(*@* $lnick);
	push scan1 $pattern(*+* $filter(*@* $lnick));
	push scan1 $filter(*+* $filter(*@* $lnick));
	@:nicks.ops = pattern(*@* $lnick);
	@:nicks.voc = pattern(*+* $lnick);
	@:nicks.non = filter(*+* $filter(*@* $lnick));
 	
	if (@printstats) {
		xecho $xevars -- $fparse(format_scan_users $#nicks.ops $#nicks.non $#nicks.voc $lchan);
	};
	if (@format_scan_header) {
		xecho $xevars -- $fparse(format_scan_header);
	};
	if (format_scan_width > 1) {
		@_swidth=word(0 $geom()) / format_scan_width;
	}{
		@_swidth=#nicks.ops + #nicks.non + #nicks.voc;
	};
	: {/*
	   This piece of code is a real bitch
	   took me a long time to figure out what it does do
	   first for each builds up two variables looking like this
	   @_nlist=[_nlist.1 _nlist.2 _nlist.3 ...] up to $_swidth
	   @_nlist2=[$fparse(form... $_nlist.1) $fparse(form... $_nlist.2) ...]
	
	   then it does a fe ($channel_nick_list) _nlist.1 _nlist.2 ... {
		xecho $_nlist.1 $_nlist.2 $_nlist.3 ... <--- _nlist2 simplified
	   }
	   
	   this is the most obscure lines of code I've ever seen,
	   hence the explanation. Someone has been smoking crack!
	   (It's a beautiful way to do it though ;) )
	   //Kreca
	*/};
	@:_nlist='';
	@:_nlist2='';
	fe ($jot(1 $_swidth)) n1 {
		push _nlist _nlist.$n1;
		push _nlist2 \$fparse\(format_scan_nicks \$_nlist\.$n1);
	};
	fe ($scan1) $_nlist {
		if (format_scan_nicks_border) {
			xecho $xevars -- $fparse(format_scan_nicks_border) ${**_nlist2};
		}{
			xecho $xevars -- ${**_nlist2};
		};
	};
	if (format_scan_footer) {
		xecho $xevars -- $fparse(format_scan_footer);
	};
};

### propz to robohak for clueing me into using the 366 numeric for nick list
on #^353 1 * {@nicks#="$3-";};
on ^366 "*" {
	printnames 1 $1 $nicks;
	assign -nicks;
};

alias scan (chan default "$C" , void){
	printnames 1 $chan $channel($chan);
};

alias sco (chan default "$C",void){
	^xecho -w $winchan($lchan) -- $fparse(format_scan_users_op $#channel($chan) $chan);
	printnames 0 $chan $pattern(*@* $channel($chan));
};

alias scn (chan default "$C",void) {
	@:lscan = pattern(*..* $channel($chan));
	push lscan $pattern(*.+* $channel($chan));
	push lscan $pattern(.\\?* $channel($chan));
	xecho -w $winchan($lchan) -- $fparse(format_scan_users_non $#nochops($chan) $chan);
	printnames 0 $chan $lscan;
};

alias scv (chan default "$C",void) {
	xecho -w $winchan($lchan) -- $fparse(format_scan_users_voc $#pattern(*.+* $channel($chan)) $chan);
	printnames 0 $chan  $pattern(*.+* $channel($chan));
};

alias sc {
        if (@) {
                names $*;
        }{
                scan;
        };
};
