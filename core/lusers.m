# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
#
## last modified by rylan on 2006 Oct 03
## Ok, so how we're doing this is completely broken. I'm going to just redo it
## so it's not all broken. -skullY
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage lusers;
 
# /lusers server server is completely retarded. Fix it.
alias lusers {
	if (@) {
		//lusers $0 $0;
	}{
		//lusers;
	};
};

# Fucking loose-ass ircii protocol can bite me.
alias _getnum {
	@_number = *0;
	fe ($1-) _word {
		if (isnumber($_word)) {
			if (_number < 1) {
				@function_return = _word;
				break;
			}{
				@_number--;
			};
		};
	};
};

on ^251 * {
	@lusers.gvisible = *3;
	@lusers.ginvisible = *6;
	@lusers.servernum = *9;
};

on ^252 * {
	@lusers.gopers = *1;
};

on ^253 * {
	@lusers.unknown = *1;
};

on ^254 * {
	@lusers.channels = *1;
};

on ^255 * {
	@lusers.lusers = *3;
	@lusers.lservers = *6;
};

on ^265 * {
	@lusers.lusers = _getnum(0 $strip(, $1-));
	@lusers.lusersmax = _getnum(1 $strip(, $1-));
};

on ^266 * {
	@lusers.gusers = _getnum(0 $strip(, $1-));
	@lusers.gusersmax = _getnum(1 $strip(, $1-));
};

on ^250 * {
	@lusers.lconnectionmax = *4;
	@lusers.lconnectionstotal = strip(\( $7);
	xecho -b Statistics for $0:;
	if (lusers.unknown) {
		xecho -b Unknown:       $lusers.unknown unknown connection(s);
	};
	xecho -b Global Users:  ${lusers.gusers}, $lusers.gusersmax max \($lusers.ginvisible invisible, $lusers.gopers opers\);
	xecho -b Local Users:   ${lusers.lusers}, $lusers.lusersmax max \($trunc(5 ${100 * (lusers.lusers / lusers.gusers)})%\);
	xecho -b Servers:       ${lusers.servernum} \(${lusers.gusers / lusers.servernum} avg users per server\);
	xecho -b Channels:      ${lusers.channels} \(${lusers.gusers / lusers.channels} avg users per channel\);
	xecho -b Connect Count: $lusers.lconnectionmax max \($lusers.lusersmax clients\) \($lusers.lconnectionstotal received\);
	^assign -lusers;
};
