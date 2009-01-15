# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.

## constructor
alias format.loadwhois (number,void) {
	if (fexist($(loadpath)format/whois/whois.$number) != -1) {
		load ${loadpath}format/whois/whois.$number;
		@theme.format.whois = number;
		return 1;
	}{
		return 0;
	};
};
alias whoisform.show (void) {
	@:currentwhois=theme.format.whois;
	for (@:mm=1, mm <= 10, @mm++) {
		aecho %K\[%n$mm%K\]%n;
		echo;
		@format.loaditem(whois $mm);
		//shook 311 . zak cum i.love.androgyns@san.francisco * crapple;
		//shook 301 . Crying while eating;
		//shook 319 . . @#bearcave +#bignuts #freebsd;
		//shook 312 . . irc.cripplekids.org eurotrash's are cool;
		//shook 313 . zak;
		//shook 317 . zak 666 0;
		//shook 318;
		echo;
	};
	@format.loaditem(whois $currentwhois);
};

alias whoisform (number,void) {
	if (@number) {
		if (format.loaditem(whois $number)) {
			xecho $acban whois format set to $theme.format.whois;
		}{
			xecho -b please make a valid selection.;
		};
	}{
		whoisform.show;
	};
};
