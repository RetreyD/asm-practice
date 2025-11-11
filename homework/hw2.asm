section .bss
buffer resb 20

section .data
newline db 0Ah

section .text
global _start

int2str:
    mov edi, esi
    cmp eax,0
    jne .num
    mov byte [esi],'0'
    inc esi
    jmp .done
.num:
    add esi,19
    mov byte [esi],0
.revloop:
    xor edx,edx
    mov ebx,10
    div ebx
    dec esi
    add dl,'0'
    mov [esi],dl
    test eax,eax
    jnz .revloop
.done:
    mov eax,esi
    mov edx,edi
    add edx,20
    sub edx,eax
    ret

_start:
    mov eax,1234567
    mov esi,buffer
    call int2str

    mov ecx,eax
    mov ebx,1
    mov eax,4
    int 0x80
    mov eax,4
    mov ebx,1
    mov ecx,newline
    mov edx,1
    int 0x80

    mov eax,1
    xor ebx,ebx
    int 0x80

