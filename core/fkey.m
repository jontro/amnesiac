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

alias fkey (key, command) {
	if ( ! @key ) {
		fkeys;
	}{
		if ( @command ) {
			@ fke$key = command;
			if (key < 6) {
				@ bindctl(sequence ^[[${10+key}~ set parse_command $command);
				@ bindctl(sequence ^[[[$chr(${64+key}) set parse_command $command);
				@ bindctl(sequence ^[O$chr(${79+key}) set parse_command $command);
			} else if (key < 11) {
				@ bindctl(sequence ^[[${11+key}~ set parse_command $command);
			}{
				@ bindctl(sequence ^[[${12+key}~ set parse_command $command);
			};
		};
		xecho -s $acban function key $key set to $(fke$key);
	};
};

for (@aa=1, aa <= 12, @aa = aa +1 ) {
	^fkey $aa $(fke$aa);
};
