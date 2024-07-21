
RMG=${READMEGENERATOR} # set up this variable before

.PHONY: all # instructs make utility to skip searching the file named "all"

all: README depgraph.svg

README:   ${BINGEN} ${RMG}  Makefile # target is the file
	@echo "Making README file"
	@$(RMG) > README
	
depgraph.svg: depgraph.gv
	dot -Tsvg depgraph.gv >depgraph.svg

depgraph.gv: makefile-db.txt
	LANG=C python ./makefile-visualizer/make_p_to_json.py < makefile-db.txt | python ./makefile-visualizer/json_to_dot.py > depgraph.gv
	
makefile-db.txt: Makefile
	LANG=C make -p -n > $@

${RMG}: generate-readme.c
	gcc generate-readme.c -o ${RMG}

	