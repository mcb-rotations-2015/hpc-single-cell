DIRS := parallel-macse parallel-paml

deps :
	for dir in $(DIRS); do $(MAKE) -C $$dir; done
