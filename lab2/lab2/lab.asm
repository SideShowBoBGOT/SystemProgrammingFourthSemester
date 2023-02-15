bits 64

;   list of system calls
;   https://filippo.io/linux-syscall-table/
SYS_READ    equ 0
SYS_WRITE   equ 1

;   Descriptors
STDIN   equ 0
STDOUT  equ 1

;   ASCII characters
NULL_TERMINATOR     equ 0
NEW_LINE_CHARACTER  equ 10
DIGIT_ZERO          equ 48
DIGIT_NINE          equ 57

;   Other constants
BUFFER_LENGTH   equ 5


section .data
error_incorrect_symbol:                         db  "Incorrect symbol in input", 0
buffer:                     times BUFFER_LENGTH db  0
inputtedLength:                                 dq  0

section .text
global asm_main
asm_main:
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, buffer
    mov rdi, BUFFER_LENGTH
    call ReadIntoBuffer
    mov rsi, [rsi]
    call TryConvertStringToInteger

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
; void read()
; moves input to buffer variable
ReadIntoBuffer:
;   Function reading string into buffer;
;   void ReadIntoBuffer(char* buffer, int bufferLength, int* inputtedLength);
;   Params:
;       rax:    char*   buffer
;       rdi:    int     bufferLength
;       rsi:    int*    inputtedLength
;   Returns:
;       void
    push rax
    push rdi
    push rdx
    push r8

    mov r8, rsi


    mov rsi, rax
    mov rdx, rdi
    mov rax, SYS_READ
    mov rdi, STDIN

    call DoSystemCallNoModify

    cmp rax, rdx
    jle .End
    mov rax, rdx

    .End:
    mov rsi, r8
    mov [rsi], rax

    pop r8
    pop rdx
    pop rdi
    pop rax
    ret
DoSystemCallNoModify:
;   Function doing system call without
;   modifying rcx and r11 registers after the call.
;   type(rax) sys_call(rax, rdi, rsi, rdx, r8, r9...);
;   The reason behind this function is that in x64 NASM
;   system call neither stores nor loads any registers
;   it just uses and modifies them.

;   https://stackoverflow.com/questions/47983371/why-do-x86-64-linux-system-calls-modify-rcx-and-what-does-the-value-mean
;   http://www.int80h.org/bsdasm/#system-calls
;   https://docs.freebsd.org/en/books/developers-handbook/x86/#x86-system-calls
    push rcx
    push r11
    syscall
    pop r11
    pop rcx
    ret
TryConvertStringToInteger:
;   Function converting string to integer;
;   bool ReadIntoBuffer(char* buffer, int bufferLength, int inputtedLength, int* number);
;   Params:
;       rax:    char*   buffer
;       rdi:    int     bufferLength
;       rsi:    int     inputtedLength
;       rdx:    int*    number
;   Returns:
;        r8:    bool    if true, no error, else throwed error
;
    push rbx
    push rcx

    xor rcx, rcx
    ; if inputtedLength > bufferLength
    cmp rsi, rdi
    je .A2
    .A1:
        .A1B1Loop:

        jl .A1B1Loop
        jp .End
    .A2:
        .A2B1Loop:

        jl .A2B1Loop
        jp .End
    .ErrorIncorrectSymbol
        mov r8, 0
        jmp .End

    .NoError:
        mov r8, 1
        jmp .End
    .End:
    pop rcx
    pop rbx

    ret
IsDigit:
;   Function checking whether byte value
;   is in digit codes range
;   bool IsDigit(char c);
;   Params:
;       rax:    char    c
;   Returns:
;       rdi:    bool    if true, then it is digit, else not
    cmp rax, DIGIT_ZERO
    jl .False
    cmp rax, DIGIT_NINE
    jb .False
    jmp .True
    .False:
        mov rdi, 0
        jmp .End
    .True:
        mov rdi, 1
        jmp .End
    .End:
    ret




