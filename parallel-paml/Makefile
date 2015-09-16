TARBALL := paml4.8a.tgz
TAR_DIR := paml4.8
SRC_DIR := $(TAR_DIR)/src
BIN_DIR := $(TAR_DIR)/bin
BIN_FILES := baseml basemlg codeml pamp evolver yn00 chi2
BIN_PATHS := $(addprefix $(SRC_DIR)/,$(BIN_FILES))

install : $(BIN_FILES)

# Link to the binary files from the working directory
.SECONDEXPANSION:
$(BIN_FILES) : $(SRC_DIR)/$$@
	ln -S $@ $<

# Unpack and compile
$(BIN_PATHS) : $(TARBALL)
	tar -xvzpf $<
	$(MAKE) -C $(SRC_DIR)

# Fetch the tarball
$(TARBALL) :
	wget http://abacus.gene.ucl.ac.uk/software/$(TARBALL)

clean :
	rm -f $(BIN_FILES)
#rm -rf $(TAR_DIR)

.PHONY : install clean
