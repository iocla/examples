AS = nasm
ASFLAGS = -f elf64
CFLAGS = -g -fno-PIC -O1 -mcmodel=large -fcf-protection=none -fno-stack-protector -fno-omit-frame-pointer -masm=intel
LDFLAGS = -no-pie -z noexecstack 
CC=gcc

.PHONY: all clean

all: main

main: main.o 

main.o: main.c

clean:
	-rm -f main main.o 
	-rm -f *~
