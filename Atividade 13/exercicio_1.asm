.data
Cpf: .space 32
Ent0: .asciiz "Informe o CPF: "
Sai0: .asciiz "CPF valido."
Sai1: .asciiz "CPF invalido."

.text
main:
    la $a0, Ent0 
    li $v0, 4 
    syscall 
    la $a0, Cpf 
    li $a1, 32 
    li $v0, 8 
    syscall 
    jal validacao
    li $v0, 10 
    syscall 
    
validacao:
    li $t0, 0 
    move $t1, $a0 
    li $t8, 10 
    li $t9, 11 
validacao_loop:
    lb $t4, ($t1) 
if1:
    bge $t0, 9, if2 
    subi $t5, $t4, '0' 
    sub $t6, $t8, $t0 
    mul $t7, $t5, $t6 
    add $t2, $t2, $t7 
    addi $t6, $t6, 1 
    mul $t7, $t5, $t6 
    add $t3, $t3, $t7
    j validacao_prox
if2:
    bne $t0, 9, if3
    bne $t4, '-', validacao_falsa
    j validacao_prox
if3:
    bne $t0, 10, if4 
    div $t2, $t9 
    mfhi $t5 
    if3_1:
        bge $t5, 2, if3_2 
        li $s0, '0' 
        j if3_3
    if3_2:
        sub $s0, $t9, $t5 
        sll $t5, $s0, 1 
        add $t3, $t3, $t5 
         addi $s0, $s0, '0' 
    if3_3:
        bne $s0, $t4, validacao_falsa 
        j validacao_prox
if4:
    bne $t0, 11, if5 
    div $t3, $t9 
    mfhi $t5
    if4_1:
        bge $t5, 2, if4_2 
        li $s1, '0' 
        j if4_3
    if4_2:
        sub $s1, $t9, $t5 
        addi $s1, $s1, '0' 
    if4_3:
        bne $s1, $t4, validacao_falsa 
        j validacao_prox
if5:
    bne $t4, '\n', validacao_falsa 
    j validacao_verdadeira
validacao_prox:
    addi $t0, $t0, 1 
    addi $t1, $t1, 1 
    bnez $t4, validacao_loop
validacao_falsa:
    la $a0, Sai1 
    li $v0, 4 
    syscall 
    jr $ra 
validacao_verdadeira:
    la $a0, Sai0 
    li $v0, 4 
    syscall 
    jr $ra
