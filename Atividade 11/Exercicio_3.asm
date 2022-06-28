.data
	arrayA: .space 60
	arrayB: .space 28
	Inter: 	.space 60
	
	arrayAInput: .asciiz "Insira um valor no vetor A: "
	arrayBInput: .asciiz "Insira um valor no vetor B: "
	intersec: .asciiz "Intersec: "
	
	sp: .asciiz " "
	br: .asciiz "\n"

.text

# Index:
	# Inter size ---------------- $s0


main:

	jal readArrayA
	
	jal readArrayB
	
	jal printInter
	
	j exit





readArrayA:

	move $t0, $zero		

rAAFor:
	li $v0, 4		
	la $a0, arrayAInput	
	syscall			
	
	li $v0, 5		
	syscall			
	
	sw $v0, arrayA($t0)	
	
	addi $t0, $t0, 4	
	blt $t0, 60, rAAFor	
	
	jr $ra			





readArrayB:
	move $s0, $zero
	move $t0, $zero		
	move $s7, $ra		

rABFor:
	li $v0, 4		
	la $a0, arrayBInput	
	syscall			
	
	li $v0, 5		
	syscall			
	
	move $a1, $v0		
	
	jal intersectionTest	
	
	sw $v0, arrayB($t0)	
	
	addi $s1, $s1, 4
	
	addi $t0, $t0, 4	
	blt $t0, 28, rABFor	
	
	jr $s7			





intersectionTest:
	move $t4, $zero		
	la $t2, arrayA		

iTFor:
	lw $t3, ($t2)		
	beq $a1, $t3, iTTrue	
	
	addi $t2, $t2, 4
	addi $t4, $t4, 4	
	blt $t4, 60, iTFor	
	
	jr $ra			
	
iTTrue:
	j verify
	
iTTReturn:
	jr $ra
	
	
verify:
	move $t5, $zero		
	la $t6, arrayB		
	
vFor:
	lw $t7, ($t6)		
	beq $a1, $t7, vTrue	
	
	addi $t5, $t5, 4
	addi $t6, $t6, 4	
	blt $t5, $s1, vFor	
	
	sw $a1, Inter($s0)	
	addi $s0, $s0, 4
	j iTTReturn

vTrue:

	j iTTReturn
	
	
	
	






printInter: 
	
	move $t0, $zero		

	li $v0, 4		
	la $a0, intersec	
	syscall			
pIFor:
	li $v0, 1		
	lw $a0, Inter($t0)	
	syscall	
	
	li $v0, 4		
	la $a0, sp		
	syscall			
	
	
	addi $t0, $t0, 4	
	blt $t0, $s0, pIFor	
	
	jr $ra			




exit:
	li $v0, 10		
	syscall			