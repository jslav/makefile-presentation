
.PHONY: all # instructs make utility to skip searching the file named "all"

all: README depgraph.svg

README:      # target is the file
	@echo "Making README file"
	@echo "This is the presentatioon of make utility purposes and capabilities" > README
	
depgraph.svg: depgraph.gv
	dot -Tsvg depgraph.gv >depgraph.svg

depgraph.gv: makefile-db.txt
	LANG=C python ./makefile-visualizer/make_p_to_json.py < makefile-db.txt | python ./makefile-visualizer/json_to_dot.py > depgraph.gv
	
makefile-db.txt: Makefile
	LANG=C make -p -n > $@


	