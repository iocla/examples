
AFILES = hello_world.asm 
CFILES = macro.c
OBJS = $(AFILES:.asm=.o) 
NASM = nasm -I /usr/share/sasm/include
ASM_FLAGS = -f elf32 -g -F dwarf 
LD=gcc
LDFLAGS = -m32 -g  -fno-PIC -no-pie
BINARIES = hello_world

all : $(BINARIES)


%.o : %.c
	gcc -m32 -g -c -o $@ $<
%.o : %.asm
	$(NASM) $(ASM_FLAGS) -o $@ $<

hello_world: hello_world.o macro.o 
	$(LD) $(LDFLAGS) -o $@ $^

clean: 
	rm -f *.o $(BINARIES) *.s
	rm -f *~ 
