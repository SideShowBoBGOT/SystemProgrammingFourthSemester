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
    pi resd 1
    a resd 1
    s resd 1
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
    jmp calculate

calculate:
    mov dword [s], __float32__(2.57575757575)
    mov dword [a], __float32__(3.25)
    jmp write2

write2:
    addss xmm0, [s]
    call print_float
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


;; ZEKKA NOTE: Float printing machinery

digits: db "0123456789."
float_coef: dd 100000.0

%macro digit_part 1

  mov rax, r8
  mov ebx, %1
  cdq
  div ebx
  mov r8, rdx
  call print_digit

%endmacro

print_float: ; takes xmm0, a float with only one digit left of decimal
  mulss xmm0, [float_coef]
  xor rax, rax
  cvttss2si eax, xmm0
  mov r8, rax

  digit_part 100000
  call print_dot
  digit_part 10000
  digit_part 1000
  digit_part 100
  digit_part 10
  digit_part 1

  ret

print_dot:
  mov eax, 10

print_digit: ; takes eax
  mov rsi, digits
  add esi, eax

print_char:
  mov rax, 1
  mov rdi, 1
  mov rdx, 1
  syscall
  ret
