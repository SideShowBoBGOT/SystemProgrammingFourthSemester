bits 64

; list of system calls
; https://filippo.io/linux-syscall-table/
SYS_READ equ 0
SYS_WRITE equ 1

; descriptors
STDIN equ 0
STDOUT equ 1

; special characters
NEW_LINE_CHARACTER equ 10
NULL_TERMINATOR equ 0

; other constants
BUFFER_LENGTH equ 5
section .data
error_incorrect_symbol: db "Incorrect symbol in input", 0
buffer: times BUFFER_LENGTH db 0
inputtedLength: dq 0

;   why rcx and r11 are modified after system calls?
;   https://stackoverflow.com/questions/47983371/why-do-x86-64-linux-system-calls-modify-rcx-and-what-does-the-value-mean
;   http://www.int80h.org/bsdasm/#system-calls
;   https://docs.freebsd.org/en/books/developers-handbook/x86/#x86-system-calls
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
    call ConvertStringToInteger

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
;       rsi:    int     inputtedLength
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
    push rcx
    push r11
    syscall
    pop r11
    pop rcx
    ret
ConvertStringToInteger:
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
    push rdx
    push r8

    ; int index = 0;
    xor rcx, rcx
    ; r8 = &buffer
    mov r8, buffer

    ; if rax > BUFFER_LENGTH go to A1
    cmp rax, BUFFER_LENGTH
    jb .A1
        ; <<A1 false part>>
        ; <<A1 true part>>
        mov dl, byte [r8+rcx]
        ; check whether dl is
        ; in range of [48; 57]
        ; '0' has code of 48
        ; '9' has code of 57 in ASCII



        ; increment counter
        inc rcx
        cmp rcx, rax
        jl A1
        jp End
    .A1:
        ; <<A1 true part>>
        ; read byte element from buffer
        mov dl, byte [r8+rcx]
        ; check whether dl is
        ; in range of [48; 57]
        ; '0' has code of 48
        ; '9' has code of 57 in ASCII



        ; increment counter
        inc rcx
        cmp rcx, rax
        jl A1
        jp End
    .ErrorIncorrectSymbol

    .End:

    pop r8
    pop rdx
    pop rcx
    pop rbx

    ret






