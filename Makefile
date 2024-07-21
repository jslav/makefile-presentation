
RMG=${READMEGENERATOR} # set up this variable before

.PHONY: all clean # instructs make utility to skip searching the file named "all"

all: README depgraph.svg
	
# ~ ~ ~ ~ ~ ~ Make dependencies graph ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
depgraph.svg: depgraph.gv
	dot -Tsvg $< > $@

depgraph.gv: makefile-db.txt
	LANG=C python ./makefile-visualizer/make_p_to_json.py < $< | python ./makefile-visualizer/json_to_dot.py > $@
	
makefile-db.txt: Makefile
	LANG=C make -p -n > $@

# ~ ~ ~ ~ ~ ~ Make README file  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
README:  ${RMG}  Makefile # target is the file
	@echo "Making README file"
	@$(RMG) > $@

generate-readme.o: generate-readme.c
	gcc $^ -c -o $@
	
generate-final.o: generate-final.c
	gcc $^ -c -o $@

${RMG}: generate-readme.o generate-final.o
	gcc $^ -o $@

# ~ ~ ~ ~ ~ ~ CLEANUP ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
clean:
	@echo cleaning obsolete and intermediate files
	@rm -vf README *.svg *.gv *.o makefile-db.txt