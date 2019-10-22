
NASM = as
ASM_FLAGS = --32 -gdwarf-2 
LD = ld 
LD_FLAGS = -melf_i386 -g

all : test_gas 

test_gas: test_gas.o 
	$(LD) $(LD_FLAGS) -o test_gas test_gas.o

%.o : %.asm
	$(warning NASM=$(NASM) FLAGS=$(ASM_FLAGS))
	$(NASM) $(ASM_FLAGS) -o $@ $<
clean: 
	rm -f *.o *~ test_gas 
