# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# this taken from EPIC4 dist written by archon

if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage more;

alias more {
	if ( @ ) {
		if (fexist("$*") == 1) {
			@ :fd = open("$*" R);

			while (1) {
				@:rows = winsize() - 1;
				for (@:line=0, line <= rows, @line++) {
					@ outp = read($fd);
					if (eof($fd)) {
						@ close($fd);
						return;
					}{
						xecho $outp;
					};
				};
				^local ret $'Enter q to quit, or anything else to continue ';
				if (ret == 'q') {
					@ close($fd);
					return;
				};
			};
		}{
			xecho -b $*\: no such file.;
		};
	}{
		xecho -b Usage: /more <filename>;
	};
};

#archon'96 rylan'06 kreca'06
