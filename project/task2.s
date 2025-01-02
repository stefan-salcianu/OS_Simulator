.data
    memory:.space 1048576 
    cp_memory: .space 2044
    memory_slots: .long 1048575
    pozDefrag: .long 0
    lineStart: .long 0
    colStart: .long 0
    lineEnd: .long 0
    colEnd: .long 0
    copie: .space 4
    indiceCopie: .long 0
    indiceCopie2: .long 0
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
    formatAddPrint: .asciz  "%ld: ((%ld, %ld), (%ld, %ld))\n"
    formatGetPrint: .asciz  "((%ld, %ld), (%ld, %ld))\n"
    nrFisiere: .space 4
    formatNotfound: .asciz "Descriptor not found: %ld\n"
    Op: .space 4
    done: .long 0
    path: .space 150
    path1: .asciz "/home/stefan/laborator_asc/asc_project"  #; Path to the directory (null-terminated string)                      ; Buffer for file name (reserves 256 bytes)
    fileDesc: .asciz "Descriptor: %d\n"      #; Format for printing file descriptor (with newline)
    fileSize: .asciz "Size: %d KB\n"
    fileFormat: .asciz "file%d.txt\n"
    formatInputString: .asciz "%s\n"
    buffer: .space 256
    dirDescriptor:.space 1
.text
.global main
add:
    push %ebp
    mov %esp, %ebp
    movl 16(%ebp), %eax
    movl $0, colStart
    movl $0, colEnd
    movl $0, lineStart
    movl $0, lineEnd
    movl $0, %edx
    movl $8, %ecx
    idiv %ecx
    movl $0, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %ebx
    mov $0, %ebx
    cmp $0, %edx
    je parcurgere
    inc %eax
parcurgere:
    cmp $1025, %eax
    jge end_add
    cmp 8(%ebp), %ecx
    je end_add
    cmp %eax, %ebx
    je poz_impl
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    inc %ecx
    cmp $0, %edx
    je incrementare
    jmp reinit
reinit:
    mov $0, %ebx
    movl $0, %edx
    movl colEnd, %edx
    add $1, %edx
    mov %edx, colEnd
    cmp $1024, %edx
    je reinitIndex
    jmp parcurgere
incrementare:
    addl $1, %ebx
    movl $0, %edx
    movl colEnd, %edx
    add $1, %edx
    mov %edx, colEnd
    cmp $1024, %edx
    je reinitIndex
    jmp parcurgere
reinitIndex:
    movl lineEnd, %edx
    add $1, %edx
    mov %edx, lineEnd
    mov %edx, lineStart
    movl $0, %edx
    mov %edx, colEnd
    cmp %ebx, %eax
    je poz_impl
    movl $0, %ebx
    jmp parcurgere
poz_impl:
    subl $1, %ecx
    mov %ecx, pozEnd
    mov %ecx, pozStart
    subl $1, %eax
    subl %eax, pozStart
    add $1, %eax 
    mov colEnd, %edx
    cmp $0, %edx
    je index0
    jmp verif
index0:
    movl $1024, %edx
    mov %edx, colEnd
    movl lineEnd, %edx
    sub $1, %edx
    mov %edx, lineEnd
    mov %edx, lineStart
    jmp verif
verif:
    
    mov colEnd, %edx
    subl $1, %edx
    mov %edx, colStart
    mov %edx, colEnd
    dec %eax
    subl %eax, colStart
    inc %eax
    xor %edx, %edx
    mov colStart, %edx
    cmp $0, %edx
    jge adaugare
    jmp inc_ecx

inc_ecx:
    add $2, %ecx
    movl $0, %edx
    movl colEnd, %edx
    add $2, %edx
    mov %edx, colEnd
    cmp $1024, %edx
    je reinitIndex
    jmp parcurgere
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
add_defrag:
    push %ebp
    mov %esp, %ebp
    movl pozDefrag, %eax
    movl $0, %edx
    movl $1024, %ecx
    idiv %ecx
    movl %eax, lineStart
    movl %edx, colEnd
    movl %eax, lineEnd
    movl 16(%ebp), %eax
    movl $0, %edx
    movl $8, %ecx
    idiv %ecx
    movl pozDefrag, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %ebx
    mov $0, %ebx
    cmp $0, %edx
    je parcurgere_defrag
    inc %eax
