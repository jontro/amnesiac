alias ctcpform (number) {
	if (@number) {
		@format.setformat(ctcp $number ctcp);
	}{
		@format.printformats(ctcp o ctcp);
	};
};

alias sctcpform (number) {
	if (@number) {
		@format.setformat(send_ctcp $number send ctcp);
	}{
		@format.printformats(send_ctcp p send ctcp);
	};
};
