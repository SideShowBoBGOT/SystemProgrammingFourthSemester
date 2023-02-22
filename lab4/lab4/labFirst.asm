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
PLUS_SIGH           equ 43
MINUS_SIGN          equ 45
PERIOD              equ 46
DIGIT_ZERO          equ 48
DIGIT_NINE          equ 57

;   Other constants
BUFFER_LENGTH   equ 20
MAX_LENGTH   equ 10

; !!!   SECTION DATA    !!!
section .data

    ;   Errors
    error_incorrect_symbol:                         db  "Incorrect symbol in input", NEW_LINE_CHARACTER, 0
    error_incorrect_symbol_length:                  equ $-error_incorrect_symbol
    error_sign_character_not_first                  db  "Sign characters must be first", NEW_LINE_CHARACTER, 0
    error_sign_character_not_first_length           equ $-error_sign_character_not_first
    max_length_error db "Max length is 10", NEW_LINE_CHARACTER, 0
    max_length_error_length equ $-max_length_error
    ;   Buffers
    buffer:                     times BUFFER_LENGTH db  0
    inputtedLength:                                 dq  0
    ;   Messages
    enterArraySize  db "Enter array size: ", NEW_LINE_CHARACTER, 0
    enterArraySizeLength  equ $-enterArraySize
    enterArrayElement db "Enter array element: ", NEW_LINE_CHARACTER, 0
    enterArrayElementLength equ $-enterArrayElement
    sumArray db "Sum of array elements: ", NEW_LINE_CHARACTER, 0
    sumArrayLength equ $-sumArray
    maxArrayElement db "Max array element: ", NEW_LINE_CHARACTER, 0
    maxArrayElementLength equ $-maxArrayElement
    minArrayElement db "Min array element: ", NEW_LINE_CHARACTER, 0
    minArrayElementLength equ $-minArrayElement
    sortedArray db "Sorted array: ", NEW_LINE_CHARACTER, 0
    sortedArrayLength equ $-sortedArray

