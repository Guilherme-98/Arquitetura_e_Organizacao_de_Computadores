.data
tamanhoMatriz: .asciiz "Ordem da matriz: "
entradaMatriz: .asciiz "Insira o valor de matriz["
entradaMatriz2: .asciiz "]["
entradaMatriz3: .asciiz "]: "
false: .asciiz "Nao e matriz de permutacao"
true: .asciiz "E matriz de permutacao"

debug1: .asciiz "\n percorreColuna\n"

.text
	
main:	la $a0, tamanhoMatriz	
	li $v0, 4		
	syscall			
	
	li $v0, 5		
	syscall			
	
	move $a1, $v0		
	move $a2, $v0		
	
	mul $a0, $v0, 4		
	li $v0, 9		
	syscall			
	
	la $a0, ($v0)		
	
	jal leitura		
	
	move $a0, $v0		
	
	jal percorreLinhas	
	
	move $a0, $v0		
	
	jal percorreColunas	
	
	la $a0, true		
	li $v0, 4		
	syscall			
	
	li $v0, 10		
	syscall			

indice:	mul $v0, $t0, $a2
	add $v0, $v0, $t1	
	sll $v0, $v0, 2		
	add $v0, $v0, $a3	
	jr $ra			

leitura:subi $sp, $sp, 4	
	sw $ra, ($sp)		
	move $a3, $a0	
	
l:	la $a0, entradaMatriz	
	li $v0, 4		
	syscall			
	
	move $a0, $t0		
	li $v0, 1		
	syscall			
	
	la $a0, entradaMatriz2	
	li $v0, 4		
	syscall			
	
	move $a0, $t1	
	li $v0, 1		
	syscall			
	
	la $a0, entradaMatriz3	
	li $v0, 4		
	syscall			
	
	li $v0, 5		
	syscall		
	
	move $t2, $v0		
	
	jal indice		
	
	sw $t2, ($v0)		
	
	addi $t1, $t1, 1	
	blt $t1, $a2, l		
	li $t1, 0		
	
	addi $t0, $t0, 1	
	blt $t0, $a1, l		
	li $t0, 0		
	
	lw $ra, ($sp)		
	addi $sp, $sp, 4	
	move $v0, $a3		
	jr $ra

percorreLinhas:
	subi $sp, $sp, 4	
	sw $ra, ($sp)		
	move $a3, $a0		
	li $s0, 0		
	li $t7, 0		
	
pL:	jal indice		

	lw $t7, ($v0)		
	
	add $s0, $s0, $t7	
	
	addi, $t1, $t1, 1	
	
	blt $t1, $a2, pL	
	
	bne $s0, 1, notTrue	
	
	li $s0, 0		
	
	li $t1, 0		
	
	addi $t0, $t0, 1	
	
	blt $t0, $a1, pL	
	
	li $t0, 0		
	
	lw $ra, ($sp)		
	addi $sp, $sp, 4	
	move $v0, $a3		
	jr $ra 			
	
notTrue:la $a0, false		
	li $v0, 4		
	syscall			
	
	#temp
	move $a0, $s0		
	li $v0, 1		
	syscall			
	#temp
	
	li $v0, 10		
	syscall			
	
percorreColunas:
	subi $sp, $sp, 4	
	sw $ra, ($sp)		
	move $a3, $a0		
	li $s0, 0		
	li $t0, 0		
	li $t1, 0		
	li $t7, 0		
	
pC:	jal indice		

	lw $t7, ($v0)		
	
	add $s0, $s0, $t7	
	
	addi, $t0, $t0, 1	
	
	blt $t0, $a1, pC	
	
	bne $s0, 1, notTrue	

	li $s0, 0		
	
	li $t0, 0		
	
	addi $t1, $t1, 1	
	
	blt $t1, $a2, pC	
	
	li $t1, 0		
	
	lw $ra, ($sp)		
	addi $sp, $sp, 4	
	move $v0, $a3		
	jr $ra 			