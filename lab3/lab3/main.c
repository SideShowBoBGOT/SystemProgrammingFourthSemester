#include <stdio.h>

extern void asm_main();

void CFunction(long int a, long int b, long int x) {
    double sum = a * x * x + (double)(b) / x;
    //printf("C Result: %f\n", sum);
}

int main() {
    //CFunction(24, -5, 7);
    asm_main();
    return 0;
}
