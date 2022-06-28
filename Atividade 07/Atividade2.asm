.data
	input: .asciiz "Informe um numero: "
	outputHighest: .asciiz "\nMaior numero: "
	outputLowest: .asciiz "\nMenor numero: "
	outputEvenSum: .asciiz "\nSoma de numeros pares: "
	outputOddSum: .asciiz "\nSoma de numeros impares: "
	outputPrimeNumbers: .asciiz "\nQuantidade de numeros primos: "
	outputAmicableNumbers: .asciiz "\nQuantidade de numeros amigos: "
	outputPerfectNumbers: .asciiz "\nQuantidade de numeros perfeitos: "
	br: .asciiz "\n"
	
.text

# Index:
	# Highest number----------------$s0
	# Lowest number-----------------$s1
	# Even numbers sum--------------$s2
	# Odd numbers sum---------------$s3
	# Prime numbers counter---------$s4
	# Amicable numbers counter------$s5
	# Perfect numbers counter-------$s6

main:
	jal firstRead		# void firstRead()
	
	jal secondRead		# void secondRead()
	
	jal display		# void display()
	
	j exit

firstRead:
	move $s7, $ra	
	
	li $s2,0		# Sets even sum to 0
	li $s3,0		# Sets odd sum to 0
	li $s4,0		# Sets prime numbers counter to 0
	li $s5,0		# Sets amicable numbers counter to 0
	li $s6,0		# Sets perfect numbers counter to 0

	li $v0, 4		
	la $a0, input		
	syscall			
	
	li $v0, 5		
	syscall			
	
	move $a0, $v0	
	
	jal evenOrOddSum	# void evenOrOddSum(int i)
	
	jal testPrime		# void testPrime(int i)
	
	jal testAmicable	# void testAmicable(int i)
	
	jal testPerfect		# void testPerfect(int i)
	
	move $s0, $v0		
	move $s1, $v0		
	
	jr $s7			
	

secondRead:
	li $t0, 1		
	move $s7, $ra	
	
	b sRFor			

sRFor:	add $t0, $t0 1		

	li $v0, 4		
	la $a0, input		
	syscall			
	
	li $v0, 5		
	syscall			
	
	move $a0, $v0		
	
	jal testHigher		# void testHigher(int i)
	
	jal testLower		# void testLower(int i)
	
	jal evenOrOddSum	# void evenOrOddSum(int i)
	
	jal testPrime		# void testPrime(int i)
	
	jal testAmicable	# void testAmicable(int i)
	
	jal testPerfect		# void testPerfect(int i)

	beq $t0, 10, sRReturn
	b sRFor			
	
sRReturn: jr $s7	

testHigher:
	bgt $a0, $s0 isHigher
	jr $ra
isHigher:
	move $s0, $a0
	jr $ra



testLower:
	bgt $a0, $s0 isHigher
	jr $ra
isLower:
	move $s1, $a0
	jr $ra

evenOrOddSum:
	div $t1, $a0, 2		
	mfhi $t1		
	
	beq $t1, $zero, evenSum	
	
	add $s3, $s3, $a0	
	
	jr $ra			
evenSum:
	add $s2, $s2, $a0	
	
	jr $ra	

testPrime:
	li $t1, 2			
	
	beq $a0, 1, notPrime		
	beq $a0, 2, prime	
	
tPFor:	div  $a0, $t1			
	mfhi, $t2			
	
	beq, $t2, $zero, notPrime	
	
	add $t1, $t1, 1 		
	blt $t1, $a0, tPFor		

	b prime				

prime: 
	add $s4, $s4, 1			
	jr $ra			
	
notPrime:
	jr $ra				

testAmicable:
	beq $a0, 1, tAmNotAmicable	
	li $t1, 1		
	li $t2, 0		
	
tAmFor:	
	add $t1, $t1, 1		
	bge $t1, $a0, tAm2	
	
	div $a0, $t1		
	mfhi $t3		
	
	beq $t3, $zero, tAmDiv	
	
	j tAmFor
	
tAmDiv:
	add $t2, $t2, $t1
	j tAmFor
	
tAm2: 
	add $t2, $t2, 1		
	beq $a0, $t2, tAmNotAmicable	
	li $t1, 1		
	li $t4, 0		
	

tAmFor2:	
	add $t1, $t1, 1	
	bge $t1, $t2, tAmReturn	
	
	div $t2, $t1		
	mfhi $t3		

	beq $t3, $zero, tAmDiv2	
	
	j tAmFor2
	
tAmDiv2:
	add $t4, $t4, $t1
	j tAmFor2
	
tAmReturn:
	add $t4, $t4, 1		
		
	beq $a0, $t4, tAmAmicable
	b tAmNotAmicable

tAmAmicable:
	add $s5, $s5, 1
	jr $ra

tAmNotAmicable:
	jr $ra

testPerfect:
	li $t1, 1		
	li $t2, 0		
	move $t7, $ra		
	beq $a0, 1, tPeNotPerfect	
	
tPeFor:	
	add $t1, $t1, 1	
	bge $t1, $a0, tPeReturn	
	
	div $a0, $t1		
	mfhi $t3		
	
	beq $t3, $zero, tPeDiv	
	
	j tPeFor
	
tPeDiv:
	add $t2, $t2, $t1
	j tPeFor

	
tPeReturn:

	add $t2, $t2, 1
	beq $t2, $a0, tPePerfect
	b tPeNotPerfect
	
tPePerfect:
	add $s6, $s6, 1
	jr $t7
	
tPeNotPerfect:
	jr $t7

display:
	#Highest number
	li $v0, 4		
	la $a0, outputHighest
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	#Lowest number
	li $v0, 4
	la $a0, outputLowest
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	# Even numbers sum
	li $v0, 4
	la $a0, outputEvenSum
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	# Odd number sums
	li $v0, 4
	la $a0, outputOddSum
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	# Prime numbers
	li $v0, 4
	la $a0, outputPrimeNumbers
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	# Amicable numbers
	li $v0, 4
	la $a0, outputAmicableNumbers
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	# Perfect numbers
	li $v0, 4
	la $a0, outputPerfectNumbers
	syscall
	
	li $v0, 1
	move $a0, $s6
	syscall
	
	jr $ra	

exit:
	li $v0, 10	
	syscall			