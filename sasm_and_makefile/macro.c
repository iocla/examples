#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

FILE *get_stdin(void) { return stdin; }
FILE *get_stdout(void) { return stdout; }
void sasm_replace_stdin(void) {dup2(open("input.txt",0),0);}
