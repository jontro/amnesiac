# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage version;
  
alias svf (void) {
	if (@T)
		msg $T $fparse(format_version_reply);
};

alias sv (void) {
	if (@T)
	        msg $T ircII $J \($V\) [$info(i)] $a.ver/$a.rel\
		\($a.snap\) [cvs \($a.commitid\)];
};

alias supt (void) {
	if (@T)
		msg $T ircII $(J) \($V\) [$info(i)] client uptime: $tdiff2(${time() - F});
};

## version hook
^on ^ctcp_request "% % VERSION *" {
	^quote notice $0 :VERSION $fparse(format_version_reply) ${client_information} ;
};
