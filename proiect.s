.data
    memory:.space 1024
    memory_slots: .long 300
    formatPrintf: .asciz "%ld, "
    formatEndline:.asciz "\n"
    formatScanf: .asciz "%ld\n %ld\n"
    id: .space 4
    pozStart:.space 4
    pozEnd:.space 4
    size: .space 1
    needed_Blocks: .space 4
    rez:.long 4
    func:.long 4
    formatInput: .asciz "%ld\n"
    formatAddPrint: .asciz  "%ld: (%ld,%ld)\n"
    formatGetPrint: .asciz  "(%ld,%ld)\n"
    nrFisiere: .space 4
    formatGetNotfound: .asciz "Descriptor not found: %ld\n"
.text
.global main
add:
    push %ebp
    mov %esp, %ebp
    movl 16(%ebp), %eax
    movl $-1, pozStart
    movl $-1, pozEnd
    xor %edx, %edx
    movl $8, %ecx
    idiv %ecx
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %ebx
    mov $0, %ebx
    cmp $0, %edx
    je parcurgere
    inc %eax
parcurgere:
    xor %edx, %edx
    cmp 8(%ebp), %ecx
    je end_add
    cmp %eax, %ebx
    je poz_impl
    movb (%edi, %ecx, 1), %dl
    inc %ecx
    cmpb $0, %dl
    je incrementare
    jmp reinit
reinit:
    mov $0, %ebx
    jmp parcurgere
incrementare:
    inc %ebx
    jmp parcurgere
    #pushl $0
    #call fflush
    #add $4, %esp
poz_impl:
    dec %ecx
    mov %ecx, pozEnd
    mov %ecx, pozStart
    dec %eax
    subl %eax, pozStart 
    inc %eax
    jmp adaugare
adaugare:
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
get:
    push %ebp
    mov %esp, %ebp
    push %edi
    mov 12(%ebp), %edi
    xor %ecx, %ecx
    mov 16(%ebp), %eax
    movl $-1, pozStart
    movl $-1, pozEnd
get_parcurgere:
    xor %edx, %edx
    cmp 8(%ebp), %ecx
    je get_ret
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    je capat_st
    inc %ecx
    jmp get_parcurgere
capat_st:
    movl %ecx, pozStart
    jmp capat_dr
capat_dr:
    inc %ecx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    jne get_ret
    jmp capat_dr
get_ret:
    dec %ecx
    mov %ecx, pozEnd
    pop %edi
    pop %ebp
    ret
main:
    push $func
    push $formatInput
    call scanf
    add $8, %esp
    mov func, %ecx
    cmp $1, %ecx
    je case_add
    cmp $2, %ecx
    je et_get
    jmp et_ret
case_add:
    push $nrFisiere
    push $formatInput
    call scanf
    add $8, %esp
    jmp et_add
et_add:
    push $size
    push $id
    push $formatScanf
    call scanf
    add $12, %esp
    push id
    push size
    push $memory
    push memory_slots
    call add
    add $16, %esp
    jmp et_afisare_add
et_afisare_add:
    push pozEnd
    push pozStart
    push id
    push $formatAddPrint
    call printf
    add $16, %esp
    mov nrFisiere, %eax
    dec %eax
    mov %eax, nrFisiere
    cmp $0, %eax 
    je main
    jmp et_add
et_get:
    push $id
    push $formatInput
    call scanf
    add $8, %esp
    push id
    push $memory
    push memory_slots
    call get
    add $12, %esp
    movl pozStart, %eax
    cmp $-1, %eax
    je getNoFound
    push pozEnd
    push pozStart
    push $formatGetPrint
    call printf
    add $16, %esp
    jmp et_ret
getNoFound:
    push id
    push $formatGetNotfound
    call printf
    add $8, %esp
    jmp et_ret
et_afisare:
    push $memory
    push memory_slots
    call afisare_vec
    add $8, %esp
    push $formatEndline
    call printf
    add $4, %esp
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80