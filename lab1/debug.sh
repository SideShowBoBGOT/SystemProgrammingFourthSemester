rm release/release.o
rm release/release.out
nasm -f elf64 -g -F dwarf -o release/release.o release/release.asm
ld -o release/release.out release/release.o