NASM = nasm
AFILES = count.asm 
OBJS = $(AFILES:.asm=.o) 
ASM_FLAGS = -f elf32 -g -F dwarf 
LD=gcc
LDFLAGS = -m32 -g  -fno-pie -no-pie
BINARIES = count

all : $(BINARIES)


#%.o : %.c
#	gcc -m32 -g -c -o $@ $<
%.o : %.asm
	$(NASM) $(ASM_FLAGS) -o $@ $<

count: count.o 
	$(LD) $(LDFLAGS) -o $@ $^

clean: 
	rm -f *.o $(BINARIES) *.s
	rm -f *~ 
