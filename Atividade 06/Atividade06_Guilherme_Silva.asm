.data
	vetor: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	N: .word 10
	msg1: .asciiz "\nMaior número do vetor: "
	msg2: .asciiz "\nMenor número do vetor: "
	msg3: .asciiz "\nNúmero de elementos pares do vetor: "
	msg4: .asciiz "\nMaior número par do vetor: "
	msg5: .asciiz "\nMenor número impar do vetor: "
	msg6: .asciiz "\nSoma dos números ímpares do vetor: "
	msg7: .asciiz "\nProduto dos números pares do vetor: "
	
.text

main:
	la $a0, vetor       
    	lw $a1, N       
    	
    	li $t8, 0		
    	lw $s0, vetor($t8) 		
	lw $s1, vetor($t8) 		
    	li $s2, 1		
	li $s3, 0		
	li $s4, 0		
	lw $s5, vetor($t8) 	
	lw $s6, vetor($t8) 	 	
    	
    	jal leitura  
    	li $v0, 10      
    	syscall 

leitura:
    li $t0, 0       		
    li $t1, 0       		

loop:	
    bge $t0, $a1, display 	
    lw $a0, vetor($t1) 		
    
    div $t9, $a0, 2		
	mfhi $t9		
	
	beq $t9, $zero, par	
	add $s3, $s3, $a0
	j contador
	
	par: add $s4, $s4, 1
	mul $s2, $s2, $a0
    
    
    blt $a0, $s1, novo_minimo	
    j verificador_maximo
    
    novo_minimo: 
    	move $s1, $a0		
    	div $t9, $a0, 2		
	mfhi $t9		
	
	bne $t9, $zero,menor_impar	
	j contador
	
   menor_impar: 
   	move $s6, $a0	
   	j contador
	
    
    verificador_maximo:
    bgt $a0, $s0, novo_maximo
    j contador
    
    novo_maximo: 
    	move $s0, $a0	
    	div $t9, $a0, 2	
	mfhi $t9		
	
	beq $t9, $zero, maiorPar	
	j contador

    maiorPar: move $s5, $a0	
    
contador:
    addi $t1, $t1, 4    	
    addi $t0, $t0, 1    	
    b loop   	

display:
	# Maior número
	li $v0, 4		
	la $a0, msg1
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	# Menor número
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	# Soma dos elemtnos ímpares
	li $v0, 4
	la $a0, msg6
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	# Quantidade numeros pares
	li $v0, 4
	la $a0, msg3
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	# Maior número par
	li $v0, 4
	la $a0, msg4
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	# Menor numero impar
	li $v0, 4
	la $a0, msg5
	syscall
	
	li $v0, 1
	move $a0, $s6
	syscall
	
	# Produto de números pares
	li $v0, 4
	la $a0, msg7
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	jr $ra		