parcurgere_defrag:
    cmp $1025, %eax
    jge end_add_defrag
    cmp 8(%ebp), %ecx
    je end_add_defrag
    cmp %eax, %ebx
    je poz_impl_defrag
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    inc %ecx
    cmp $0, %edx
    je incrementare_defrag
    jmp reinit_defrag
reinit_defrag:
    mov $0, %ebx
    movl $0, %edx
    movl colEnd, %edx
    add $1, %edx
    mov %edx, colEnd
    cmp $1024, %edx
    je reinitIndex_defrag
    jmp parcurgere_defrag
incrementare_defrag:
    addl $1, %ebx
    movl $0, %edx
    movl colEnd, %edx
    add $1, %edx
    mov %edx, colEnd
    cmp $1024, %edx
    je reinitIndex_defrag
    jmp parcurgere_defrag
reinitIndex_defrag:
    movl lineEnd, %edx
    add $1, %edx
    mov %edx, lineEnd
    mov %edx, lineStart
    movl $0, %edx
    mov %edx, colEnd
    jmp parcurgere_defrag
poz_impl_defrag:
    subl $1, %ecx
    mov %ecx, pozEnd
    mov %ecx, pozStart
    subl $1, %eax
    subl %eax, pozStart
    add $1, %eax 
    mov colEnd, %edx
    cmp $0, %edx
    je index0_defrag
    jmp verif_defrag
index0_defrag:
    movl $1024, %edx
    mov %edx, colEnd
    movl lineEnd, %edx
    sub $1, %edx
    mov %edx, lineEnd
    mov %edx, lineStart
    jmp verif_defrag
verif_defrag:
    mov colEnd, %edx
    subl $1, %edx
    mov %edx, colStart
    mov %edx, colEnd
    dec %eax
    subl %eax, colStart
    inc %eax
    xor %edx, %edx
    mov colStart, %edx
    cmp $0, %edx
    jge adaugare_defrag
    jmp inc_ecx_defrag

inc_ecx_defrag:
    add $2, %ecx
    movl $0, %edx
    movl colEnd, %edx
    add $2, %edx
    mov %edx, colEnd
    cmp $1024, %edx
    je reinitIndex_defrag
    jmp parcurgere_defrag
adaugare_defrag:
    cmp $0, %eax
    je end_add_defrag
    mov 20(%ebp), %dl
    movb %dl, (%edi, %ecx, 1)
    dec %ecx
    dec %eax
    jmp adaugare_defrag
end_add_defrag:
    movl colEnd, %edx
    addl %ecx, %edx
    subl colStart, %edx
    movl %edx, pozDefrag
    pop %ebx
    pop %edi
    pop %ebp
    ret
afisare_matrix:
    push %ebp
    mov %esp, %ebp
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %ebx
    mov $0, %ebx
afisare:
    #cmp 8(%ebp), %ecx
    cmp $18432, %ecx
    je end
    xor %edx, %edx
    movb (%edi, %ecx, 1), %dl
    pusha
    push %edx
    push $formatPrintf
    call printf
    add $8, %esp
    pushl $0
    call fflush
    add $4, %esp
    popa 
    cmp $1023, %ebx
    je lineDone
    inc %ebx
    inc %ecx
    jmp afisare
lineDone:
    pusha
    push $formatEndline
    call printf
    add $4, %esp
    pushl $0
    call fflush
    add $4, %esp
    popa
    mov $0, %ebx
    inc %ecx
    jmp afisare
    
end:
    pop %ebx
    pop %edi
    pop %ebp
    ret
