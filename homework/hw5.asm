section .bss
buf resb 1

section .text
global _start

_start:
    mov esi, 14
    mov edi, 30
    xor ecx, ecx

.row_loop:
    xor ebx, ebx

.col_loop:
    cmp ecx, 0
    je .star
    cmp ecx, esi
    je .star
    cmp ebx, 0
    je .star
    cmp ebx, edi
    je .star
    mov eax, ecx
    shl eax, 1
    cmp ebx, eax
    je .star
    mov eax, edi
    dec eax
    sub eax, ecx
    sub eax, ecx
    cmp ebx, eax
    je .star
    mov byte [buf], ' '
    jmp .print

.star:
    mov byte [buf], '*'

.print:
    mov eax, 4
    mov ebx, 1
    mov ecx, buf
    mov edx, 1
    int 0x80

    inc ebx
    cmp ebx, edi
    jl .col_loop

    mov byte [buf], 10
    mov eax, 4
    mov ebx, 1
    mov ecx, buf
    mov edx, 1
    int 0x80

    inc ecx
    cmp ecx, esi
    jl .row_loop

    mov eax, 1
    xor ebx, ebx
    int 0x80

