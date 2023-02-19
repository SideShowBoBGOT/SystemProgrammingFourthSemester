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
BUFFER_LENGTH   equ 10


section .data
;   Errors
error_incorrect_symbol:                         db  "Incorrect symbol in input", NEW_LINE_CHARACTER, 0
error_incorrect_symbol_length:                  equ $-error_incorrect_symbol
error_sign_character_not_first                  db  "Sign characters must be first", NEW_LINE_CHARACTER, 0
error_sign_character_not_first_length           equ $-error_sign_character_not_first
;   Buffers
buffer:                     times BUFFER_LENGTH db  0
inputtedLength:                                 dq  0
section .text
global asm_main
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
asm_main:
ret
