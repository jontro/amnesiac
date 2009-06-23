# Copyright (c) 2003-2008 Amnesiac Software Project.
# See the 'COPYRIGHT' file for more information.
# Thanks to hop for providing this script
if (word(2 $loadinfo()) != [pf]) {
	load -pf $word(1 $loadinfo());
	return;
};
subpackage linedrawing;

@ld.e = '';
@ld.asc_chars = getcap(TERM acs_chars 0 0);

# Hard coded vars for ibm437. Above does not play well with status bars
@ld.asc_chars ="j$chr(217)k$chr(191)l$chr(218)m$chr(192)q$chr(196)t$chr(195)u$chr(180)v$chr(193)w$chr(194)x$chr(179)~$chr(250)";
@ld.e = '';
fec ($ld.asc_chars) vt cme {
	@:me="${ld.e}${cme}${ld.e}";
	switch ($vt) {
		(w) { @:cVar ='tee_down'; };
		(u) { @:cVar ='tee_left'; };
		(t) { @:cVar ='tee_right'; };
		(v) { @:cVar ='tee_up'; };
		(l) { @:cVar ='ul_corner'; };
		(k) { @:cVar ='ur_corner'; };
		(m) { @:cVar ='ll_corner'; };
		(j) { @:cVar ='lr_corner'; };
		(x) { @:cVar ='vline'; };
		(q) { @:cVar ='hline'; };
		(~) { @:cVar ='smalldot'; };
	};
	@ld[$cVar]=me;
	@ld[$(cVar)_e]=cme;
};
