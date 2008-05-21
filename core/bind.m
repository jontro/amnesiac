# Copyright (c) 2003-2008 Amnesiac Software Project. 
# See the 'COPYRIGHT' file for more information.     
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage binds;

## binds
alias breset {bind -defaults;};

## tis not proper place? -Rylan
alias switchtarget {
	if (@winchan()) {
		parsekey switch_channels;
	} else {
  		parsekey switch_query;
	};
};

@ bindctl(sequence ^F set self_insert);
@ bindctl(sequence ^W set parse_command window next);
@ bindctl(sequence ^P set parse_command window prev);
@ bindctl(sequence ^R set scroll_end);
@ bindctl(sequence ^K set parse_command {@:cur = pop(invchan);if (@cur) {^join $cur};};);
@ bindctl(sequence ^X set parse_command switchtarget);
@ bindctl(sequence ^G set self_insert);
@ bindctl(sequence ^Z set parse_command retard);
@ bindctl(sequence ^Wd set next_window);
@ bindctl(sequence ^[$chr(27)[D set parse_command window previous);
@ bindctl(sequence ^[$chr(27)[C set parse_command window next);

## CID stuff.
^bind ^[y parse_command {accept $pop(cidreq);};

## home/end on some terms.
@ bindctl(sequence ^[[1~ set scroll_start);
@ bindctl(sequence ^[[4~ set scroll_end);

## window binds. screen like binds for xavier.
@ bindctl(sequence ^W1 set parse_command ^window swap 1);
@ bindctl(sequence ^W2 set parse_command ^window swap 2);
@ bindctl(sequence ^W3 set parse_command ^window swap 3);
@ bindctl(sequence ^W4 set parse_command ^window swap 4);
@ bindctl(sequence ^W5 set parse_command ^window swap 5);
@ bindctl(sequence ^W6 set parse_command ^window swap 6);
@ bindctl(sequence ^W7 set parse_command ^window swap 7);
@ bindctl(sequence ^W8 set parse_command ^window swap 8);
@ bindctl(sequence ^W9 set parse_command ^window swap 9);
@ bindctl(sequence ^W0 set parse_command ^window swap 10);
@ bindctl(sequence ^Wa set parse_command ^window swap last);
@ bindctl(sequence ^Wc set parse_command wc);
@ bindctl(sequence ^W^c set parse_command wc);
@ bindctl(sequence ^Wk set parse_command window killswap);
@ bindctl(sequence ^Wl set parse_command window list);
@ bindctl(sequence ^Wn set swap_next_window);
@ bindctl(sequence ^Wp set swap_previous_window);
@ bindctl(sequence ^W^ set swap_next_window);
@ bindctl(sequence ^WC set parse_command clear all);
@ bindctl(sequence ^W^X set parse_command window swap last);
@ bindctl(sequence $chr(27 167) set parse_command ^_wsact);

@ bindctl(sequence meta1-a set ^swap_next_window);

## some other kinda weird bindings for some terms/others
@ bindctl(sequence ^[^I set PARSE_COMMAND ^window next);
@ bindctl(sequence ^[1 set PARSE_COMMAND ^window swap 1);
@ bindctl(sequence ^[2 set PARSE_COMMAND ^window swap 2);
@ bindctl(sequence ^[3 set PARSE_COMMAND ^window swap 3);
@ bindctl(sequence ^[4 set PARSE_COMMAND ^window swap 4);
@ bindctl(sequence ^[5 set PARSE_COMMAND ^window swap 5);
@ bindctl(sequence ^[6 set PARSE_COMMAND ^window swap 6);
@ bindctl(sequence ^[7 set PARSE_COMMAND ^window swap 7);
@ bindctl(sequence ^[8 set PARSE_COMMAND ^window swap 8);
@ bindctl(sequence ^[9 set PARSE_COMMAND ^window swap 9);
@ bindctl(sequence ^[0 set PARSE_COMMAND ^window swap 10);

## history script binds
@ bindctl(function BACKWARD_HISTORY create "history.get -1");
@ bindctl(function ERASE_HISTORY create history.erase_line);
@ bindctl(function FORWARD_HISTORY create "history.get 1");
@ bindctl(function SHOVE_TO_HISTORY create history.shove);
@ bindctl(sequence ^U set erase_history);
## history script func binds
fe (N [OB [[B) hh {
        @ bindctl(sequence ^$hh set forward_history);
};

fe (P [OA [[A) hh {
        @ bindctl(sequence ^$hh set backward_history);
};
