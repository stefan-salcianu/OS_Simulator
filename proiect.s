.data
    memory:.space 1026
    memory_slots: .long 50
    formatPrintf: .asciz "%ld, "
    formatEndline:.asciz "\n"
    formatScanf: .asciz "%ld %ld %ld"
    id: .space 4
    size: .space 1
    needed_Blocks: .space 4
    rez:.long 4
    func:.long 4
.text
.global main
add:
    push %ebp
    mov %esp, %ebp
    movl 16(%ebp), %eax
    xor %edx, %edx
    movl $8, %ecx
    idiv %ecx
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %ebx
    mov $1, %ebx
    cmp $0, %edx
    je parcurgere
    inc %eax
parcurgere:
    xor %edx, %edx
    cmp %eax, %ebx
    je adaugare
    movb (%edi, %ecx, 1), %dl
    cmp $0, %dl
    je incrementare
    jmp reinit
reinit:
    inc %ecx
    mov $1, %ebx
    jmp parcurgere
incrementare:
    inc %ecx
    inc %ebx
    jmp parcurgere
    #pushl $0
    #call fflush
    #add $4, %esp
adaugare:
    #movb (%edi, %ecx, 1), %dl
    #cmp $0, %dl
    #je reinit
    cmp $0, %eax
    je end_add
    mov 20(%ebp), %dl
    movb %dl, (%edi, %ecx, 1)
    dec %ecx
    dec %eax
    jmp adaugare
end_add:
    pop %ebx
    pop %edi
    pop %ebp
    ret

afisare_vec:
    push %ebp
    mov %esp, %ebp
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
afisare:
    cmp 8(%ebp), %ecx
    je end
    xor %edx, %edx
    movb (%edi, %ecx, 1), %dl
    push %ecx
    push %edx
    push $formatPrintf
    call printf
    add $8, %esp
    #pushl $0
    #call fflush
    #add $4, %esp
    pop %ecx
    inc %ecx
    jmp afisare
end:
    pop %edi
    pop %ebp
    ret
main:
    lea memory, %edi
    movl $12, %ecx
    movb $9, (%edi, %ecx, 1)
et_add:
    push $size
    push $id
    push $func
    push $formatScanf
    call scanf
    add $16, %esp
    push id
    push size
    push $memory
    push memory_slots
    call add
    add $16, %esp
    jmp et_afisare
et_afisare:
    push $memory
    push memory_slots
    call afisare_vec
    add $8, %esp
    push $formatEndline
    call printf
    add $4, %esp
    mov func, %eax
    cmp $1, %eax
    je et_add    
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80