; !!!   SECTION TEXT    !!!
section .text

    global asm_main
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    asm_main:
        push rax
        push rbx
        push rcx
        push rdi
        push rsi
        push r12

        .inputArraySize:
            mov rax, enterArraySize
            mov rdi, enterArraySizeLength
            call WriteToConsole

            xor rsi, rsi

            .loopWhileNegative:
                mov rax, buffer
                mov rdi, BUFFER_LENGTH
                call InputArgument
                cmp rsi, 0
                jl .loopWhileNegative

        ; rax - buffer, rdi - bufferLength, rsi - arraySize
        .allocMemoryOnStack:
            xor rbx, rbx ; inputted value
            xor rcx, rcx ; counter to zero
            mov r12, rsp ; the beggining of the array
            .loopAllocStack:
                cmp rcx, rsi
                jge .OnLoopAllocStackEnd
                push rsi
                call InputArgument
                mov rbx, rsi
                pop rsi
                push rbx
                inc rcx
                jmp .loopAllocStack ; jump to the loop head

            .OnLoopAllocStackEnd:
                xor rcx, rcx
                xor rbx, rbx

        ; rax - buffer, rdi - bufferLength, rsi - arraySize,
        ; r12 - beginning of the array, rcx - 0
        ; rbx - 0
        .sortArray:
            mov rbx, 8 ; size of long integer
            xor rcx, rcx ; counter i to zero
            xor rdx, rdx ; counter j to zero
            ; bubble sort
            .loopSortOne:
                cmp rcx, rsi ; if(i >= arraySize) break
                jge .onLoopSortOneEnd
                mov rdx, rcx ; i = j
                .loopSortTwo:
                    cmp rdx, rsi ; if(j >= arraySize) break;
                    push rax
                    push rdi
                    push rsi
                    push rdx
                    push r8
                    push r9
                    push r10

                    mov r10, rdx ; temp = j

                    mov rdi, r12 ; rdi = &array
                    mov rsi, rcx ; rsi = i
                    mov rdx, rbx ; rdx = 8 // sizeof(long int)
                    call GetElementAddressByIndex

                    mov r8, rax ; r8 = &array[i]

                    mov rdx, r10 ; rdx = tmp = j
                    call GetElementAddressByIndex

                    mov r9, rax ; r9 = &array[j]

                    mov rax, qword [r8] ; rax = array[i]
                    mov rdi, qword [r9] ; rdi = array[j]

                    cmp rax, rdi ; if(array[i] > array[j])
                    jg .swap
                    jmp .notSwap
                    .swap:
                        mov qword [r8], rdi
                        mov qword [r9], rax
                    .notSwap
                    pop r10
                    pop r9
                    pop r8
                    pop rdx
                    pop rsi
                    pop rdi
                    pop rax

                    inc rdx
                    jmp .loopSortTwo

                .onLoopSortTwoEnd:
                    inc rcx
                    jmp .loopSortOne

            .onLoopSortOneEnd:




        pop r12
        pop rsi
        pop rdi
        pop rcx
        pop rbx
        pop rax
        ret
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    PrintArray:
    ; rax - void (rdi - buffer, rsi - bufferLength, rdx - array, r8 - arrayLength )
    push rcx
    push rbx
    push r9
    mov rbx, 8; long int size
    xor rcx, rcx ; zero counter
    mov r9, rdx ; mov the array beginning to r9
    .loop:
        cmp rcx, r8
        jge .end

        push rdx
        mov rdx, qword [r9]
        pop rdx

        push rax
        mov rax, rdi

        call PrintEndl

        pop rax

        add r9, rbx
        inc rcx
        jmp .loop
    .end:
        pop r9
        pop rbx
        pop rcx


        ret

    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    PrintInteger:
    ; rax - void (rdi - buffer, rsi - bufferLength, rdx - number)
    push rax
    push rdi
    push rsi
    push rdx
    push r8

    mov rax, rdi
    mov rdi, rsi
    mov r8, rdi

    xor rsi, rsi
    call ClearBuffer
    call TryConvertNumberToString
    mov rdi, rsi
    call WriteToConsole
    mov rdi, r8
    call ClearBuffer

    pop r8
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    GetElementAddressByIndex:
    ; rax - address (rdi - array, rsi - index, rdx - typeSize)
    push rbx
    push rdx

    mov rbx, rdx
    xor rdx, rdx
    mov rax, rsi
    imul rbx
    add rax, rdi

    pop rdx
    pop rbx
    ret

    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    InputArgument:
    ; void (rax-buffer, rdi-bufferLength, rsi- int&_out number)
        push rax
        push rdi
        push rdx
        push r8
        push r9
        push r10

        mov r9, rax
        mov r10, rdi

        xor rsi, rsi

        .loop:
            mov rax, r9
            mov rdi, r10

            call ReadIntoBuffer
            call TryConvertStringToInteger
            call ClearBuffer
            cmp r8, 0
            je .loop

        call ClearBuffer
        mov rsi, rdx

        pop r10
        pop r9
        pop r8
        pop rdx
        pop rdi
        pop rax

        ret


    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    procABS:
        ; rdi Abs(rax);
        mov rdi, rax
        cmp rdi, 0
        jge .End
            neg rdi
        .End:
            ret

    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    PrintEndl:
    ;   Function printing enl
    ;   void PrintEndl(char* const buffer);
    ;   Params:
    ;       rax:    char*   buffer
    ;   Returns:
    ;       void
        push rdi
        push rbx
        mov bl, byte [rax]
        mov byte [rax], NEW_LINE_CHARACTER
        mov rdi, 1
        call WriteToConsole
        mov byte [rax], bl
        pop rbx
        pop rdi
        ret
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    PrintPlus:
    ;   Function printing enl
    ;   void PrintEndl(char* const buffer);
    ;   Params:
    ;       rax:    char*   buffer
    ;   Returns:
    ;       void
        push rdi
        push rbx
        mov bl, byte [rax]
        mov byte [rax], PLUS_SIGH
        mov rdi, 1
        call WriteToConsole
        mov byte [rax], bl
        pop rbx
        pop rdi
        ret
    PrintMinus:
    ;   Function printing enl
    ;   void PrintEndl(char* const buffer);
    ;   Params:
    ;       rax:    char*   buffer
    ;   Returns:
    ;       void
        push rdi
        push rbx
        mov bl, byte [rax]
        mov byte [rax], MINUS_SIGN
        mov rdi, 1
        call WriteToConsole
        mov byte [rax], bl
        pop rbx
        pop rdi
        ret
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ClearBuffer:
    ;   Function clearing buffer
    ;   void ClearBuffer(char* buffer, int length);
    ;   Params:
    ;       rax:    char*   buffer
    ;       rdi:    int     length
    ;   Returns:
    ;       void
        push rcx
        xor rcx, rcx
        .loop:
            cmp rcx, rdi
            jbe .End
                mov byte [rax + rcx], 0
                jmp .loop
        .End:
            pop rcx
            ret
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    TryConvertNumberToString:
    ;      Function converting integer to string;
    ;      bool TryConvertNumberToString(char* buffer, int bufferLength, int inputtedLength, int number);
    ;      Params:
    ;          rax:    char*   buffer
    ;          rdi:    int     bufferLength
    ;          rsi:    int&    inputtedLength
    ;          rdx:    int     number
    ;      Returns:
    ;           r8:    bool    if true, no error, else throwed error
    ;
        pushf
        push rbx
        push rcx
        push r8
        push r9

        xor r9, r9
        xor r8, r8
        ;   counter = 0
        mov rcx, 0
        cmp rdx, 0
        jge .ReadingNumbersIntoStack
            .CheckForNegative:
                mov r9, 1
                neg rdx
                mov byte [rax], MINUS_SIGN
        .ReadingNumbersIntoStack:
    ;   The idea behind this is to read number into stack
    ;   For example, 123 into stack like "3","2","1"
    ;   and we counted digits. In this, example count = 3
    ;   so we need to do smth like that:
    ;   while(index<count) {
    ;       pop stack into var
    ;       var = var + ZERO_CODE
    ;       *buffer[index] = var
    ;       ++index
    ;   }
    ;       copy value to rbx
            mov rbx, rdx
            cmp rbx, 0
            je .zero
                .loop:
                    cmp rbx, 0
                    jle .ReadingNumbersFromStackToBuffer
                        .ReadDigit:
                            push rax
                            push rdx
            ;               rax_rbx_copy = rbx;
                            mov rax, rbx
            ;               rdx = 0; rbx = 10
                            xor rdx, rdx
                            mov rbx, 10
            ;               rax_rbx_copy, rdx_remaindex = rax_rbx_copy / rbx
                            idiv rbx
            ;               r8 = rdx_remainder; rbx = rax_rbx_copy
                            mov r8, rdx
                            mov rbx, rax
                            pop rdx
                            pop rax
                        push r8
                        inc rcx
                        jmp .loop
                jmp .ReadingNumbersFromStackToBuffer
            .zero:
                push 0
                inc rcx
        .ReadingNumbersFromStackToBuffer:
            xor rbx, rbx
            xor r8, r8
            cmp r9, 0
            je .Preparation
                .IncrementIfNegative:
                    inc r8
                    inc rcx
            .Preparation:
                mov rsi, rcx
                .loop2:
                    cmp r8, rcx
                    jge .NoError
                        pop rbx
                        add rbx, DIGIT_ZERO
                        mov [rax + r8], bl
                        inc r8
                        jmp .loop2
        .NoError:
            pop r9
            pop r8
            pop rcx
            pop rbx
            popf
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
    ;       rsi:    int&    inputtedLength
    ;   Returns:
    ;       void
        push rax
        push rdi
        push rdx
        push r8
        push r9

        mov r8, rax
        mov r9, rdi
        mov rsi, 0
        .loop:
            mov rsi, r8
            mov rdx, r9
            mov rax, SYS_READ
            mov rdi, STDIN

            call DoSystemCallNoModify

            cmp rax, MAX_LENGTH
            jle .NoError


            mov rax, max_length_error
            mov rdi, max_length_error_length
            call WriteToConsole
            jmp .loop

        .NoError:
        mov rsi, rax

        pop r9
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
        pushf
        push rcx
        push r11
        syscall
        pop r11
        pop rcx
        popf
        ret
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    TryConvertStringToInteger:
    ;   Function converting string to integer;
    ;   bool TryConvertStringToInteger(char* buffer, int bufferLength, int inputtedLength, int* number);
    ;   Params:
    ;       rax:    char*   buffer
    ;       rdi:    int     bufferLength
    ;       rsi:    int     inputtedLength
    ;       rdx:    int&    number
    ;   Returns:
    ;        r8:    bool    if true, no error, else throwed error
    ;
        pushf
        push rbx
        push rcx
        push r9
        push r10

        xor rdx, rdx
        xor r10, r10
        xor r9, r9
        mov rdx, 0
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
                .CheckForSigns:
                    .IsPlusCharacter:
                        cmp bl, PLUS_SIGH
                        je .CheckForSignBeingFirst
                    .IsMinusCharacter:
                        cmp bl, MINUS_SIGN
                        je .OnEqualMinus
                    jmp .CallIsDigit
                    .OnEqualMinus:
                        mov r10, 1
                    .CheckForSignBeingFirst:
                        cmp r9, 0
                        jne .ErrorSignNotFirst
                    jmp .OnIterationEnd

                .CallIsDigit:
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

                .CallPow:
                    push rax
                    push rdi
                    push rsi

                    mov rax, 10
                    mov rdi, rcx
                    call Pow

                    imul rsi, rbx
                    mov rdi, rdx
                    add rdi, rsi
                    mov rdx, rdi

                    pop rsi
                    pop rdi
                    pop rax
                ;   whole_digit = digit*(10^counter)
                .OnIterationEnd:
                dec rcx
                inc r9
                jmp .loop
        .ErrorSignNotFirst:
            mov r8, 0

            push rax
            push rdi

            mov rax, error_sign_character_not_first
            mov rdi, error_sign_character_not_first_length
            call WriteToConsole

            pop rdi
            pop rax

            jmp .End
        .ErrorIncorrectSymbol:
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
            cmp r10, 1
            jne .GeneralNoError
                push rax

                mov rax, rdx
                neg rax
                mov rdx, rax

                pop rax
            .GeneralNoError:
                mov r8, 1
                jmp .End
        .End:
        pop r10
        pop r9
        pop rcx
        pop rbx
        popf
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
        pushf
        cmp al, DIGIT_ZERO
        jl .Invalid
            cmp al, DIGIT_NINE
            jg .Invalid
                mov rdi, 1
                jmp .End
        .Invalid:
            mov rdi, 0
            jmp .End
        .End:
            popf
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
        pushf
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
            popf
            ret


















