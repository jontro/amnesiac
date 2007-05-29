# Copyright (c) 2003-2007 Amnesiac Software Project. 
# See the 'COPYRIGHT' file for more information.     
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage banner;

## 2005 crapple

alias banner.head {awecho  ------------------------------------------------------------------;};
alias banner.mid {awecho  | $* ;};
alias banner.mid2 {awecho  | $* ;};
alias banner.foot {awecho  ------------------------------------------------------------------;};

alias banner.lchead {awecho  --------------------------------------------------------------;};
alias banner.lcmid  {awecho  $* ;};
alias banner.lcfoot {awecho ---------------------------------------------------------------;};
alias banner.lcsep {awecho  ---------------------------------------------------------------;};
