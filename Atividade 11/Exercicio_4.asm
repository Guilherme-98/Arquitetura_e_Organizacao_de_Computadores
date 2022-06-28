.data
	valueInput: .asciiz "Insira um valor: "
	outputTrue: .asciiz "\nNumero palindrome"
	outputFalse: .asciiz "\nNumero nao palindrome"
	
.text

# Index
	# Red integer ---------- $a1
	# Original integer ----- $s0
	# Reversed integer ----- $s1
	# Remainder ------------ $s2

main:
	jal read
	
	jal testPalindrome
	
	j exit
	
read:
	li $v0, 4		
	la $a0, valueInput	
	syscall			
	
	li $v0, 5		
	syscall			
	
	move $a1, $v0		
	move $s0, $v0		
	
	jr $ra			
	
testPalindrome:

tPWhile:
	
	div $a1, $a1, 10	
	mfhi $s2		
	
	mul $s1, $s1, 10	
	
	add $s1, $s1, $s2	
	
	
	
	bne $a1, $zero, tPWhile 
	
	beq $s0, $s1, tPTrue
	
	# Not palindrome
	
	li $v0, 4		
	la $a0, outputFalse	
	syscall			
	
	jr $ra
	
	# Palindrome
tPTrue:

	li $v0, 4		
	la $a0, outputTrue	
	syscall			

	jr $ra
	
exit: 
	li $v0, 10		
	syscall			