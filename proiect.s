.data
    memory:.space 1024
    cp_memory: .space 1024
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
    formatNotfound: .asciz "Descriptor not found: %ld\n"
    Op: .space 4
    done: .long 0
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
afisare_fancy:
    push %ebp
    mov %esp, %ebp
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
    movl $-1, pozStart
    movl $-1, pozEnd
parc:
    cmp 8(%ebp), %ecx
    jge end_ret
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmpb $0, %dl
    jne st
    add $1, %ecx
    jmp parc
st:
    movl %ecx, pozStart
    mov %edx, %eax
    jmp dr
dr:
    inc %ecx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    jne afis
    jmp dr
afis:
    dec %ecx
    mov %ecx, pozEnd
    pusha
    push pozEnd
    push pozStart
    push %eax
    push $formatAddPrint
    call printf
    add $16, %esp
    popa
    inc %ecx
    jmp parc
end_ret:
    pop %edi
    pop %ebx
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
delete:
    push %ebp
    mov %esp, %ebp
    push %edi
    mov 12(%ebp), %edi
    xor %ecx, %ecx
    mov 16(%ebp), %eax
    movl $-1, pozStart
    movl $-1, pozEnd
del_parcurgere:
    cmp 8(%ebp), %ecx
    je del_ret
    mov $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    je capat_stanga
    inc %ecx
    jmp del_parcurgere
capat_stanga:
    movl %ecx, pozStart
    jmp capat_dreapta
capat_dreapta:
    movb $0, (%edi, %ecx, 1)
    add $1, %ecx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    jne del_ret
    jmp capat_dreapta
del_ret:
    dec %ecx
    mov %ecx, pozEnd
    pop %edi
    pop %ebp
    ret
defragmentation:
    push %ebp
    mov %esp, %ebp
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %esi
    mov 16(%ebp), %esi
    push %ebx
    mov $0, %ebx
def:
    cmp 8(%ebp), %ecx
    je defragmentation_ret
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmp $0, %dl
    jne copy
    add $1, %ecx
    jmp def
copy:             
    movb %dl, (%esi, %ebx, 1) 
    inc %ecx                  
    inc %ebx                  
    jmp def                
defragmentation_ret:
    pop %ebx
    pop %esi
    pop %edi 
    pop %ebp
    ret

main:
    push $Op
    push $formatInput
    call scanf
    add $8, %esp
tasks:
    movl Op, %eax
    cmp $0, %eax
    je et_ret
    dec %eax
    movl %eax, Op
    push $func
    push $formatInput
    call scanf
    add $8, %esp
    mov func, %ecx
    cmp $1, %ecx
    je case_add
    cmp $2, %ecx
    je et_get
    cmp $3, %ecx
    je et_delete
    cmp $4, %ecx
    je et_defragmentation
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
    je tasks
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
    je NotFound
    push pozEnd
    push pozStart
    push $formatGetPrint
    call printf
    add $16, %esp
    cmpl $3, func
    je et_delete
    jmp tasks

et_delete:
    push $id
    push $formatInput
    call scanf
    add $8, %esp
    push id
    push $memory
    push memory_slots
    call delete
    add $12, %esp
    movl pozStart, %eax
    cmp $-1, %eax
    je NotFound
    jmp et_afisare
NotFound:
    push id
    push $formatNotfound
    call printf
    add $8, %esp
    jmp tasks

et_defragmentation:
    push $cp_memory
    push $memory
    push memory_slots
    call defragmentation
    add $12, %esp
    mov $cp_memory, %edi
    mov $memory, %esi
    mov $0, %ecx
    
update_memory:
    cmp %ecx, memory_slots
    je et_afisare
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    movb %dl, (%esi, %ecx, 1)
    add $1, %ecx
    jmp update_memory
et_afisare:
    push $memory
    push memory_slots
    call afisare_fancy
    add $8, %esp
    jmp tasks
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80