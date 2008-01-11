# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage ehelp;

alias ehelp {
//echo	-------------------------= Extended Help =----------------------------;

	//echo uhelp    <userlist help>   userlist help menu.             [module];
	//echo awayhelp <away help>       away module help menu.          [module];
	//echo shelp    <shitlist help>   shitlist help menu.             [module];
	//echo urlhelp  <urlgrab help>    urlgrab help menu.              [module];
	//echo mmhelp   <multi-matrix help> bwk/ptrap/misc help menu.     [module];
	//echo mjhelp   <mjoin help>      mjoin/ajoin help menu.          [module];
	//echo abhelp   <abot help>       autobot help menu.              [module];
	//echo ohelp    <oper help>       operview/oper help menu         [module];
	//echo rhelp    <relay help>      relay/paste help menu.          [module];
	//echo svhelp   <services help>   nserv/cserv/etc.. help menu.    [module];
	//echo xyhelp   <xy services>     undernet x service help menu.   [module];
	//echo chelp    <config help>     config shortcut help menu.      [core];
	//echo cidhelp  <cid help>        cid/accept (umode +g) help.     [core];
input_char "menu paused hit the ANY key to continue";
pause;
	//echo fhelp    <look/feel help>  amnesiac look/feel help menu.   [core];
	//echo ghelp    <general help>    general client/user cmds help.  [core];
	//echo svhelp   <server help>     server/connection help cmds.    [core];
	//echo mhelp    <module help>     module help menu.               [core];
	//echo winhelp  <window help>     window shortcuts help menu.     [core];
	//echo dcchelp  <dcc help>        dcc usage/binds help menu.      [core];
	//echo smhelp   <special modes>   exempt modes cmds help menu.    [core];
	//echo thelp    <trickle help>    the irc swiss army knife menu.  [core];
//echo	----------------------------------------------------------------------;
};

alias ghelp genhelp;
alias genhelp {
//echo ---------------------= General Usage Help =-------------------------;
//echo ign     /ign [nick|nick!ident@host] [type] will ignore someone;
//echo type: can be 1 or more options of notice,msg,dcc,crap,public,all;
//echo tig     /tig # removes specified ignore.;
//echo cig     /cig <channel> to ignore public from current or specified channel.;
//echo umode   /umode <mode> changes user mode.;
//echo ircname /ircname <text> will change your realname on next connect.;
//echo arejoin /arejoin will toggle auto_rejoin on/off;
//echo aww     /aww will toggle auto_whowas on/off;
//echo topic   /topic <tab> will insert current topic for editing.;
//echo away    /away set yourself away.;
//echo back    /back set yourself back.;
//echo readlog /readlog reads away msgs. [requires away module];
//echo remlog  /remlog erase away msgs.  [requires away module];
input_char "menu paused hit the ANY key to continue ";
pause;
//echo orignick /orignick <nick> will attempt to regain(jupe) specified nick;
//echo every 3 seconds(default) unless you specify time in /config. [orignick module];
//echo staynick /staynick will cancel /orignick [orignick module];
//echo tld     /tld <country-code> will show you the country for that TLD;
//echo notify  /notify <nick> will add specified nick to notify list;
//echo /notify -<nick> will remove specified nick from notify list;
//echo /notify will view online/offline nicks if any.;
//echo ---------------------------------------------------------------------;
};

alias fhelp lfhelp;
alias lfhelp {
//echo --------------------= Amnesiac Look/Feel Help =---------------------------;
//echo config  /config will list currently available configuration options;
//echo           /config <letter> <setting> will change the specified option.;
//echo theme   /theme will display available themes and you can choose which;
//echo           one you want with /theme <name>;
//echo format  /format <letter/num> will display available format;
//echo           /format <letter/num> <num> will choose the specified format;
//echo sbcolor /sbcolor <color1> <color2> <color3> <color4> changes sbar colors;
//echo           to desired colors.;
//echo color   /color <color1> <color2> <color3> <color4> changes color to;
//echo           desired colors.;
//echo tsave   /tsave <theme> <description> will create a theme.;
//echo untheme /untheme will make amnesiac revert back to the default theme.;
input_char "menu paused hit the ANY key to continue ";
pause;
//echo fset    /fset format_choice will change specified format.;
//echo fkeys   /fkeys shows which fkeys are bound to which and can be changed by;
//echo           by /fkey 1 <command> /fkey 2 <command>;
//echo sbar    /sbar <number> changes sbar to desired number.;
//echo mw      /mw -hidden|split|kill <will create/kill a window bound to msgs>;
//echo extpub  /extpub <on|off> <will turn on/off <@nick> and <+nick> in public.;
//echo indent  /indent will indent on newline as opposed to linewrap.;
//echo ----------------------------------------------------------------------------;
};

