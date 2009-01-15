# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage exec;

## dns stuff.
alias dns {
	if (match(*.* $0)) {
		exec -name dns nslookup $0;
		@ _dnst=*0;
	}{
			^userhost $0 -cmd if (*4 !='<UNKNOWN>') {
				exec -name dns nslookup $4;
				@ _dnst=*0;
			};
	};
};
 	
alias nslookup {dns $*;};
 
^on ^exec "dns *" {
	if (*1 == 'Non-authoritative') {
		xecho -c [dns] Non-authoritative answer for $_dnst;
	}{
		if (*1 == 'Server:') {
			xecho -c [dns] -----------------------------------------;
			xecho -c [dns] System Name Server: $2-;
		} else if (@"$1-") {
			xecho -c [dns] $1-;
		};
	};
};

^on ^exec_exit "dns % %" {
	xecho -c [dns] -----------------------------------------;
};

## cmd exec shit.
alias ls {^exec ls $*;};
alias osv {^exec -o uname -amnv;};
alias ps {^exec ps $*;};
alias mkdir {exec mkdir $*;};
alias hosts {exec host $*;};
alias dig {exec dig $*;};
