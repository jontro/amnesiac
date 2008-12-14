# Copyright (c) 2003-2008 Amnesiac Software Project.
# Copyright (c) 2007 hokkaido <jzzskijj gmail com>
# See the 'COPYRIGHT' file for more information.

if (word(2 $loadinfo()) != [pf]) {
        load -pf $word(1 $loadinfo());
        return;
};

subpackage utf8;

## sets
addset encode_utf8_to_latin bool;
set encode_utf8_to_latin off;

## alias
alias utf8 {set encode_utf8_to_latin toggle;};

## hooks
on ^msg "*" { //echo $fparse(format_msg $0 $userhost() $_utf_to_latin($1-)); };
on ^public "*" (nick,chan,text) { //echo $fparse(format_public $nick:$chan $_utf_to_latin($text)); };
^on ^notice * { xecho $fparse(format_notice $0 $userhost() $_utf_to_latin($1-)); };

on ^action "*" (sender, recvr, body) {
        if (winchan($recvr)) {
                if (iscurchan($recvr)) {
                        xecho $fparse(format_action $sender $recvr $_utf_to_latin($body));
                } {
                        xecho $fparse(format_action_other $sender $recvr $_utf_to_latin($body));
                };
        } {
                xecho $fparse(format_desc $sender $recvr $_utf_to_latin($body));
        };
};

^on ^332 * {xecho -b $fparse(format_settopic $_utf_to_latin($1-));};
^on ^topic * {
        if (! @*2) {
                xecho -b Topic unset by $0 on $1 at $strftime(%a %b %d %T %Z);
        }{
                xecho -b $fparse(format_topic $0 $1 $_utf_to_latin($2-));
        };
};


## funcs
alias _utfc2latin (pos, text) {
	# Remove 0xC2 character.
	return $(mid(0 ${pos} $text))$(mid(${pos+1} $strlen($text) $text));
};

alias _utfc3latin (pos, text) {
	# Remove 0xC3 character and increment the value of left char with 64.
	return $(mid(0 ${pos} $text))$(chr(${ascii($mid(${pos+1} 1 $text))+64}))$(mid(${pos+2} $strlen($text) $text));
};

alias _utf_to_latin (text) {
	if (getset(encode_utf8_to_latin) == "off") {
		return $text;
	};

	@:strpos = 0;
	while (strpos <= strlen($text)) {
		@:pos = index($chr(194) $mid($strpos ${strlen($text)-strpos} $text));
		if (pos > -1) {
			@:pos += strpos;
			@:val = ascii($mid(${pos+1} 1 $text));
			if (val >= 128 && val <= 191)
			{
				@:text = {_utfc2latin $pos $text};
			};
		} else {
			@:pos = index($chr(195) $mid($strpos ${strlen($text)-$strpos} $text));
			if (pos > -1) {
				@:pos += strpos;
				@:val = ascii($mid(${pos+1} 1 $text));
				if (val >= 128 && val <= 191) {
					@:text = {_utfc3latin $pos $text};
				};
			};
		};

		if (pos == -1) {
			break;
		} else {
			@:strpos = pos + 1;
		};
        };

	return $text;
};
