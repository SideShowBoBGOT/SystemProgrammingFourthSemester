%include "io64.inc"

section .data
    SOURCE: db  10, 20, 30, 40
section .bss
    DEST:   resb    4
section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
    xor rax, rax
    push rax
    call Transfering
    pop rax
    ret
   
Transfering: ;transfering values from SOURCE TO DEST
    mov byte [DEST], 0
    mov byte [DEST + 1], 0
    mov byte [DEST + 2], 0
    mov byte [DEST + 3], 0
    
    mov al, byte [SOURCE]
    mov byte [DEST + 3], al
    
    mov al, byte [SOURCE + 1]
    mov byte [DEST + 2], al
    
    mov al, byte [SOURCE + 2]
    mov byte [DEST + 1], al
    
    mov al, byte [SOURCE + 3]
    mov byte [DEST], al

    ret
    