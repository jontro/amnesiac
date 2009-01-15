# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;                       
};

subpackage ignore;

## some short aliases.
alias ign {ignore $*;};
alias cloak {ignore *!*@* ctcp;};
alias uncloak tig;
## end short aliases.

alias tig {
	@igns=numsort($ignorectl(REFNUMS));

	if ( strlen($igns) ) {
		fe ($igns) ignores {
			xecho -b [$ignores] $ignorectl(GET $ignores NICK) $ignorectl(GET $ignores LEVEL);
		};
		input "enter # of which ignore to takeoff: " {
			if ( ( "$0" >= word(0 $igns)) && "$0" <= word(${numwords($igns)-1} $igns)) {
				@ignorectl(DELETE $0);
			}
			{
				xecho -b number out of range \($word(0 $igns) - $word(${numwords($igns)-1} $igns)\);
			};
		};
	}{
		xecho -b no ignores currently;
	};
};

alias _ighost (uh,void){
	if (match(*!*@* $uh)) {
		return $uh;
	}{
		if (:uhost=getuhost($uh)) {
                        return $uhost;
		}{
			return $uh;
		};
       };
};

alias ignore {
	if (#) {
		if (# > 1) {
			//ignore $_ighost($0) $1-;
		}{
			//ignore $_ighost($0) all;
		};
	}{
		xecho -b Ignorance List:;
		@:igns=numsort($ignorectl(REFNUMS));
		if ( strlen($igns) ) {
			fe ($igns) ignores {
				xecho -b [$ignores] $ignorectl(GET $ignores NICK) $ignorectl(GET $ignores LEVEL);
			};
	
		};
	};
};
		
alias cig {
	if (@) {
		^ignore $0 public;
		xecho -b ignoring public from $0, /tig to unignore;
	}{
		^ignore $serverchan() public;
		xecho -b ignoring public from $serverchan() , /tig to unignore;
	};
};
