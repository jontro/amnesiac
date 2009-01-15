# Copyright (c) 2003-2009 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# TODO: Convert to PF-loader/rewrite this uglyness
subpackage eimodes;

## simple aliases.
alias i invs;
alias e exs;
alias -I {^mode $serverchan() -I $*};
alias -E {^mode $serverchan() -e $*};
alias +I {^mode $serverchan() +I $*};
alias +E {^mode $serverchan() +e $*};
alias exempt exs;
alias invites invs;
alias tpi tinv;
alias tpe texp;
alias pinv ui;
alias pexp ue;
alias smhelp rathelp;
# generic helper functions dealing with channel modes
alias genterm (name dwords 1,mode,lrpl_list,lrpl_eoflist) {
	@gmode=mode;
	@rpl_list=lrpl_list;
	@rpl_eoflist=lrpl_eoflist;
	^on $rpl_list -;
	^on ^$rpl_list * {
		@setitem(term.$1 $numitems(term.$1) $2-);
	};
	^on ^$rpl_eoflist * {
		^on $rpl_list -;
		^on $rpl_eoflist -;
		if (numitems(term.$2)) {
			@chan=*2;
			for (@:xx=0,xx<numitems(term.$chan),@xx++) {
				@:ban=getitem(term.$chan $xx);
				//echo $(hblk)[$(cl)${xx+1}$(hblk)]$(cl) $word(0 $ban) set by $(hwht)$before(! $word(1 $ban)) $(cl)$tdiff(${time()-word(2 $ban)}) ago;
			};
			input "which $name(s) do you want to remove? " {
				fe ($*) xx {
		        		@:aa = substr("-" $xx);
					if ( aa != -1 ){
						@:start = left($aa $xx);
						@:end = rest(${aa+1} $xx );
					}{
						@start = xx;
						@end = xx;
					};
					for (@cc=start,cc<=end, @cc++){
						if (cc>0 && cc<=numitems(term.$chan)) {
							mode $chan -$gmode $word(0 $getitem(term.$chan ${cc-1}));
						};
					};
		            	};
				@delarray(term.$chan);
				@chan='';
			};
		};
	};
	^mode $serverchan() $mode;

};

alias gentall (lmode,lrpl_list,lrpl_eoflist) {
	@mode=lmode;
	@rpl_list=lrpl_list;
	@rpl_eoflist=lrpl_eoflist;
	^on ^$rpl_list * {
		@setitem(ubans $numitems(ubans) $2);
		if (numitems(ubans)==4) {
			for (@:xx=0,xx<4,@:xx+=4) {
				//mode $serverchan() -$(mode)$(mode)$(mode)$(mode) $getitem(ubans $xx) $getitem(ubans ${xx+1}) $getitem(ubans ${xx+2}) $getitem(ubans ${xx+3});
			};
			@delarray(ubans);
		};
	};
	^on ^$rpl_eoflist * {
		^on ^$rpl_list -"*";
		^on ^$rpl_eoflist -"*";
		if (:num=numitems(ubans)) {
			//mode $serverchan() -$repeat($num $mode) $getitem(ubans 0) ${num>1?getitem(ubans 1):''} ${num>2?getitem(ubans 2):''};
		};
		@delarray(ubans);
	};
	//mode $serverchan() $mode;
};

alias genub (lmode,lrpl_list,lrpl_eoflist,...){
	@mode=lmode;
	@rpl_list=lrpl_list;
	@rpl_eoflist=lrpl_eoflist;
	if (!@) {
		@gentall($mode $rpl_list $rpl_eoflist);
	}{
		if (match(*!*@* $0)) {
			//mode $serverchan() -$mode $0;
		}{
			^on ^$rpl_list * {
				@setitem(ubans $numitems(ubans) $2);
			};
			^on ^$rpl_eoflist * \{
				^on ^$rpl_list -"*"\;
				^on ^$rpl_eoflist -"*"\;
				^userhost $0 -cmd {
					if (rmatchitem(ubans $0!$3@$4) != -2) {
						mode $serverchan() -$mode $getitem(ubans $rmatchitem(ubans $0!$3@$4));
					};
					@delarray(ubans);
				}\;
			\};
			//mode $serverchan() +$mode;
		};
	};
};
alias gens (mode, chan default "$serverchan()"){
	^mode $chan $mode;
};
alias tban { @genterm("ban" b 367 368);};
alias texp { @genterm ("ban exempt" e 348 349);};
alias tinv { @genterm("invite exempt" I 346 347);};
alias takeall {@gentall (b 367 368);};
alias itall {@gentall (I 346 347);};
alias etall {@gentall (e 348 349);};
alias ub {@genub (b 367 368${@* ?" $*" : ''});};
alias ui {@genub (I 346 347${@* ?" $*" : ''});};
alias ue {@genub (e 348 349${@* ?" $*" : ''});};
alias bans {@gens (b${@* ?" $*" : ''});};
alias invs {@gens (I${@* ?" $*" : ''});};
alias exs {@gens (e${@* ?" $*" : ''});};

fe (346 348 367) cc {
	@:str="";
	if (cc == 367) {
		@str='ban';
	} else if (cc ==346) {
		@str='invite exempt';
	}{
		@str='ban exempt';
	};
	^on ^${cc+1} * \{
		if ( *1 == 1 ) \{
			xecho -b $$1 $str on $$2\;
		\}\{
			xecho -b $$1 $(str)s on $$2\;
		\}\;
	\};
	^on ^$cc * {
		//echo  [$1] [$2] [$3]  [$midw(1 3 $stime($4))];
	};
};

alias rathelp {
//echo -----------------= Special Modes Help =----------------------------;
//echo tpi /tpi invite exempt menu -I ie: /tpi 3-6 removes;
//echo       invite exempts 3 4 5 and 6 shown in the menu.;
//echo tpe /tpe ban exempt menu +e ie: /tpe 4 to remove one exempt.;
//echo ui  /ui clears the invite exempts in current chan -IIII.;
//echo ue  /ue clears the ban exempts in current chan -eeee.;
//echo i   /i shows the invite exempts in current chan if any.;
//echo e   /e shows the ban exempts in current chan if any.;
//echo +i  /+i add a invite exempt in current chan ie: /+i *!test@test.com;
//echo +e  /+e add a ban exempt in current chan ie: /+e *!ident@host.com;
//echo                      -----= Other Aliases =----;
//echo pinv  /pinv - same as /ui cleans invite exempt list.;
//echo pexp  /pexp - same as /ue cleans ban exempt list.;
//echo tinv  /tinv - same as /tpi invite exempt menu.;
//echo texp  /texp - same as /tpe ban exempt menu.;
//echo ---------------------------------------------------------------------;
};
