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
fec ($ld.asc_chars) vt cme {
	@:me="${ld.e}${cme}${ld.e}";
	switch ($vt) {
		(w) { @ld.tee_down = me; };
		(u) { @ld.tee_left = me; };
		(t) { @ld.tee_right = me; };
		(v) { @ld.tee_up = me; };
		(l) { @ld.ul_corner = me; };
		(k) { @ld.ur_corner = me; };
		(m) { @ld.ll_corner = me; };
		(j) { @ld.lr_corner = me; };
		(x) { @ld.vline = me; };
		(q) { 
			@ld.hline = me; 
			@ld.hline_e = cme; 
		};
		(~) { @ld.smalldot = me; };
	};
};
