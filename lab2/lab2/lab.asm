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
error_incorrect_symbol_length:                  db  $-error_incorrect_symbol
buffer:                     times BUFFER_LENGTH db  0
inputtedLength:                                 dq  0

section .text
global asm_main
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
    mov rdx, qword [rdx]

    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
WriteToConsole:
;   Function writing string into STDOUT
;   void WriteToConsole(char* buffer, int bufferLength)
;   Params:
;       rax:    char*   buffer
;       rdi:    int     bufferLength
;   Returns:
;       void
push rax
push rdi
push rsi
push rdx

mov rsi, rax
mov rdx, rdi
mov rax, SYS_WRITE
mov rdi, STDOUT

call DoSystemCallNoModify

pop rdx
pop rsi
pop rdi
pop rax
ret
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
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
    push r9

    xor r9, r9
    mov qword [rdx], 0
    mov rcx, rsi
    xor rbx, rbx
    xor r8, r8

    dec rcx
    cmp byte [rax + rcx], NEW_LINE_CHARACTER
    jne .loop
    dec rcx

    .loop:
        cmp rcx, 0
        jl .NoError

        mov bl, byte [rax + r9]

        .IsNewLineCharacter:
            cmp bl, NEW_LINE_CHARACTER
            je .NoError

        .CallIsDigit
            push rax
            push rdi

            xor rax, rax
            mov al, bl
            call IsDigit
            mov r8, rdi

            pop rdi
            pop rax

        cmp r8, 0
        je .ErrorIncorrectSymbol
        sub bl, DIGIT_ZERO

        .CallPow
            push rax
            push rdi
            push rsi

            mov rax, 10
            mov rdi, rcx
            call Pow

            imul rsi, rbx
            mov rdi, qword [rdx]
            add rdi, rsi
            mov qword [rdx], rdi

            pop rsi
            pop rdi
            pop rax
        ;   whole_digit = digit*(10^counter)
        dec rcx
        inc r9
        jmp .loop
    .ErrorIncorrectSymbol
        ;   print error message
        mov r8, 0

        push rax
        push rdi

        mov rax, error_incorrect_symbol
        mov rdi, error_incorrect_symbol_length
        call WriteToConsole

        pop rdi
        pop rax

        jmp .End
    .NoError:
        mov r8, 1
        jmp .End
    .End:

    pop r9
    pop rcx
    pop rbx

    ret
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
IsDigit:
;   Function checking whether byte value
;   is in digit codes range
;   bool IsDigit(char c);
;   Params:
;       rax:    char    c
;   Returns:
;       rdi:    bool    if true, then it is digit, else not
    cmp al, DIGIT_ZERO
    jl .False
    mov r11, DIGIT_NINE
    cmp al, DIGIT_NINE
    jg .False
    jmp .True
    .False:
        mov rdi, 0
        jmp .End
    .True:
        mov rdi, 1
        jmp .End
    .End:
    ret
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Pow:
;   Function powing number to a certain degree.
;   Params:
;       rax:    int number
;       rdi:    int degree
;   Returns:
;       rsi:    Powed number
push rcx

mov rsi, 1
xor rcx, rcx

.loop:
    cmp rcx, rdi
    jge .End

    imul rsi, rax
    inc rcx

    jmp .loop
.End:
pop rcx
ret














