 
.data

buffer:		.asciiz " "
arquivo:	.asciiz "dados1.txt"
erro:		.asciiz "Arquivo nao encontrado\n"
soma:		.asciiz "Soma: "
multiplicacao:	.asciiz " Multiplicacao: "
pares:		.asciiz " Pares: "
impares:	.asciiz " Impares: "
caracteres:	.asciiz " Caracteres: "
maior:		.asciiz " Maior:"
menor:		.asciiz " Menor:"

.text

main:		la $a0, arquivo		
		li $a1, 0 		
		jal abertura		
		
		move $s0, $v0		
		move $a0, $s0		
		
		la $a1, buffer		
		li $a2, 1		
 
		jal somar		
		
		jal reabrirArquivo	
		
		jal multiplicar		
		
		jal reabrirArquivo	
		
		jal numerosPares	
		
		jal reabrirArquivo	
		
		jal contagem		
		
		jal reabrirArquivo	
		
		jal getPrimeiro		
		
		move $s1, $v0		
		
		jal reabrirArquivo	
		
		jal getMaior		
		
		jal reabrirArquivo	
		
		jal getPrimeiro		
		
		move $s1, $v0		
		
		jal getMenor		
		
		jal fecharArquivo	
		
		j finalizar		
		
abertura:	li $v0, 13		
		syscall			
		bgez $v0, aberto	
		
		la $a0, erro		
		li $v0, 4		
		syscall			
		
		j finalizar		
		
aberto:		jr $ra			
		
somar:		li $t0, 0	
		li $t1, 0		
		li $t2, 0		
		li $t3, 0		

inicioS:	li $v0, 14		
		syscall			
		beqz $v0, fimS		
		lb $t0, ($a1)		
		beq $t0, 13, inicioS	
		beq $t0, 10, s		
		beq $t0, 32, s		
		subi $t0, $t0, 48	
		mul $t1, $t1, 10	
		add $t1, $t1, $t0	
		j inicioS		
s:		add $t2, $t2, $t1	
		li $t1, 0		
		j inicioS		
fimS:		add $t3, $t2, $t1	

		la $a0, soma		
		li $v0, 4		
		syscall			
		
		move $a0, $t3		
		li $v0, 1		
		syscall			
		
		jr $ra			
		
multiplicar:	li $t0, 0		
		li $t1, 0		
		li $t2, 1		
		li $t3, 0		

inicioMu:	li $v0, 14		
		syscall			
		beqz $v0, fimMu		
		lb $t0, ($a1)		
		beq $t0, 13, inicioMu	
		beq $t0, 10, mu		
		beq $t0, 32, mu		
		subi $t0, $t0, 48	
		mul $t1, $t1, 10	
		add $t1, $t1, $t0	
		j inicioMu		
mu:		mul $t2, $t2, $t1	
		li $t1, 0		
		j inicioMu		
fimMu:		mul $t3, $t2, $t1	

		la $a0, multiplicacao	
		li $v0, 4		
		syscall			
		
		move $a0, $t3		
		li $v0, 1		
		syscall			
		
		jr $ra			
		
numerosPares:	li $t0, 0		
		li $t1, 0		
		li $t2, 0		
		li $t3, 0		
		li $t4, 0		

inicioNP:	li $v0, 14		
		syscall			
		beqz $v0, fimNP		
		lb $t0, ($a1)		
		beq $t0, 13, inicioNP	
		beq $t0, 10, nP		
		beq $t0, 32, nP		
		subi $t0, $t0, 48	
		mul $t1, $t1, 10	
		add $t1, $t1, $t0	
		j inicioNP		
nP:		div $t1, $t1, 2		
		mfhi $t2		
		bnez $t2, imparNP	
		addi $t3, $t3, 1	
		j continueNP		
imparNP:	addi $t4, $t4, 1	
continueNP:	li $t1, 0		
		j inicioNP		
		
