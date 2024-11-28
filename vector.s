.data
    v: .float 1.0,2.0,3.0,4.0
    n: .long 4
    avg:.space 4
    logResult: .space 4
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
    addss %xmm1, %xmm0
    inc %ecx
    jmp loop
compute:
    cvtsi2ss %ecx, %xmm1
    divss %xmm1, %xmm0 
    movss %xmm0, avg
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80