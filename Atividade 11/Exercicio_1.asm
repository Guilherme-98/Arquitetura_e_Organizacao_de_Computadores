.data
	entrada: .asciiz "Digite um numero:  "
	saida: .asciiz "\nVetor de numeros primos: \n"
	br: .asciiz " "
.align 2
	X: .space 60
	Y: .space 60

.text

main: 
	la $a0, X 			
	jal rL 				
	la $a0, Y
	la $s1, 0			
	jal pL				
	
rL: 
	move $t0, $a0 			
	move $t1, $t0 			
	li $t2, 0 			

readLoop: 
	li $v0, 4			
	la $a0, entrada			
	syscall				
	
	li $v0, 5			
	syscall				
	
	sw $v0, ($t1)				
	addi $t1, $t1, 4		
	addi $t2, $t2, 1
	
	blt $t2, 15, readLoop   	
	jr $ra				
	
pL: 
	move $t3, $a0			
	move $t6, $t3			
	move $t1, $t0			
	
	li $t2, 0			
	li $t7, 0			
	
primeLoop: 
	lw $s0, ($t1)			
	move $a0, $s0			
	
	addi $t1, $t1, 4		
	addi $t2, $t2, 1		
	
	jal tP				

	blt $t2, 15, primeLoop  	
	jal pA				
	
tP:
	li $t4, 2			
	
	beq $a0, 1, notPrime		
	beq $a0, 2, prime		

testPrime:
	div  $a0, $t4			
	mfhi $t7			
	
	beq, $t7, $zero, notPrime	
	
	addi $t4, $t4, 1 		
	blt $t4, $a0, testPrime		

	b prime				
	
prime:
	sw $a0, ($t6)			
	addi $t6, $t6, 4		
	addi $s1, $s1, 1		
	jr $ra				
	
notPrime:
	jr $ra				
	
pA: 
	li $t2, 0			
	move $t1, $t3			
	move $t4, $s1			
	
	li $v0, 4			
	la $a0, saida			
	syscall				
	
printArray: 	
	lw $s0, ($t1)			
	addi $t1, $t1, 4		
	addi $t2, $t2, 1		
	
	li $v0, 1			
	move $a0, $s0			
	syscall				
	
	li $v0, 4			
	la $a0, br			
	syscall				
	
	blt $t2, $t4, printArray	
	jal exit			

exit: 
	li $v0, 10			
	syscall				