fimNP:		div $t1, $t1, 2		
		mfhi $t2		
		bnez $t2, imparNP2	
		addi $t3, $t3, 1	
		j continueNP2		
imparNP2:	addi $t4, $t4, 1	

continueNP2:	la $a0, impares		
		li $v0, 4		
		syscall			
		
		move $a0, $t4		
		li $v0, 1		
		syscall			

		la $a0, pares		
		li $v0, 4		
		syscall			
		
		move $a0, $t3		
		li $v0, 1		
		syscall			

		jr $ra			
		
contagem:	li $t0, 0		
co:		li $v0, 14		
		syscall			
		beqz $v0, sairCo	
		addi $t0, $t0, 1
		j co
sairCo:		la $a0, caracteres	
		li $v0, 4		
		syscall			
		move $a0, $t0		
		li $v0, 1		
		syscall			
		jr $ra			

getPrimeiro:	li $t0, 0		
		li $t1, 0		
		li $t2, 0		
		
gP:		li $v0, 14		
		syscall			
		lb $t0, ($a1)		
		beq $t0, 13, gP		
		beq $t0, 10, fimGP	
		beq $t0, 32, fimGP	
		subi $t0, $t0, 48	
		mul $t1, $t1, 10	
		add $t1, $t1, $t0	
		j gP			
fimGP:		add $v0, $t2, $t1	
		jr $ra			
		
getMaior:	li $t0, 0		
		li $t1, 0		
		li $t2, 0		
		li $t3, 0		

inicioGMa:	li $v0, 14		
		syscall			
		beqz $v0, fimGMa	
		lb $t0, ($a1)		
		beq $t0, 13, inicioGMa	
		beq $t0, 10, gMa	
		beq $t0, 32, gMa	
		subi $t0, $t0, 48	
		mul $t1, $t1, 10	
		add $t1, $t1, $t0	
		j inicioGMa		
gMa:		bge $t1, $s1, mudaMaior	
		j continueGMa
mudaMaior:	move $s1, $t1
continueGMa:	li $t1, 0		
		j inicioGMa		
		
fimGMa:		bge $t1, $s1, mudaMaior2
		j continueGMa2
mudaMaior2:	move $s1, $t1
continueGMa2:	la $a0, maior		
		li $v0, 4		
		syscall			
		
		move $a0, $s1		
		li $v0, 1		
		syscall			
		
		jr $ra			
		
getMenor:	li $t0, 0		
		li $t1, 0		
		li $t2, 0		
		li $t3, 0		

inicioGMe:	li $v0, 14		
		syscall			
		beqz $v0, fimGMe	
		lb $t0, ($a1)		
		beq $t0, 13, inicioGMe	
		beq $t0, 10, gMe	
		beq $t0, 32, gMe	
		subi $t0, $t0, 48	
		mul $t1, $t1, 10	
		add $t1, $t1, $t0	
		j inicioGMe		
gMe:		ble $t1, $s1, mudaMenor
		j continueGMe
mudaMenor:	move $s1, $t1
continueGMe:	li $t1, 0		
		j inicioGMe		
		
fimGMe:		ble $t1, $s1, mudaMenor2
		j continueGMe2
mudaMenor2:	move $s1, $t1
continueGMe2:	la $a0, menor		
		li $v0, 4		
		syscall			
		
		move $a0, $s1		
		li $v0, 1		
		syscall			
		
		jr $ra			
		


		
reabrirArquivo:	subi $sp, $sp, 4	
		sw $ra, ($sp)		
		jal fecharArquivo	
		la $a0, arquivo		
		li $a1, 0 		
		jal abertura		
		move $s0, $v0		
		move $a0, $s0		
		la $a1, buffer		
		li $a2, 1		
		lw $ra, ($sp)		
		addi $sp, $sp, 4	
		jr $ra			
		
fecharArquivo:	li $v0, 16		
		move $a0, $s0		
		syscall			
		jr $ra			

finalizar:	li $v0, 10		
		syscall			