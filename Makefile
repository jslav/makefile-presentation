
RMG=${READMEGENERATOR} # set up this variable before

.PHONY: all clean probe # instructs make utility to skip searching the file named "all"

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


C_SOURCES=$(wildcard *.c)    # since now we included all .c files in directory into ${RMG} file building
OBJ_FILES= $(addsuffix .o,$(basename $(C_SOURCES)))

generate-readme.o: message1.h message3.h message4.h message5.h
generate-final.o: message1.h message2.h message4.h message5.h

${RMG}: $(OBJ_FILES)
	gcc $^ -o $@

# ~ ~ ~ ~ ~ ~ CLEANUP ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
clean:
	@echo cleaning obsolete and intermediate files
	@rm -vf README *.svg *.gv *.o makefile-db.txt
	
probe:
	@echo source files: $(C_SOURCES)
	@echo object files: $(OBJ_FILES)


# ~ ~ ~ ~ ~ ~ EXPLICIT RULES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
%.o: %.c 
	gcc $< -c -o $@

# same as
# %.o: %.c ; gcc $< -c -o $@

# same as
#.SUFFIXES: .c .o
# .c.o: ; gcc $< -c -o $@

