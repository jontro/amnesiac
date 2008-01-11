# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# Make amnesiac behave a bit more like default epic with tc and netsplit
# loaded, just the way skullY likes it.
subpackage vanilla

@ bindctl(sequence ^D set parse_command listsplit)
@ bindctl(sequence ^E set end_of_line)
@ bindctl(sequence ^P set parse_command window prev)
@ bindctl(map ^W clear)

window -1 level ALL

alias echo xecho -v $*
alias sc {
	if ([$*]) {
		names $*
	}{
		names $C
	}
}
