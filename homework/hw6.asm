global hw6_sort
section .text

hw6_sort:
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    test    rbx, rbx
    jz      .restore_and_ret
    test    rcx, rcx
    jz      .restore_and_ret
    mov     r12, rbx
    mov     rax, rcx
    xor     rdx, rdx
    div     r12
    mov     r13, rax
    test    r13, r13
    jz      .restore_and_ret
    xor     r9, r9
.copy_loop:
    cmp     r9, r13
    jae     .sort_setup
    mov     r10, r9
    imul    r10, r12
    add     r10, rsi
    mov     r11, r9
    imul    r11, r12
    add     r11, rdi
    cmp     r12, 1
    je      .copy1
    cmp     r12, 2
    je      .copy2
    cmp     r12, 4
    je      .copy4
    cmp     r12, 8
    je      .copy8
.copy_fallback:
    mov     r14, r12
    xor     r15, r15
.copy_fallback_loop:
    cmp     r15, r14
    jae     .inc_copy_i
    mov     al, [r10 + r15]
    mov     [r11 + r15], al
    inc     r15
    jmp     .copy_fallback_loop
.copy1:
    mov     al, [r10]
    mov     [r11], al
    jmp     .inc_copy_i
.copy2:
    mov     ax, [r10]
    mov     [r11], ax
    jmp     .inc_copy_i
.copy4:
    mov     eax, [r10]
    mov     [r11], eax
    jmp     .inc_copy_i
.copy8:
    mov     rax, [r10]
    mov     [r11], rax
    jmp     .inc_copy_i
.inc_copy_i:
    inc     r9
    jmp     .copy_loop

.sort_setup:
    xor     r9, r9
.outer_loop:
    mov     rax, r13
    dec     rax
    cmp     r9, rax
    jae     .done_sort
    mov     r14, r9
    mov     r15, r9
    inc     r15
.inner_loop:
    cmp     r15, r13
    jae     .after_inner
    mov     r10, r15
    imul    r10, r12
    add     r10, rdi
    mov     r11, r14
    imul    r11, r12
    add     r11, rdi
    cmp     r12, 1
    je      .cmp1
    cmp     r12, 2
    je      .cmp2
    cmp     r12, 4
    je      .cmp4
    cmp     r12, 8
    je      .cmp8
.cmp_fallback:
    mov     rdx, r12
    xor     rcx, rcx
.cmp_fb_loop:
    cmp     rcx, rdx
    jge     .inc_j
    mov     al, [r10 + rcx]
    mov     dl, [r11 + rcx]
    cmp     al, dl
    jb      .set_min
    ja      .inc_j_byte
    inc     rcx
    jmp     .cmp_fb_loop
.inc_j_byte:
    inc     r15
    jmp     .inner_loop
.cmp1:
    mov     al, [r10]
    mov     dl, [r11]
    cmp     al, dl
    jb      .set_min
    jmp     .inc_j
.cmp2:
    mov     ax, [r10]
    mov     dx, [r11]
    cmp     ax, dx
    jb      .set_min
    jmp     .inc_j
.cmp4:
    mov     eax, [r10]
    mov     edx, [r11]
    cmp     eax, edx
    jb      .set_min
    jmp     .inc_j
.cmp8:
    mov     rax, [r10]
    mov     rdx, [r11]
    cmp     rax, rdx
    jb      .set_min
    jmp     .inc_j
.set_min:
    mov     r14, r15
.inc_j:
    inc     r15
    jmp     .inner_loop

.after_inner:
    cmp     r14, r9
    je      .next_i
    mov     r10, r9
    imul    r10, r12
    add     r10, rdi
    mov     r11, r14
    imul    r11, r12
    add     r11, rdi
    cmp     r12, 1
    je      .swap1
    cmp     r12, 2
    je      .swap2
    cmp     r12, 4
    je      .swap4
    cmp     r12, 8
    je      .swap8
.swap_fallback:
    mov     rdx, r12
    xor     rcx, rcx
.swap_fb_loop:
    cmp     rcx, rdx
    jae     .next_i
    mov     al, [r10 + rcx]
    mov     dl, [r11 + rcx]
    mov     [r10 + rcx], dl
    mov     [r11 + rcx], al
    inc     rcx
    jmp     .swap_fb_loop
.swap1:
    mov     al, [r10]
    mov     dl, [r11]
    mov     [r10], dl
    mov     [r11], al
    jmp     .next_i
.swap2:
    mov     ax, [r10]
    mov     dx, [r11]
    mov     [r10], dx
    mov     [r11], ax
    jmp     .next_i
.swap4:
    mov     eax, [r10]
    mov     edx, [r11]
    mov     [r10], edx
    mov     [r11], eax
    jmp     .next_i
.swap8:
    mov     rax, [r10]
    mov     rdx, [r11]
    mov     [r10], rdx
    mov     [r11], rax
    jmp     .next_i
.next_i:
    inc     r9
    jmp     .outer_loop

.done_sort:
.restore_and_ret:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret
