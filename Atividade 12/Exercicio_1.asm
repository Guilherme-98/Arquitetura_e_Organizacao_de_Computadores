.data
entradaN: .asciiz "Insira o numero de posicoes do vetor: "
entradaVet: .asciiz "Insira vet["
entradaAux: .asciiz "]: "
saida: .asciiz "O valor "
saida1: .asciiz " aparece "
saida2: .asciiz " vez(es)!\n"

.text

#variáveis
#	$s0 = tamanho do vetor
#	$s1 = endereço base do vetor
#	$s7 = null

li $s7, 0xFFFFFFF

main:
	jal n
	move $s0, $v0		
	
	move $a0, $s0		
	jal alloc
	move $s1, $v0 		
	
	move $a0, $s1		
	move $a1, $s0		
	jal scanVet
	
	move $a0, $s1		
	move $a1, $s0		
	jal frequency
	
	j exit
	 
n:
	la $a0, entradaN
	li $v0, 4		
	syscall
	
	li $v0, 5		
	syscall
	
	jr $ra
	
alloc:
	mul $a0, $a0, 4		
	li $v0, 9		
	syscall
	
	jr $ra

scanVet:
	move $t0, $a0		
	move $t1, $t0		
	li $t2, 0		
	move $t3, $a1		
	
l:	la $a0, entradaVet	
	li $v0, 4		
	syscall
	
	move $a0, $t2
	li $v0, 1		
	syscall
	
	la $a0, entradaAux
	li $v0 4		
	syscall
	
	li $v0, 5		
	syscall
	
	sw $v0, ($t1)		
	addi $t1, $t1, 4	
	addi $t2, $t2, 1	
	
	blt $t2, $t3, l		
	
	jr $ra
	
frequency:
	move $t0, $a0		
	move $t1, $t0		
	move $t2, $a1		
	li $t3, 0		
	
l1:	mul $t1, $t3, 4
	add $t1, $t1, $t0	
	lw $t4, ($t1)		
	beq $t4, $s7, eIf	
	
	li $t5, 0		
	move $t6, $t0		
	li $t7, 0		
	
l2:	mul $t6, $t7, 4
	add $t6, $t6, $t0
	lw $t8, ($t6)		
	
	bne $t4 $t8, eIf2
	addi $t5, $t5, 1	
	sw $s7, ($t6)		
	
eIf2:	addi $t7, $t7, 1	
	blt $t7, $t2, l2
	
	la $a0, saida
	li $v0, 4
	syscall
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	la $a0, saida1
	li $v0, 4
	syscall
	
	move $a0, $t5
	li $v0, 1
	syscall
	
	la $a0, saida2
	li $v0, 4
	syscall
	
eIf:	addi $t3, $t3, 1	
	blt $t3, $t2, l1	
	
	jr $ra

exit:
	li $v0, 10
	syscall