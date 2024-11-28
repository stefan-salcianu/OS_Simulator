.data
    x:.space 4
    y:.space 4
    rez:.space 4
    formatPrintf: .asciz "Minimul in pula mea e: %ld\n"
    formatScanf: .asciz "%ld %ld"
.text
.global main
sum:
    push %ebp
    mov %esp, %ebp
    mov 8(%ebp), %eax
    push %ebx
    mov 12(%ebp), %ebx
    addl %ebx, %eax
    pop %ebx
    pop %ebp
    ret
min: 
    push %ebp
    mov %esp, %ebp
    mov 8(%ebp), %eax
    mov 12(%ebp), %ecx
    cmp %eax, %ecx
    jl ch_min
    jmp min_ret
    ch_min:
        mov %ecx, %eax
    min_ret:
        pop %ebp
        ret
main:
    push $x
    push $y
    push $formatScanf
    call scanf
    add $12, %esp
    push x
    push y
    call min
    add $8, %esp
    mov %eax, rez
    push rez
    push $formatPrintf
    call printf
    add $8, %esp
    pushl $0
    call fflush
    add $4, %esp
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
