.data
vetA: .space 40
vetB: .space 40
entradaA: .asciiz "Insira VetA["
entradaB: .asciiz "Insira vetB["
entradaAux: .asciiz "]: "
saidaA: .asciiz "Somatoria dos elementos em posicoes pares do VetA: "
saidaB: .asciiz "Somatoria dos elementos em posicoes impares do VetB: "
breakLine: .asciiz "\n"

.text
main: 	
	li $s0, 0		
	li $s1, 0		
	la $a0, vetA		
	jal scanA		
	
	la $a0, vetB		
	jal scanB		
	
	la $a0, vetA		
	jal sumPairs		
	
	la $a0, vetB		
	jal sumOdd		
	
	move $a0, $s0		
	jal printSumP		
	
	move $a0, $s1		
	jal printSumO		
	
	j exit			

scanA:	
	move $t0, $a0		
	move $t1, $t0		
	li $t2, 0		
lA:	la $a0, entradaA	
	li $v0, 4		
	syscall			
	
	move $a0, $t2 		
	li $v0, 1		
	syscall			
	
	la $a0, entradaAux	
	li $v0, 4		
	syscall			
	
	li $v0, 5		
	syscall			
	
	sw $v0, ($t1)		
	addi $t1, $t1, 4	
	addi $t2, $t2, 1	
	blt $t2, 10, lA		
	move $v0, $t0		
	jr $ra			
	
scanB:	
	move $t0, $a0		
	move $t1, $t0		
	li $t2, 0		
lB:	la $a0, entradaB	
	li $v0, 4		
	syscall			
	
	move $a0, $t2 		
	li $v0, 1		
	syscall			
	
	la $a0, entradaAux	
	li $v0, 4		
	syscall			
	
	li $v0, 5	
	syscall			
	
	sw $v0, ($t1)		
	addi $t1, $t1, 4	
	addi $t2, $t2, 1	
	blt $t2, 10, lB		
	move $v0, $t0		
	jr $ra			
	
sumPairs:
	move $t0, $a0		
	move $t1, $t0		
	li $t2, 0		
pair:	lw $t3, ($t1)		
	add $s0, $s0, $t3	
	addi $t1, $t1, 8	
	addi $t2, $t2, 2	
	blt $t2, 10, pair	
	move $v0, $t0	
	jr $ra			
	
sumOdd:
	move $t0, $a0		
	move $t1, $t0		
	add $t1, $t1, 4		
	li $t2, 1		
odd:	lw $t3, ($t1)		
	add $s1, $s1, $t3	
	addi $t1, $t1, 8	
	addi $t2, $t2, 2	
	blt $t2, 10, odd	
	move $v0, $t0		
	jr $ra			
	
printSumP:
	move $t0, $a0		
	la $a0, saidaA		
	li $v0, 4		
	syscall			
	
	move $a0, $t0		
	li $v0, 1		
	syscall			
	
	la $a0, breakLine	
	li $v0, 4		
	syscall			
	
	jr $ra			
	
printSumO:
	move $t0, $a0		
	la $a0, saidaB		
	li $v0, 4		
	syscall			
	
	move $a0, $t0		
	li $v0, 1		
	syscall			
	
	jr $ra			
	
exit:	
	li $v0, 10		
	syscall			