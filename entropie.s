.data
    v: .float 0.3,0.5,0.1,0.1
    n: .long 4
    avg:.space 4
.text

.global main
main:
    mov $v, %edi
    xor %ecx, %ecx
    mov $0, %eax
    cvtsi2ss %eax, %xmm0
loop:
    cmp n, %ecx
    je compute
    movss (%edi, %ecx, 4), %xmm1
    push %xmm1
    call logf
    fstps logResult
    add $4, %esp
    mulss %xmm1, logResult 
    addss logResult, %xmm0
    inc %ecx
    jmp loop
compute:
    movss %xmm0, avg
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80