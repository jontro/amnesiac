# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

alias whoisform.show {
	load $(loadpath)format/whois/whois.ans;
};

## constructor
alias format.loadwhois (number,void)
{
	if (fexist($(loadpath)format/whois/whois.$number)) {
		load ${loadpath}format/whois/whois.$number;
		@theme.format.whois = number;
		return 1;
	}{
		return 0;
	};
};

alias whoisform (number,void) {
	if (@number) {
		if (format.loaditem(whois $number)) {
			xecho $acban whois format set to $theme.format.whois;
		};
	}{
		whoisform.show;
	};
};
