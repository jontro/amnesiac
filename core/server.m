# Copyright (c) 2003-2007 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};

subpackage server;

## aliases
alias svrtime {time $S;};
alias disco {disconnect $*;};

## first crack at aliases for multiserver/connection/modifying etc..
alias svlist server;
alias sadd {server -add $*;};
alias sdel {server -delete $*;};
alias snick {server -add $0:6667::$1-;};
alias ssl {server -add $0:::::IRC-SSL;};
alias snext {server +;};
alias sprev {server -;};

## multiserv stuff.
alias wcs {
	if (@) {
		^window new server $0 hide swap last channel "$channame($1) $2-";
	}{
		xecho $acban usage: /wcs server channel key;
	};
};
alias _maxmodes {
  ^local num;
  @ num = serverctl(get $servernum() 005 MODES);

  if (ceil($num) != num) {
    @num=3;
  };
  if (num < 1) {
    @num=3;
  };
  if (num > 10) {
    @num=10;
  };
   return $num;
};

alias wns {wcs $*;};

## Newnick from src/epic5/scripts by BlackJac.
## Copyright (c) 2005 David B. Kratter (BlackJac@EFNet)

alias newnick.mangle (nick, void) {
	@ :length = getset(auto_new_nick_length);
	return ${@nick < length ? nick ## getset(auto_new_nick_char) : right(1 $nick) ## mid(0 ${length - 1} $nick)};
};

^on ^new_nickname "*" {
	if (getset(auto_new_nick) == 'on') {
		if ( @(:nicklist = getset(auto_new_nick_list)) ) {
			if (!(:nick = word(${findw($2 $nicklist) + 1} $nicklist))) {
				@ :nick = newnick.mangle($2);
			};
		} else {
			@ :nick = newnick.mangle($2);
		};
		xeval -s $0 nick $nick;
	} else {
		input "Nickname: " {
			nick $0;
		};
	};
};

## motd suppressions. taken from src/epic5/scripts written by
## Jeremy Nelson
@ negser = getserial(HOOK - 0);
@ posser = getserial(HOOK + 0);

# The first time we see the MOTD, trigger the "doing motd" flag.
on #^375 $negser * {
	if (!done_motd[$lastserver()]) {
		^assign doing_motd[$lastserver()] 1;
	};
};
# When we see the end of the first MOTD, trigger the "done motd" flag.
on #^376 $posser * {
	if (doing_motd[$lastserver()]) {
		^assign -doing_motd[$lastserver()];
		^assign done_motd[$lastserver()] 1;
	};
};
# When the connection is closed, reset the flag.
on #^server_lost $posser * {
	^assign -done_motd[$lastserver()];
};

# Only suppress the first MOTD from each server connection.
for i in (372 375 376 377) { 
	on ^$i * {
		if (getset(suppress_server_motd) == 'ON' && doing_motd[$lastserver()]) {
			return;
		};
		xecho -b $1-;
	};
};
## hop'y2k+3

alias svhelp servhelp;
alias servhelp {
        if (!@) {    

//echo ---------------------= Server Usage Help =-------------------------;
//echo svlist    /svlist views currently available servers.;
//echo sadd      /sadd <server> adds the given server to the server list;
//echo snick     /snick <server> <nick> add the given server to the server list;
//echo		   with specified nick;
//echo ssl       /ssl <server> add the given server as type ssl to the server list;
//echo snext     /snext To switch to the next server in your list;
//echo sprev     /sprev To switch to the previous server in your list;
//echo ---------------------------------------------------------------------;
        };
};
