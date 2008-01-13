# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# TODO: convert to pf-loader
subpackage xy

alias xy msg x@channels.undernet.org $*
alias xlogin xy login $*
alias xaccess xy access $*
alias xca xy access $C $*
alias xbl xy lbanlist $*
alias xcbl xy lbanlist $C $*
alias xpart xy part $*
alias xset xy set $*
alias xcset xy set $C $*
alias xajoin xy set $C autojoin $*
alias xmdeop xy set $C massdeoppro $*
alias xnoop xy set $C noop $*
alias xstrictop xy set $C strictop $*
alias xjoin xy join $*
alias xatopic xy set $C autotopic $*
alias xtopic xy topic $C $*
alias xdesc xy set $C desc $*
alias xfloat xy set $C floatlim $*
alias xfgrace xy set $C floatgrace $*
alias xfmargin xy set $C floatmargin $*
alias xfmax xy set $C floatmax $*
alias xfperiod xy set $C floatperiod $*
alias xkeyword xy set $C keywords $*
alias xurl xy set $C url $*
alias xflag xy set $C userflags $*
alias xadduser xy adduser $C $*
alias xclear xy clearmode $*
alias xmod xy modinfo $*
alias xrmuser xy remuser $*
alias xkick xy kick $*
alias xstatus xy status $*
alias xop xy op $*
alias xdeop xy deop $*
alias xban xy ban $*
alias xunban xy unban $*
alias xdevoice xy devoice $*
alias xdv xy devoice $*
alias xvoice xy voice $*
alias xv xy voice $*
alias xinvite xy invite $*
alias xsuspend xy suspend $*
alias xunsuspend xy unsuspend $*
alias xbanlist xy banlist $*
alias xbans xy banlist $C
alias xchaninfo xy chaninfo $*
alias xinfo xy info $*
alias xisreg xy isreg $*
alias xmotd xy motd
alias xsearch xy search $*
alias xinvisible xy set invisible $*
alias xlang xy set lang $*
alias xscommands xy showcommands $*
alias xsignore xy showignore $*
alias xsupper xy support $*
alias xverify xy verify $*

alias xyhelp {
//echo -----------------------= XY Services Help =----------------------

//echo xy	msgs x directly on undernet
//echo xlogin <user> <password> logs into x
//echo xaccess <channel> queries access list of channel
//echo xbl <chan> <mask> queries banlist
//echo xpart <chan> will tell x to part specified chan
//echo xset <chan> <variable> <value> set various options
//echo xajoin <value> change autojoin settings for current chan
//echo xmdeop <value> change number of deops x allows in 15secs for current chan
//echo xnoop set current chan to no-ops
//echo xstrictop set strictops on current chan
//echo xjoin <chan> tells x to join specified chan
//echo xatopic <value> change autotopic settings for current chan
//echo xtopic <topic> x will set specified topic for current chan
input_char "menu paused hit the ANY key to continue"
pause
//echo xdesc <chan> <desc> will change description of specified chan
//echo xfloat <value> set floatlimit for current chan
//echo xkeyword <keyword> set keyword for current chan
//echo xurl <url> set url for current chan
//echo xflag determine automode for new users for current chan
//echo xadduser <username> <access> will add user for current chan
//echo xclear <chan> clears all channel modes for specified chan
//echo xrmuser <chan> <user> removes user from the database
//echo xkick <chan> <nick> <reason> x will kick user
//echo xstatus <chan> verbose status info about specified chan.
//echo xop <chan> <nick> tells x to op specified chan/user
//echo xdeop <chan> <nick> tells x to deop specified chan/user
//echo xban <chan> <nick|*!*user@*.host> [duration] [level] [reason]
input_char "menu paused hit the ANY key to continue"
pause
//echo xunban <chan> <*!*user@*.host>
//echo xvoice <chan> <nick> voices users
//echo xdv <chan> <nick> devoice users
//echo xinvite <chan> invites you to specified chan
//echo xsuspend <chan> <user> <duration> [level]
//echo xunsuspend <chan> <user>
//echo xchaninfo <chan> view info about specified chan (if registered)
//echo xinfo <user> display info about specified user
//echo xsearch <search parameter> list channels within the parameters
//echo xisreg <chan> checks if specified chan is registered
//echo xinvisible <value> toggle visibility status for your username
//echo xscommands <chan> show available cmds for specified chan
//echo xsignore show x's ignore list.
//echo xverify <user> verify's various user info.

//echo -----------------------------------------------------------------
}
