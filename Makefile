
.PHONY: all # instructs make utility to skip searching the file named "all"

all: README

README:      # target is the file
	@echo "Making README file"
	@echo "This is the presentatioon of make utility purposes and capabilities" > README
	