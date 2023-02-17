section .data
    ; the "pi = " part
    piequals: db "pi = ", 0
    pel equ $ - piequals
    ; Testing...
    test: db "3.14159265358979323846264338327950288419716939", 0
    testl equ $ - test
    ; New line
    nl: db 10
    nll equ $ - nl
section .bss
    
section .text

global _start

_start:
    jmp write1

write1:
    mov rax, 1
    mov rdi, 1
    mov rsi, piequals
    mov rdx, pel
    syscall
    jmp write2

write2:
    mov rax, 1
    mov rdi, 1
    mov rsi, test
    mov rdx, testl
    syscall
    jmp newline

newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, nll
    syscall
    jmp exit



exit:
    ; End the program
    mov eax, 1
    mov ebx, 0
    int 80h
