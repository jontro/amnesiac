# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

# amnesiac tab script
# completley re-written by kreca
# future project is separating all different commands in different files
# to make additions and syntax definitions easy and make customization easier
# i.e. let users decide how /msg tab cycling etc should work since there
# are a lot of different ways to do this...
# We might be able to merge our tc script in this so we dont need two separate
# modules

if (word(2 $loadinfo()) != [pf]) { load -pf $word(1 $loadinfo()); return; };

subpackage tab;

@ bindctl(sequence ^I set parse_command get.msg);
@_tabnum = numitems(tabs)-1;
alias disp {
	return $gendisp("$onchannel()" $*);
};
alias cmddisp {
	@ :mm = symbolctl(pmatch builtin_command $0*);
	^push mm $symbolctl(pmatch alias $0*);
	return $gendisp("$tolower($mm)" $*);
};
alias gendisp (sl dwords 1,user,void) {
	^local _nlist,_nlist2,uulist;
	@:ulist=uniq($sort($pattern($user* $sl)));
	@:denom=prefix($ulist);
	
	@:_swidth="${word(0 $geom()) / 15}";
	fe ($jot(1 $_swidth)) n1 {
		^push _nlist nlist.$n1;
		^push _nlist2 \$fparse\(format_scan_nicks \$nlist\.$n1);
	};
	fe ($ulist) nu
	{
		^push uulist $nu;
	};

	if ( #ulist == 1)
	{
		@:denom="$denom ";
	}{
		fe ($uulist) $_nlist {
			eval xecho -v $_nlist2;
		};
	};
	@:ret = rest(${strlen($user)} $denom);

#remove additional white space
	if (right(1 $user)== ' '&&ret == ' ')
		@:ret='';
	return $ret;
};

alias _getlast {
	@:ret=word(${# - 1} $*);
	if (right(1 $*)==' ')
		@:ret='';
	return $ret;
};

alias get.msg {
	if ( #L > 0 && left(1 $L) != "$K" && right(1 $L) != ' ' )
	{
		parsekey end_of_line;
		xtype -l $disp($word(${#L-1} $L));
		return;
	};

switch ($L) {
## edit topic here, using the function edit_topic from scripts
	($(K)topic %)
	{
		if ( right(1 $L) == ' ')
		{
				edit_topic;
				return;
		};
	};
## Nick completion
	($(K)kick *)
	($(K)kb *)
	($(K)deop *)
	($(K)op *)
	($(K)voice *)
	($(K)v *)
	($(K)k *)
	($(K)bk *)
	($(K)me *)
	($(K)whois *)
	($(K)wi *)
	($(K)wii *)
	{
		parsekey END_OF_LINE;
		if ( #L==1 || right(1 $L) == ' ')
		{
			xtype -l $disp();
		}{
			xtype -l $disp($word(${#L-1} $L));
		};
		return;

	};
## Filename completion
	($(K)cd %)
	($(K)ls %)
	($(K)load %)
	($(K)dcc send % %)
	($(K)send % %)
	($(K)xdcc offer %) {
	@lw=twiddle($rightw(1 $L));
	if (:temp = pattern(${lw}% $glob(${lw}*))) {
		@ovar= #temp > 1 ? prefix($temp) : temp;
		parsekey END_OF_LINE;
		xtype -l $rest(${strlen($lw)} $ovar);
		if ( #temp > 1)
		{
			fe ( $temp) kdisp
			{
				@filename=rightw(1 $split(/ $kdisp));
				xecho -c $filename;
			};
		} else if ( right(1 $ovar) != '/' )
		{
			type $chr(32);
		};
	
	};

	   return;
	};
	()
	($(K)m${' '})
	($(K)m %${' '})
	($(K)msg${' '})
	($(K)msg %${' '})
	{
## msg completion
		if (_tabnum < 0||!@getitem(tabs $_tabnum)) {
			@_tabnum = numitems(tabs)-1;
		};
		parsekey reset_line /msg $getitem(tabs $_tabnum)$chr(32);
		@_tabnum--;
		return;

	};
	($(K)dcc${' '})
	($(K)dcc %)
	{
		@:cmds='CHAT SEND GET RAW CLOSE CLOSEALL LIST';
		xtype -l $gendisp("$tolower($cmds)" $_getlast($L));
		return;
	};
	($(K)dcc close${' '})
	($(K)dcc close %)
	{
		@:cmds='CHAT SEND GET RAW -ALL';
		xtype -l $gendisp("$tolower($cmds)" $_getlast($L));
		return;
		
	};
# For matching active dcc sessions. However dccctl seems broke so this
# will work as soon as someone fixes this.
	($(K)dcx %)
	($(K)nochat %)
	($(K)dcn %)
	($(K)dcs %)
	($(K)dcr %)
	($(K)dcc close %${' '})
	($(K)dcc close % %)
	{
		
		@:cmd=word(0 $L);
		@:mm=word(2 $L);

		if (cmd == "$(K)dcx" || cmd == "$(K)nochat" ) {
			@mm='chat';
		} else if (cmd == "$(K)dcs") {
			@mm='send';
		} else if (cmd == "$(K)dcg") {
			@mm='get';
		};

		@:refs = dccctl(TYPEMATCH $mm);
		if (mm == '*' || mm == '-ALL' || cmd == "$(K)dcn"  || cmd == "$(K)dcr") {
			@:refs=dccctl(USERMATCH *);
		};
		@:users='';
		fe ($refs) rr {
			push users $dccctl(GET $rr user);
		};
		xtype -l $gendisp("$users" $_getlast($L));
		return;
	};
# dcc close completion
	($(K)dcc close SEND %${' '})
	($(K)dcs %${' '})
	{
		@:refs=dccctl(TYPEMATCH SEND);
		@:files='';
		fe ($refs) rr {
			push files $dccctl(GET $rr description);
		};
		xtype -l $gendisp("$files" $_getlast($L));
		return;
	};
# set completion
	($(K)set %)
	{
		parsekey END_OF_LINE;
		xtype -l $gendisp("$symbolctl(PMATCH BUILTIN_VARIABLE *)" $_getlast($L));
	};
# channel completion
	($(K)mode #%)
	($(K)part #%)
	($(K)msg ?#)
	($(K)msg ?#%)
	($(K)notice ?#)
	($(K)notice ?#%)
	($(K)ctcp #)
	($(K)ctcp #%)
	($(K)inv #)
	($(K)inv #%)
	($(K)inv * #)
	($(K)inv * #%)
	($(K)invite #)
	($(K)invite #%)
	($(K)invite * #)
	($(K)invite * #%)
	{
		parsekey END_OF_LINE;
		@:last=_getlast($L);
		@:ll=left(1 $last);
		if ( ll != '#')
			@last=after($ll $last);
		xtype -l $gendisp("$mychannels()" $last);
		return;
	};
	($(K)theme${' '})
	($(K)theme %)
	{
		@:ath="";
		fe ($glob($(loadpath)themes\/*.th)) th {
			@ :thfile = open($th R T);
			@ :auth = after(: $read($thfile));
			@ :desc = after(: $read($thfile));
			@ :name = after(: $read($thfile));
			@ close($thfile);
			push ath $name;
		};
		xtype -l $gendisp("$ath" $_getlast($L));
	};
# Nick completion (all channels and msg buffer)
	($(K)q %)
	($(K)query %)
	($(K)ping %)
	($(K)m %)
	($(K)msg %)
	($(K)notice %)
	($(K)dcc chat %)
	($(K)chat %)
	($(K)dcc send %)
	($(K)send %)
	($(K)ctcp %)
	($(K)dns %)
	($(K)ignore${' '})
	($(K)ignore %)
	($(K)invite *)
	($(K)inv *)
	{
		@:aitems='';
		if ( @T && !ischannel($T))
			push aitems $T;
		fe ($mychannels()) cc {
			push aitems $onchannel($cc);
		};
		for ii from 0 to ${numitems(tabs)-1} {
			push aitems $getitem(tabs $ii);
		};
		parsekey END_OF_LINE;
		xtype -l $gendisp("$aitems" $_getlast($L));
		return;
	};
	($(K)%)
	{
		parsekey END_OF_LINE;
		xtype -l $cmddisp($rest(1 $L));
		return;
	};

};}; 
## The switch is incorrectly tab-aligned 

alias add.msg (nick,void){
	if (numitems(tabs) == 20) {
		@delitem(tabs 0);
	};
	if (rmatchitem(tabs $nick) < 0) {
		@setitem(tabs $numitems(tabs) $nick);
		@_tabnum="${numitems(tabs)-1}";
	}{
		@_tabnum = rmatchitem(tabs $nick);
	};
};

on #-input 3 "/msg #*" {
	@add.msg($1);
};


fe (msg send_msg) cur {
	on #-$cur 2 * {
		@add.msg($0);
	};
};

fe (send_dcc_chat dcc_chat dcc_connect dcc_request dcc_offer) cur {
	on #-$cur 2 * {
		@add.msg(=$0);
	};
};

#kreca 2005-2007
