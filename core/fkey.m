# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage fkey;

alias fkeys {
	//echo ----------------------------= function keys =-----------------------;
	fe ($jot(1 12)) aa bb {
		//echo $pad(3 " " f$aa) $([25]fke$aa)		| $pad(3 " " f$bb) $([25]fke$bb);
	};
	//echo;
	//echo fkey <1-12> <command>;
	//echo ---------------------------------------------------------------------;
};

alias fkey {
	if (!@) {
		load $(loadpath)ans/fkeys.ans;
	}{
		switch ($0) {
		(1) {
			if (!'$1') {
				xecho $acban function key 1 set to $fke1;
			}{
				@fke1 = "$1-";
					^bind ^[[11~ parse_command $fke1;
					^bind ^[[[A parse_command $fke1;
					^bind ^[OP parse_command $fke1;
						xecho $acban function key 1 set to $fke1;
			}
			};
			(2) {
				if (!'$1') {
					xecho $acban function key 2 set to $fke2;
			}{
				@fke2 = "$1-";
					^bind ^[[12~ parse_command $fke2;
					^bind ^[[[B parse_command $fke2;
       					^bind ^[OQ parse_command $fke2;
						xecho $acban function key 2 set to $fke2;
			}
			};
			(3) {
				if (!'$1') {
					xecho $acban function key 3 set to $fke3;
			}{
				@fke3 = "$1-";
					^bind ^[[13~ parse_command $fke3;
					^bind ^[[[C parse_command $fke3;
       					^bind ^[OR parse_command $fke3;
						xecho $acban function key 3 set to $fke3;
			}
			};
			(4) {
				if (!'$1') {
					xecho $acban function key 4 set to $fke4;
			}{
				@fke4 = "$1-";
					^bind ^[[14~ parse_command $fke4;
					^bind ^[[[D parse_command $fke4;
	        			^bind ^[OS parse_command $fke4;
						xecho $acban function key 4 set to $fke4;
			}
			};
			(5) {
				if (!'$1') {
					xecho $acban function key 5 set to $fke5;
			}{
				@fke5 = "$1-";
					^bind ^[[15~ parse_command $fke5;
					^bind ^[[[E parse_command $fke5;
		        			xecho $acban function key 5 set to $fke5;
			}
			};
			(6) {
                		if (!'$1') {
					xecho $acban function key 6 set to $fke6;
			}{
				@fke6 = "$1-";
					^bind ^[[17~ parse_command $fke6;
		        			xecho $acban function key 6 set to $fke6;
			}
			};
			(7) {
				if (!'$1') {
					xecho $acban function key 7 set to $fke7;
			}{
				@fke7 = "$1-";
					^bind ^[[18~ parse_command $fke7;
						xecho $acban function key 7 set to $fke7;
			}
			};
			(8) {
				if (!'$1') {
					xecho $acban function key 8 set to $fke8;
			}{
				@fke8 = "$1-";
					^bind ^[[19~ parse_command $fke8;
        					xecho $acban function key 8 set to $fke8;
			}
			};
			(9) {
				if (!'$1') {
					xecho $acban function key 9 set to $fke9;
			}{
				@fke9 = "$1-";
					^bind ^[[20~ parse_command $fke9;
		        			xecho $acban function key 9 set to $fke9;
			}
			};
			(10) {
				if (!'$1') {
					xecho $acban function key 10 set to $fke10;
			}{
				@fke10 = "$1-";
					^bind ^[[21~ parse_command $fke10;
		        			xecho $acban function key 10 set to $fke10;
			}
			};
			(11) {
				if (!'$1') {
					xecho $acban function key 11 set to $fke11;
			}{
				@fke11 = "$1-";
					^bind ^[[23~ parse_command $fke11;
		        			xecho $acban function key 11 set to $fke11;
			}
			};
			(12) {
				if (!'$1') {
					xecho $acban function key 12 set to $fke12;
			}{
				@fke12 = "$1-";
					^bind ^[[24~ parse_command $fke12;
		        			xecho $acban function key 12 set to $fke12;
			}
			};
		};
	};
};

@ bindctl(sequence ^[[[A set parse_command $fke1);
@ bindctl(sequence ^[OP set parse_command $fke1);
@ bindctl(sequence ^[[11~ set parse_command $fke1);
@ bindctl(sequence ^[[[B set parse_command $fke2);
@ bindctl(sequence ^[OQ set parse_command $fke2);
@ bindctl(sequence ^[[12~ set parse_command $fke2);
@ bindctl(sequence ^[[[C set parse_command $fke3);
@ bindctl(sequence ^[OR set parse_command $fke3);
@ bindctl(sequence ^[[13~ set parse_command $fke3);
@ bindctl(sequence ^[[[D set parse_command $fke4);
@ bindctl(sequence ^[OS set parse_command $fke4);
@ bindctl(sequence ^[[14~ set parse_command $fke4);
@ bindctl(sequence ^[[[E set parse_command $fke5);
@ bindctl(sequence ^[[15~ set parse_command $fke5);
@ bindctl(sequence ^[[17~ set parse_command $fke6);
@ bindctl(sequence ^[[18~ set parse_command $fke7);
@ bindctl(sequence ^[[19~ set parse_command $fke8);
@ bindctl(sequence ^[[20~ set parse_command $fke9);
@ bindctl(sequence ^[[21~ set parse_command $fke10);
@ bindctl(sequence ^[[23~ set parse_command $fke11);
@ bindctl(sequence ^[[24~ set parse_command $fke12);
