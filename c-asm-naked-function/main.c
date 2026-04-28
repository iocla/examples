#include <stdio.h>

__attribute__ ((naked))
unsigned long sum_array(unsigned long *a, int len)
{
  asm("\
      xor rax, rax \n\
      xor rdx, rdx \n\
.addallc: \n\
      add rax, [rdi + 8*rdx] \n\
      inc rdx \n\
      dec rsi \n\
      jnz .addallc \n\
      ret \n\
      ");
}




static unsigned long num_array[] = {10, 20, 30, 40, 50, 60, 70, 80};

int main(void)
{
	unsigned long result;

	result = sum_array(num_array, sizeof(num_array) / sizeof(num_array[0]));
	printf("Sum of array elements is: %lu\n", result);

	return 0;
}
