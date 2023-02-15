bits 64
segment .data ; a.k.a DS - Data Segment
    SOURCE: db  10, 20, 30, 40
    number: dq 999
segment .bss
    DEST:   resb    4
segment .text ; a.k.a CS - Code Segment
global _start
_start:
    mov rbp, rsp; for correct debugging
    
    
    push qword [number]
    
    xor rax, rax

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

    mov rax, 60                 ; system call for exit
    xor rdi, rdi                ; exit code 0
    syscall                
