#include <stdio.h>

extern void asm_main();

int main() {
    asm_main();
    long unsigned a = (long unsigned)-1;
    printf("%lu", a);
    return 0;
    18446744073709551615;

}