afisare_fancy:
    push %ebp
    mov %esp, %ebp
    xor %ecx, %ecx
    push %edi
    mov 12(%ebp), %edi
    push %ebx
    movl $0, %ebx
    movl $-1, pozStart
    movl $-1, pozEnd
    movl $0, colStart
    movl $0, colEnd
    movl $0, lineStart
    movl $0, lineEnd
parc:
    cmp 8(%ebp), %ecx
    je end_ret
    mov %ebx, colStart
    cmp $1024, %ebx
    jge r_index
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmpb $0, %dl
    jne st
    add $1, %ecx
    add $1, %ebx
    jmp parc
r_index:
    movl lineEnd, %edx
    add $1, %edx
    mov %edx, lineEnd
    mov %edx, lineStart
    movl $0, %ebx
    mov %ebx, colStart
    jmp parc

st:
    movl %ebx, colStart
    movl %ecx, pozStart
    mov %edx, %eax
    jmp dr
dr:
    inc %ecx
    inc %ebx
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    jne afis
    jmp dr
afis:
    dec %ecx
    dec %ebx
    mov %ebx, colEnd
    pusha
    push colEnd
    push lineEnd
    push colStart
    push lineStart
    push %eax
    push $formatAddPrint
    call printf
    add $24, %esp
    pushl $0
    call fflush
    add $4, %esp
    popa
    inc %ecx
    inc %ebx
    jmp parc
end_ret:
    pop %ebx
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
    push %ebx
    movl $0, %ebx
    movl $-1, pozStart
    movl $-1, pozEnd
    movl $0, colStart
    movl $0, colEnd
    movl $0, lineStart
    movl $0, lineEnd
get_parcurgere:
    xor %edx, %edx
    cmp 8(%ebp), %ecx
    je get_ret
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    je capat_st
    inc %ecx
    inc %ebx
    mov %ebx, colStart
    cmp $1024, %ebx
    je re_index
    jmp get_parcurgere
re_index:
    mov $0, %ebx
    mov %ebx, colStart
    mov lineEnd, %edx
    add $1, %edx
    mov %edx, lineEnd
    mov %edx, lineStart
    jmp get_parcurgere
capat_st:
    movl %ecx, pozStart
    jmp capat_dr
capat_dr:
    inc %ecx
    inc %ebx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    jne get_ret
    jmp capat_dr
get_ret:
    dec %ebx
    mov %ebx, colEnd
    pop %ebx
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
del_parcurgere:
    cmp 8(%ebp), %ecx
    je del_ret
    mov $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    je capat_dreapta
    inc %ecx
    jmp del_parcurgere
capat_dreapta:
    movb $0, (%edi, %ecx, 1)
    add $1, %ecx
    movb (%edi, %ecx, 1), %dl
    cmp %edx, %eax
    jne del_ret
    jmp capat_dreapta
del_ret:
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
    movl $0, indiceCopie
def:
    cmp 8(%ebp), %ecx
    jge defragmentation_ret
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmpb $0, %dl
    jne cpt_stanga
    add $1, %ecx
    jmp def
cpt_stanga:
    mov %edx, %eax
cpt_dreapta:
    movl $0, %edx
    movb (%edi, %ecx, 1), %dl
    cmp %eax, %edx
    jne copy
    movb $0, (%edi, %ecx, 1)
    inc %ecx
    add $1, %ebx
    jmp cpt_dreapta
copy:          
    movl indiceCopie, %edx
    movl %eax, (%esi,%edx, 4)
    #pusha
    #push %edx
    #push $formatPrintf
    #call printf
    #add $8, %esp
    #popa
    addl $1, %edx
    movl %ebx, (%esi,%edx, 4)
    #pusha
    #push %ebx
    #push $formatPrintf
    #call printf
    #add $8, %esp
    #popa
    addl $1, %edx
    movl $0, (%esi, %edx, 4)
    movl %edx, indiceCopie
    movl $0, %ebx
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
    mov $cp_memory, %esi
    mov $0, %ecx
    jmp init_cp_memory
