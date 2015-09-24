TARBALL := clustalw-2.1.tar.gz
WORK_DIR := $(subst .tar.gz,,$(TARBALL))
INSTALL_DIR := $(shell pwd)
BIN := clustalw2
BIN_PATH := bin/$(BIN)

# Install
$(BIN_PATH) : $(WORK_DIR)/Makefile
	$(MAKE) -C $(WORK_DIR) install

# Unpack and compile
$(WORK_DIR)/src/$(BIN) : $(TARBALL)
	tar -xvpf $<
	cd $(WORK_DIR); \
	./configure --prefix=$(INSTALL_DIR); \
	$(MAKE)

# Fetch the tarball
$(TARBALL) :
	wget http://www.clustal.org/download/current/$(TARBALL)

clean :
	rm -f $(BIN_PATH)

.PHONY : clean
