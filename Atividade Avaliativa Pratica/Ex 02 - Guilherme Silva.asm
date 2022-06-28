.data
	mensagem1: .asciiz "Digite um numero:  "
	mensagem2: .asciiz "\nVetor de numeros primos:"
	mensagem3: .asciiz "\nNão há elementos primos no vetor: \n"
	br: .asciiz " "
.align 2
	X: .space 100
	Y: .space 100

.text

main: 

	la $a0, X 			#Carrega o endereco base de X em $a0
	jal lerVetor 			#lerVetor() (funcao para ler o vetor X)
	la $a0, Y			#Carrega o endereco base de Y em $a0
	la $s1, 0			#Carrega em $s1 valor zero
	jal pL				#pL () (funcao que verifica se o numero e primo)
	li $t9, 1 			#Contador para verificar a qauntidade de números primos
	
lerVetor: 

	move $t0, $a0 			#$t0 = $a0
	move $t1, $t0 			#$t1 = $t0 
	li $t2, 0 			#$t2 = 0

leituraLoop: 

	li $v0, 4			#Print da string
	la $a0, mensagem1		#Carrega endereco do argumento de mensagem1 
	syscall				#Chamada de sistema
	
	li $v0, 5			#Codigo para ler inteiro
	syscall				#Chamada de sistema
	
	sw $v0, ($t1)			#Quarda o inteiro na posicao X[i]	
	addi $t1, $t1, 4		#Incrementa i em 4 bits
	addi $t2, $t2, 1
	
	blt $t2, 20, leituraLoop   	#Caso $t2 for diferente de 15 o loop continua
	jr $ra				#Se não retorna pra main
	
pL: 

	move $t3, $a0			#$t3 = $a0
	move $t6, $t3			#$t6 = $a3
	move $t1, $t0			#$t1 = t0
	
	li $t2, 0			#t2 = 0
	li $t7, 0			#$t7 = 0
	
loopNumerosPrimos: 

	lw $s0, ($t1)			#Le o inteiro da posicao X[i] e guarda em $s0
	move $a0, $s0			#$a0 = $s0
	
	addi $t1, $t1, 4		#Incrementa i em 4 bits
	addi $t2, $t2, 1		#Contador +1
	
	jal tP				#testeNumerosPrimos ()

	blt $t2, 20, loopNumerosPrimos  #Caso $t2 for diferente de 15 o loop continua
	jal pA				#Se não vai para pA()
	
tP:

	li $t4, 2			#$t4 = 2
	
	beq $a0, 1, naoNumerosPrimos	#Caso $a0 for igual a 1 então vai para naoNumerosPrimos ()
	beq $a0, 2, numerosPrimos	#Caso $a0 for igual a 2 então vai para numerosPrimos ()

testeNumerosPrimos:

	div  $a0, $t4			#num / i
	mfhi $t7			#Move o resto para $t7
	
	beq, $t7, $zero, naoNumerosPrimos#Caso num % i for igual a 0 então vai para naoNumerosPrimos ()
	
	addi $t4, $t4, 1 		#i +1
	blt $t4, $a0, testeNumerosPrimos#Caso i < num vai para numerosPrimos ()

	b numerosPrimos			#Vai para numerosPrimos ()
	
numerosPrimos:

	addi $t9, $t9, 1		#Soma +1 ao contador para verificar se existe numeros primos
	sw $a0, ($t6)			#Quarda o inteiro em Y[i]
	addi $t6, $t6, 4		#Incrementa i em 4 bits
	addi $s1, $s1, 1		#Contador do tamanho do vetor é incrementado
	jr $ra				#Retorna
	
naoNumerosPrimos:

	jr $ra				#Retorna
	
pA: 

	li $t2, 0			#$t2 = 0
	move $t1, $t3			#t1 = $t3
	move $t4, $s1			#$t4 = $s1
	
	li $v0, 4			#Codigo para printar string
	beq $t9, $zero, mensagemVazia 	#Caso $t9 for igual a ZERO vai para mensagemVazia
	la $a0, mensagem2		#Carrega o endereco do argumento de mensagem2
	syscall				#Chamada de sistema
	
printArray: 	

	lw $s0, ($t1)			#$s0 = Y[i]
	addi $t1, $t1, 4		#Incrementa i em 4 bits
	addi $t2, $t2, 1		#Contador +1
	
	li $v0, 1			#Codigo para printar um inteiro
	move $a0, $s0			#$a0 = $s0
	syscall				#Chamada de sistema
	
	li $v0, 4			#Print da string
	la $a0, br			#Carrega endereco do argumento de br
	syscall				#Chamada de sistema
	
	blt $t2, $t4, printArray	#Caso $t2 for diferente de $t4 o loop continua
	
	jal exit			#Vai para exit
	
mensagemVazia:

	li $v0, 4			#Codigo para printar string
	la $a0, mensagem3		#Carrega o endereco do argumento de mensagem3
	syscall				#Chamada de sistema
	jal exit			#Vai para exit

exit: 

	li $v0, 10			#Codigo para finalizar o programa
	syscall				#Chamada de sistema