alias chelp {
//echo ---------------------= Amnesiac Config Shortcuts =-----------------------;
//echo cumode   /cumode <mode> will set default usermode on connect.;
//echo stamp    /stamp <on|off> <will enable/disable timestamps>;
//echo modeshow /modeshow <on|off> <will turn on/off <@nick> and <+nick> in public.;
//echo extpub   /extpub same as /modeshow;
//echo resp     /resp <word> will highlight nick when specified word is said in;
//echo            public;
//echo kops     /kops <on|off> <will kick ops on ban>;
//echo otime    /otime <num> <set the orignick time in seconds>;
//echo awayt    /awayt <num> <set the auto-away time in minutes>;
//echo tform    /tform will display available timestamp formats and you can;
//echo          choose which one you want with /tform <num>;
//echo autoget  /autoget will attempt to grab files sent to you automatically.;
//echo bantype  /bantype <Normal|Better|Host|Domain|> when a ban is done on a nick;
//echo          it uses <bantype>;
//echo -------------------------------------------------------------------------;
};

alias cidhelp {
//echo ------------------------= CID Help =-----------------------;
//echo accept  /accept <nick> will accept msgs from specified nick;
//echo cid     /cid will show nicks accepted for msgs if any;
//echo clist   /clist will show nicks accepted for msgs if any;
//echo cdel    /cdel <nick> will remove specified nick;
//echo rmcid   /rmcid <nick> will remove specified nick;
//echo ------------------------------------------------------------;
};

alias winhelp {
//echo	--------------------= Windowing Help =-----------------------------;
	
		//echo wc  <window create>   creates new hidden window;
		//echo wj  <window join>     creates new hidden window and joins specified channel;
		//echo wk  <window kill>     kills current window;
		//echo wlk  <window leave kill> kills current window and parts channel;
		//echo cls  <clear screen>   clears notices/dcc/publics/etc in current window.;
		//echo wn  <window next>     window next switches to next hidden window;
		//echo wp  <window prev>     switches to previous hidden window;
		//echo mv  <msg window>  -hidden|split|kill <will create/kill a window bound to msgs>;
		//echo wq  <window query>    /wq nick creates a query window with the nick;
		//echo wka  <window kill all_hidden> attempts to kill all hidden windows.;
		//echo wko  <window kill others> attempts to kill other windows on the screen if visible.;
		//echo wsl  <window swap last>  swaps to your last window.;
		input_char "menu paused hit the ANY key to continue ";
		pause;
		//echo wsa  <window swap act> swaps to your activity window(s) from statbar. ie: act(3,4);
		//echo wl  <window list>     lists windows in use;
		//echo wsg  <window grow>    grows current window ie: /wsg 7;
		//echo wss  <window shrink>  shrinks current window ie: /wss 7;
		//echo 1-25  <swap windows>  swap windows ie: /1 for window 1 /2 for window 2 etc..;
		//echo wlog  <window log>    toggles window logging;
		//echo wflush <window flush> window flush the scroll back epic5-0.0.6 and higher.;
	    	//echo wlevel  <window levels>  changes level of current window;
		//echo msgwin  <msg window>  wsl's then it wc's a window bound to msgs,notices;
		//echo BINDS: ESC: <num> ALT: <num> ^W<func> <-- like unix screen cmds;
		//echo Above info mentions alternative ways to swap windows;
//echo	---------------------------------------------------------------------------;
};
