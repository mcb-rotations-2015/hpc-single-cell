deps:
	$(MAKE) -C 3rdparty

PAML_TEMP_FILES = 2NG.dN 2NG.dS 2NG.t 4fold.nuc lnf rst rst1 rub
clean:
	rm -f $(PAML_TEMP_FILES)