init_cp_memory:
    cmp $511, %ecx
    je tasks
    #pusha
    #push %ecx
    #push $formatPrintf
    #call printf
    #add $8, %esp
    #popa
    movl $0, (%esi, %ecx, 4)
    addl $1, %ecx
    jmp init_cp_memory
tasks:
    movl Op, %eax
    cmp $0, %eax
    je et_ret
    dec %eax
    movl %eax, Op
    #pusha
    #push $formatEndline
    #call printf
    #add $4, %esp
    #popa
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
    cmp $5, %ecx
    je et_concrete
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
    push colEnd
    push lineEnd
    push colStart
    push lineStart
    push id
    push $formatAddPrint
    call printf
    add $24, %esp
    pushl $0
    call fflush
    add $4, %esp
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
    push colEnd
    push lineEnd
    push colStart
    push lineStart
    push $formatGetPrint
    call printf
    add $20, %esp
    pushl $0
    call fflush
    add $4, %esp
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
    jmp et_afisare
NotFound:
    movl $0, colEnd
    movl $0, colStart
    movl $0, lineEnd
    movl $0, lineStart
    push colEnd
    push lineEnd
    push colStart
    push lineStart
    push $formatGetPrint
    call printf
    add $20, %esp
    pushl $0
    call fflush
    add $4, %esp
    jmp tasks

et_defragmentation:
    push $cp_memory
    push $memory
    push memory_slots
    call defragmentation
    add $12, %esp
    mov $cp_memory, %edi
    movl $0, %ecx
    movl $0, indiceCopie2
    #pusha
    #push $cp_memory
    #push memory_slots
    #call afisare_matrix
    #add $8, %esp
    #popa
    movl $0, pozDefrag
    
et_add_defragmentation:
    movl indiceCopie2, %ecx
    cmp $512, %ecx
    je tasks
    movl $0, %edx
    movl (%edi, %ecx, 4), %edx
    cmpl $0, %edx
    je tasks
    #pusha
    #push %ecx
    #push $formatPrintf
    #call printf
    #add $8, %esp
    #popa
    mov %edx, id
    movl $0, (%edi, %ecx, 4)
    addl $1, %ecx
    movl (%edi, %ecx, 4), %eax
    movl $0, %edx
    movl $8, %ebx
    mul %ebx
    mov %eax, size
    movl $0, (%edi, %ecx, 4)
    addl $1, %ecx
    mov %ecx, indiceCopie2
    push id
    push size
    push $memory
    push memory_slots
    call add_defrag
    add $16, %esp
    jmp et_afisare_add_defgram
et_afisare_add_defgram:
    pusha
    push colEnd
    push lineEnd
    push colStart
    push lineStart
    push id
    push $formatAddPrint
    call printf
    add $24, %esp
    popa
    pushl $0
    call fflush
    add $4, %esp
    jmp et_add_defragmentation
et_concrete: 
    push $path
    push $formatInputString
    call scanf
    add $8, %esp
    push $path
    push $formatInputString
    call printf
    add $8, %esp
    movl $4, %ecx
    movl $0, %ebx
et_concrete_loop:
    lea buffer(%ebx), %eax
    push %ecx
    push %ebx
    push $fileFormat
    call printf
    add $8, %esp
    pop %ecx
    #push $path
    #push %eax
    #call strcat
    #add $8, %esp
    push %ecx
    push $path
    push $formatInputString
    call printf
    add $8, %esp
    mov $5, %eax
    lea buffer, %ebx
    pop %ecx
    addl $1, %ebx
    loop et_concrete_loop
et_finish:
    jmp et_ret
et_afisare:
    push $memory
    push memory_slots
    call afisare_fancy
    add $8, %esp
    jmp tasks
et_ret:
    #push $formatEndline
    #call printf
    #add $4, %esp
    #push $memory
    #push memory_slots
    #call afisare_matrix
    #add $8, %esp
    pushl $0
    call fflush
    add $4, %esp
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80