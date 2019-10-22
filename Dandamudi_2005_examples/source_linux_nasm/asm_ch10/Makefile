
FILES = str_test.asm string.asm 

OBJS = $(FILES:.asm=.o) 
NASM = nasm
ASM_FLAGS = -f elf32 -g -F dwarf -I ../Linux_IOfiles/
LD = ld -g  -melf_i386 ../Linux_IOfiles/io.o
BINARIES = str_test

all : $(BINARIES)

str_test: str_test.o string.o 
	$(LD) -o str_test string.o str_test.o 


%.o : %.asm
#	$(warning NASM=$(NASM) FLAGS=$(ASM_FLAGS))
	$(NASM) $(ASM_FLAGS) -o $@ $<
clean: 
	rm -f $(OBJS) $(BINARIES)
	rm -f *~ 
