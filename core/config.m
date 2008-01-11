# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage config;

alias config {
	if ( @ && ! match($0 away protect misc oper relay connect)) {
		xecho -v $acban Invalid section.;
		xecho -v $acban -> config <section> <letter> <setting>;
		xecho -v $acban valid sections: <away|protect|misc|oper|relay|connect|query>;
	} else if (  # < 2) {
		if (match($0 away protect misc oper relay connect query)) {
			config.printsection $0;
		}{
			fe (away protect misc oper relay connect query) sec {
				config.printsection $sec;
			};
		};
		aecho -----------------------------------------------------------------------------;
		xecho -v $acban -> config <section> <letter> <setting>;
		xecho -v $acban valid sections: <away|protect|misc|oper|relay|connect|query>;
	}{
		@:aname= "confa$0";
		@:xx= ascii($1)-ascii(a);
		@ :cur1 = getitem($aname $xx);
		@:con1=word(0 $cur1);
		@$(config.$(con1))(-s $2-);

	};
};

## modular /config output stuff. actually shows options when it does exist.
alias osetitem
{
	@:aname= "confa$0";
	@setitem($aname $numitems($aname) $1-);
};

alias cleararray
{
	while ( !delitem(confa$0 0));
};

alias config.printsection
{
	switch ($0) {
	(away) {
		aecho ------------------------------= Away Settings =------------------------------;
	};
	(protect) {
		aecho ---------------------------= Protection Settings =---------------------------;
	};
	(misc) {
		aecho ------------------------------= Misc Settings =------------------------------;
	};
	(relay) {
		aecho ------------------------------= Relay Settings =-----------------------------;
	};
	(oper) {
		aecho ------------------------------= Oper Settings =------------------------------;
	};
	(connect) {
		aecho ------------------------------= Connect Settings =---------------------------;
	};
	(query) {
		aecho ------------------------------= Query Settings =---------------------------;
	};
	};
	@:aname= "confa$0";
	for (@xx=0, xx<numitems($aname), @xx=xx+2) {
		@ :cur1 = getitem($aname $xx);
		@ :con1 = word(0 $cur1);
		@ :mod1 = restw(1 $cur1);
		@ :mod1 = "\($chr(${ascii(a)+xx})\) $mod1";
		@ :cval1 = (config.$(con1))(-r);
		@ :mod1= "$[25]mod1 [$cval1]";
		if ( xx+1 >= numitems($aname) ) {
			@ :mod2 = '';
		}{
			@ :cur2=getitem($aname ${xx+1});
			@ :con2 = word(0 $cur2);
			@ :mod2 = restw(1 $cur2);
			@ :mod2 = "\($chr(${ascii(a)+xx+1})\) $mod2";
			@:cval2 = (config.$(con2))(-r);
			@ :mod2= "$[25]mod2 [$cval2]";
		};
		if (strlen($mod1) < 37 && strlen($mod2)) {
			@:mod1 = "$[37]mod1 |";
		} else if (strlen($mod2)) {
			@:mod1 = "$mod1 |";
		};
		aecho $mod1 $mod2;
	};
};

## end /config output.

## config helper alias
alias config.matchinput {
	if (*2=="''") {
		xecho -v $acban $3- set to "$($1)";
	}{
		@:aVar=mid(1 ${strlen($2)-2} $2);
		if (match($aVar $split(| $0))) {
			^assign $1 $aVar;
			xecho -v $acban $3- set to "$($1)";
		}{
			xecho -v $acban invalid choice <$0>;
		};
	};
};


## end timestamp stuff.

## pubnick highlight
alias config.pubnick {
	if ( *0 == '-r' )
	{
		return $_pubnick;
	} else if (*0 == '-s') {
		if (#>1) {
			@ _pubnick = *1;
		}
		xecho -v $acban auto-response set to "$_pubnick";
	};
};

alias _pubn {
	config.pubnick -s $*;
};

## other misc configs
alias config.umode {
	if ( *0 == '-r' ) {
		return $getumode;
	} else if (*0 == '-s') {
		if (#>1) {
			@ getumode = *1;
		};
		xecho -v $acban usermode set to: "$getumode";
	};
};

alias config.timestamp {
	if ( *0 == '-r' ) {
		return $_tss;
	} else if (*0 == '-s') {
		config.matchinput on|off _tss '$1' Time stamp events;
		@format.loaditem(timestamp_some $theme.format.timestamp_some);
	};
};

## auto rejoin config
alias config.auto_rejoin {
	if ( *0 == '-r' ) {
		return $tolower($getset(auto_rejoin));
	} else if (*0 == '-s') {
		@tmpvar=tolower($getset(auto_rejoin));
		config.matchinput on|off tmpvar '$1' auto rejoin;
		^set auto_rejoin $tmpvar;
	};
};

alias config.auto_rejoin_delay {
	if ( *0 == '-r' ) {
		return $getset(auto_rejoin_delay);
	} else if ( *0 == '-s') {
		if (#>1) {
			^set auto_rejoin_delay $1;
		};
		xecho -v $acban Auto rejoin delay set to: "$getset(auto_rejoin_delay)";
	};
};

## fixed doublestat
alias config.windowdoubles {
	if ( *0 == '-r' ) {
		return $windowdoubles;
	} else if (*0 == '-s') {
		config.matchinput on|off windowdoubles '$1' double fixed window;
	};
};

## wrappers
alias setumode {
	config.umode -s $*;
};

alias _tsmps {
	config.timestamp -s $*;
};

alias _double {
	config.windowdoubles -s $*;
};

## cmd line config aliases.
alias cumode {setumode $*;};
alias kickops {kops $*;};
alias resp {_pubn $*;};
alias timestamp {_tsmps $*;};
alias stamp {timestamp $*;};
alias extpub {modeshow $*;};
alias tform {format 3 $*};

## connect items
osetitem connect umode Auto-connect umode:;
osetitem connect auto_reconnect Auto-reconnect:;
osetitem connect auto_reconnect_delay Auto-reconnect delay:;
osetitem connect auto_reconnect_retries Auto-reconnect retry:;
osetitem connect auto_rejoin_connect Auto-rejoin connect:;

## misc config items
osetitem misc origdelay Orignick Timer:;
osetitem misc timestamp Timestamps:;
osetitem misc pubnick Pubstring:;
osetitem misc auto_rejoin Auto rejoin:;
osetitem misc auto_rejoin_delay Auto rejoin delay:;
osetitem misc windowdoubles Double fixed window:;
