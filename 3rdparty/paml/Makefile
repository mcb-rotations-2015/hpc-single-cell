TARBALL := paml4.8a.tgz
TAR_DIR := paml4.8
SRC_DIR := $(TAR_DIR)/src
BIN_DIR := $(TAR_DIR)/bin
BIN_FILES := baseml basemlg codeml pamp evolver yn00 chi2
BIN_PATHS := $(addprefix $(SRC_DIR)/,$(BIN_FILES))

# Unpack and compile
$(BIN_PATHS) : $(TARBALL)
	tar -xvzpf $<
	$(MAKE) -C $(SRC_DIR)

# Fetch the tarball
$(TARBALL) :
	wget http://abacus.gene.ucl.ac.uk/software/$(TARBALL)

clean :
	rm -f $(BIN_PATHS)

.PHONY : clean
