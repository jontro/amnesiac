# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage getusers;
## Last modified by rylan 10.3.06
## more cleanup is surely needed. (see obfuscate below)
## see core/fsets.m - lines 109-125 (more preferred as it works) //crapple

alias getusers (chan default "$C",void) {
	if (!ischannel($chan)) {
		^set status_user2 n/a;
		^set status_user3 n/a;
		^set status_user4 n/a;
		^set status_user7 n/a;
	}{
		^set status_user2 $#chops();
		^set status_user3 $#nochops();
		^set status_user4 $#pattern(*+* $channel());
		^set status_user7 $#pattern(* $channel());
	};
};

## stupid obfuscated hooks (it might break something if removed)
## ^^ will probably make people who look at this comment feel good
## about our scripting pratices.. (i would be pleasantly surprised
## if someone actually notices)
on ^switch_channels * {^getusers;};
on #-switch_windows 43 * {
	xeval -s $winserv($3) ^getusers;
};
## grep -aR 353 *
## core/getusers.m:^on #-353 2 * {^getusers}
## core/scan.m:on #^353 1 * {@nicks#=[$3-]}
on #-353 2 * {^getusers;};
on #-channel_sync 23 * {^getusers;};
