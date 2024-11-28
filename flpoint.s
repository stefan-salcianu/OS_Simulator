.data
    x:.float 2.718281828
    logResult: .space 4  
    logFormat: .asciz "Nr este: %f\n"  
.text
.global main
main:
    push x
    call logf
    fstps logResult
    add $4, %esp
    push logResult
    push $logFormat
    call printf
    add $8, %esp
et_ret:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80