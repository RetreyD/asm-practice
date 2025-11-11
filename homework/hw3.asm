section .data
prime_msg db "Prime",0Ah,0
not_prime_msg db "Not prime",0Ah,0
num_msg db "Number: ",0

section .bss
buffer resb 20

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
    ret

is_prime:
    cmp ax,2
    jb .np
    je .p
    mov cx,2
.loop:
    xor dx,dx
    div cx
    cmp dx,0
    je .np
    inc cx
    cmp cx,ax
    jl .loop
.p:
    mov al,1
    ret
.np:
    mov al,0
    ret

_start:
    mov ax,29
    mov eax,eax
    mov esi,buffer
    call int2str

    mov eax,4
    mov ebx,1
    mov ecx,num_msg
    mov edx,8
    int 0x80

    mov eax,4
    mov ebx,1
    mov ecx,esi
    mov edx,20
.next:
    cmp byte [ecx],0
    je .after_num
    inc ecx
    jmp .next
.after_num:
    sub ecx,esi
    mov edx,ecx
    mov ecx,esi
    int 0x80

    mov ax,29
    call is_prime
    cmp al,1
    je .pr
    mov eax,4
    mov ebx,1
    mov ecx,not_prime_msg
    mov edx,9
    int 0x80
    jmp .ex
.pr:
    mov eax,4
    mov ebx,1
    mov ecx,prime_msg
    mov edx,6
    int 0x80
.ex:
    mov eax,1
    xor ebx,ebx
    int 0x80
