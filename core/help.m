# Copyright (c) 2003-2010 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage help;

## Help strings below.
@ahelp.rn='%Wu%nsage%K:%n /rn will change nick to a random nick of 7 chars';
@ahelp.winhelp='%Wu%nsage%K:%n /winhelp will display help menu for windowing shortcuts.';
@ahelp.untheme='%Wu%nsage%K:%n /untheme will make amnesiac revert back to the default theme.';
@ahelp.unban='%Wu%nsage%K:%n /unban <nick|host> will unban nick or host from current channel';
@ahelp.tig='%Wu%nsage%K:%n /tig will display all current ignores and prompt to delete one.';
@ahelp.theme='%Wu%nsage%K:%n /theme will display all amnesiac themes and you can choose which one you want.';
@ahelp.supt='%Wu%nsage%K:%n /supt will paste client version and uptime to current channel';
@ahelp.staynick='%Wu%nsage%K:%n /staynick will cancel /orignick.';
@ahelp.bkt='%Wu%nsage%K:%n bkt <nick> <reason> - will bankick specified nick then unban them after 5 seconds.';
@ahelp.dldir='%Wu%nsage%K:%n /dldir </path/to/dir> sets download path.';
@ahelp.partall='%Wu%nsage%K:%n /partall will part all current channels.';
@ahelp.not='%Wu%nsage%K:%n /not will unset topic on current channel.';
@ahelp.chops='%Wu%nsage%K:%n /chops will display all ops on current channel.';
@ahelp.nops='%Wu%nsage%K:%n /nops will display all nonops on current channel.';
@ahelp.vocs='%Wu%nsage%K:%n /vocs will display all voiced members on current channel.';
@ahelp.mw='%Wu%nsage%K:%n /mw -hidden|split|kill [num] <will create/kill a window bound to msgs>';
@ahelp.mv='%Wu%nsage%K:%n /mv will mass voice everyone on current channel';
@ahelp.more='%Wu%nsage%K:%n /more <textfile> will display text file to screen.';
@ahelp.lk='%Wu%nsage%K:%n /lk will kick all non oped and voiced lusers from current channel';
@ahelp.links='%Wu%nsage%K:%n /links will give you a server list of all the servers linked to current network';
@ahelp.kickban='%Wu%nsage%K:%n /kickban <nick1>,<nick2> will kick and ban nick(s) from current channel';
@ahelp.kb='%Wu%nsage%K:%n /kb <nick1>,<nick2> will kick and ban nick(s) from current channel.';
@ahelp.invkick='%Wu%nsage%K:%n /invkick <nick> <reason> will set mode +i and kick nick from current channel. Removes +i after 10 secs.';
@ahelp.ik='%Wu%nsage%K:%n /ik <nick> <reason> will set mode +i and kick nick from current channel. Removes +i after 10 secs.';
@ahelp.inv='%Wu%nsage%K:%n /inv <nick> will invite nick to current channel.';
@ahelp.iban='%Wu%nsage%K:%n /iban <nick> will ban nick by ident from current channel';
@ahelp.devoice='%Wu%nsage%K:%n /devoice <nick1 nick2 nick3> devoices nicks from current channel.';
@ahelp.cops='%Wu%nsage%K:%n /cops to list irc operators on current channel.';
@ahelp.cig='%Wu%nsage%K:%n /cig <channel> to ignore public from current or specified channel';
@ahelp.bankick='%Wu%nsage%K:%n /bankick <nick> [nick1,nick2] will ban and kick nick(s) from current channel.';
@ahelp.q='%Wu%nsage%K:%n /q nick querys nick';
@ahelp.bans='%Wu%nsage%K:%n /bans shows current banlist on channel';
@ahelp.wii='%Wu%nsage%K:%n /wii <nick> server side whois for specified nick';
@ahelp.mdeop='%Wu%nsage%K:%n /mdeop <nick1>,<nick2>,<nick3> <...> mass deops current channel minus nicks specified.';
@ahelp.dv='%Wu%nsage%K:%n /dv <nick> devoices nick';
@ahelp.v='%Wu%nsage%K:%n /v <nick> voices nick';
@ahelp.scano='%Wu%nsage%K:%n /scano scans for current ops on channel';
@ahelp.scanv='%Wu%nsage%K:%n /scanv scans for current voiced on channel';
@ahelp.scann='%Wu%nsage%K:%n /scann scans for current non op/voiced on channel';
@ahelp.t='%Wu%nsage%K:%n /t sets topic for current channel';
@ahelp.k='%Wu%nsage%K:%n /k <nick1>,<nick2> <reason> kicks nick(s) with reason';
@ahelp.umode='%Wu%nsage%K:%n /umode <mode> changes user mode ';
@ahelp.m='%Wu%nsage%K:%n /m nick <msg> msgs nick with msg';
@ahelp.j='%Wu%nsage%K:%n /j channel joins channel';
@ahelp.l='%Wu%nsage%K:%n /l leaves current channel';
@ahelp.wi='%Wu%nsage%K:%n /wi <nick> whois nick';
@ahelp.ver='%Wu%nsage%K:%n /ver nick ctcp versions nick';
@ahelp.c='%Wu%nsage%K:%n /c <mode> changes mode on current channel ';
@ahelp.nochat='%Wu%nsage%K:%n /nochat <nick> dcc closes chat with nick';
@ahelp.chat='%Wu%nsage%K:%n /chat <nick> sends dcc chat request to nick';
@ahelp.bk='%Wu%nsage%K:%n /bk <nick1>,<nick2> <reason> bankicks nick(s) for reason';
@ahelp.op='%Wu%nsage%K:%n /op <nick> ops nick on current channel';
@ahelp.voice='%Wu%nsage%K:%n /voice <nick> voices nick on current channel';
@ahelp.deop='%Wu%nsage%K:%n /deop <nick> deops nick on current channel';
@ahelp.mop='%Wu%nsage%K:%n /mop <nick1> <nick2> <nick3> <...> mass ops current channel, skipping specified nicks';
@ahelp.cycle='%Wu%nsage%K:%n /cycle leaves then joins current channel';
@ahelp.mreop='%Wu%nsage%K:%n /mreop mass ops current ops on channel';
@ahelp.readlog='%Wu%nsage%K:%n /readlog reads away log';
@ahelp.wall='%Wu%nsage%K:%n /wall <msg> mass notices current ops on channel';
@ahelp.sv='%Wu%nsage%K:%n /sv shows current client/script version to channel';
@ahelp.away='%Wu%nsage%K:%n /away set yourself away';
@ahelp.back='%Wu%nsage%K:%n /back turns away off.';
@ahelp.format='%Wu%nsage%K:%n /format <letter> <number> changes format letter to #';
@ahelp.config='%Wu%nsage%K:%n /config <letter> <setting> changes config letter to #';
@ahelp.color='%Wu%nsage%K:%n /color <color1> <color2> <color3> <color4> changes color to desired colors';
@ahelp.sbcolor='%Wu%nsage%K:%n /sbcolor <color1> <color2> <color3> <color4>  changes sbar color to desired colors';
@ahelp.v='%Wu%nsage%K:%n /v <nick> voices nick';
@ahelp.saveall = '%Wu%nsage%K:%n /saveall saves all settings';
@ahelp.fsave = '%Wu%nsage%K:%n /fsave saves all format settings';
@ahelp.sbar = '%Wu%nsage%K:%n /sbar <number> changes sbar to desired number';
@ahelp.scan = '%Wu%nsage%K:%n /scan scans current channel for nicks';
@ahelp.wk = '%Wu%nsage%K:%n /wk kills current window';
@ahelp.wlk = '%Wu%nsage%K:%n /wlk leaves channel and kills window';
@ahelp.wn = '%Wu%nsage%K:%n /wn changes to next window';
@ahelp.wp = '%Wu%nsage%K:%n /wp changes to previous window';
@ahelp.wj = '%Wu%nsage%K:%n /wj <channel> opens up new window and joins channel specified';
@ahelp.wc = '%Wu%nsage%K:%n /wc creates new window';
@ahelp.frelm = '%Wu%nsage%K:%n /frelm <fakenick> <channel> <text to fake> fakes recvied msg and pastes it to channel';
@ahelp.freln = '%Wu%nsage%K:%n /freln <fakenick> <channel> <text to fake> fakes recvied notice and pastes it to channel';
@ahelp.csave = '%Wu%nsage%K:%n /csave saves color settings';
@ahelp.format = '%Wu%nsage%K:%n  /format <choice> <num> changes format number to selected format';
@ahelp.sping = '%Wu%nsage%K:%n  /sping <server> pings server and returns lag time to it';
@ahelp.stalker = '%Wu%nsage%K:%n  /stalker does a /common for every channel you are in against the current channel';
@ahelp.ub = '%Wu%nsage%K:%n  /ub <nick> ub by itself will clear all bans on current channel , /ub nick will unban nick from current channel';
@ahelp.dns = '%Wu%nsage%K:%n /dns <nick> domain nameserver request to given nick';
@ahelp.nslookup = '%Wu%nsage%K:%n /nslookup <ip> domain nameserver request to given ip';
@ahelp.orignick = '%Wu%nsage%K:%n /orignick will check the specified nick for the amount of seconds you specify in the config. (default is 3) and change to it when that nick signs off';
@ahelp.fkeys = '%Wu%nsage%K:%n /fkeys shows which fkeys are bound to which and can be changed by /fkey1 <command> /fkey2 <command>... ';
@ahelp.mkn = '%Wu%nsage%K:%n /mkn text will kick all non oped from channel';
@ahelp.mko = '%Wu%nsage%K:%n /mko text will kick all ops from channel';
@ahelp.massk = '%Wu%nsage%K:%n /massk <version string> will kick all users from the channel with specified version string';
@ahelp.bkh = '%Wu%nsage%K%n /bkh nick will ban nick with bantype host from current channel';
@ahelp.bkn = '%Wu%nsage%K%n /bkn nick will ban nick with bantype normal from current channel';
@ahelp.bkb = '%Wu%nsage%K%n /bkb nick will ban nick with bantype better from current channel';
@ahelp.bkd = '%Wu%nsage%K%n /bkd nick will ban nick with bantype domain from current channel';
@ahelp.ban = '%Wu%nsage%K:%n /ban nick will ban nicks userhost from current channel';
@ahelp.fkey = '%Wu%nsage%K:%n /fkey <#1-12> will set function keys to specified command';
@ahelp.fset = '%Wu%nsage%K:%n /fset format_choice will change specified format';
@ahelp.bantype = '%Wu%nsage%K:%n /bantype Usage: /bantype <Normal|Better|Host|Domain|> - When a ban is done on a nick, it uses <bantype>';
@ahelp.banstat = '%Wu%nsage%K:%n /banstat Usage: /banstat will show current bans on channel, who set them and what time they were set';

@hwords ="";
foreach ahelp xx {
	push hwords $tolower($xx);
};
@hwords= sort($hwords);
alias ahelp {
	if (!@) {
xecho -v -- ---------------------------------------------------------------------;
	@:_ohcenter=word(0 $geom()) / 2 + 40;
	aecho  | $center($_ohcenter a m n e s i a c   h e l p) $[14]{" "}|;
	@:_ohwidth=word(0 $geom()) / 14;
	@:_htopics ='';
	@:_htopics2 ='';
	fe ($jot(1 $_ohwidth)) n1 {
		push _htopics n$n1;
		push _htopics2 %K[%n$$[10]\{n$n1\}%K];
	};
	push _htopics2 %w|;
	fe ($hwords) $_htopics {
		xecho -v  | $cparse(${**_htopics2});
	};
xecho -v -- ---------------------------------------------------------------------;
	abecho $a.ver usage -> /ahelp <helpword>;
	}{

	if (@) {
	xecho -v -- ---------------------------------------------------------------------;
		if (!match($0 $hwords)) {
			xecho $acban command: $0 not found;
		}{
			//echo $cparse("$(ahelp.$*)");
		};
xecho -v -- ------------------------------------------------------------------;
	};
};
};
