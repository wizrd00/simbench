simbench : simbench.o
	ld simbench.o -o $@
simbench.o : simbench.s
	as simbench.s -o $@
