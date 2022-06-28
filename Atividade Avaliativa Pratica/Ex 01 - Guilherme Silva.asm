.data
	mensagem1: .asciiz "Insira o numero de posicoes do vetor: "
	mensagem2: .asciiz "Insira vetor["
	mensagem3: .asciiz "]: "
	mensagem4: .asciiz "Quantidade de número(s) Impar(es): "
	mensagem5: .asciiz "0 elementos ímpares"
	
.text

#variáveis
#	$s0 = tamanho do vetor
#	$s1 = endereço base do vetor
#	$s7 = null

li $s7, 0xFFFFFFF

main:

	li $t9, 0		#Contador para verificar a quatiade de números pares 
	li $t8, 2		#Seta $t8 para 2 usando na divisão para verifcar se existe números impares	
	
	jal n			#Vai para n
	
	move $s0, $v0		#Salva em $s0 o valor lido
	
	move $a0, $s0		#Passa o tamanho do vetor para o argumento $a0
	jal alloc		#Vai para alloc
	move $s1, $v0 		#Salva o endereço base do vetor retornado da função alloc em $s1
	
	move $a0, $s1		#Passa o endereço base do vetor para o argumento $a0
	move $a1, $s0		#Passa o tamanho do vetor para o argumento $a1
	jal leituraVetor		#Vai para leituraVetor
	
	jal display		#Vai para disĺay
	
	j exit			#Vai para exit
	
	
n:

	la $a0, mensagem1	#Print da string
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	li $v0, 5		#Código de leitura de inteiro
	syscall			#Chamada de sistema
	
	jr $ra			#return
	
alloc:

	mul $a0, $a0, 4		#Multiplica o tamanho do vetor por 4 bits
	li $v0, 9		#Código de alocação dinâmica
	syscall			#Chamada de sistema
	
	jr $ra			#return

leituraVetor:

	move $t0, $a0		#Salva o endereço base do vetor em $t0
	move $t1, $t0		#Salva o endereço base do vetor em $t1 ($t1 será incrementado)
	li $t2, 0		#$t2 recebe 0 (contador de verificação)
	move $t3, $a1		#Salva o tamanho do vetor em $t3
	
	
l:	

	la $a0, mensagem2	#Print da string
	li $v0, 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	move $a0, $t2
	li $v0, 1		#Código de impressão de inteiro
	syscall			#Chamada de sistema
	
	la $a0, mensagem3	#Print da string
	li $v0 4		#Código de impressão de string
	syscall			#Chamada de sistema
	
	li $v0, 5		#Código de leitura de inteiro
	syscall			#Chamada de sistema
	
	div $v0,  $t8		#Divide o número por 2
	mfhi $s0		#Salva o resto da divisão em $s0
	bne $s0, $zero, proc_num_ímpar#Verifica de o resto da divisão é igual a zero
	
	
	sw $v0, ($t1)		#Salva o valor lido no endereço armazenado em $t1
	addi $t1, $t1, 4	#Incrementa o endereço do vetor
	addi $t2, $t2, 1	#Incrementa o contador
	blt $t2, $t3, l		#Pula para l se o contador for menor que o tamanho do vetor
	jr $ra			#return
	
proc_num_ímpar: 

	addi $t9, $t9, 1	#Inclementa +1 ao contador
	sw $v0, ($t1)		#Salva o valor lido no endereço armazenado em $t1
	addi $t1, $t1, 4	#Incrementa o endereço do vetor
	addi $t2, $t2, 1	#Incrementa o contador
	blt $t2, $t3, l		#Pula para l se o contador for menor que o tamanho do vetor
	jr $ra			#return
	
display:

	beq $t9, $zero, mensagemVazia#Caso a quantidade de números impar seja zero, vai para mensagemVazia
	
	li $v0,4		#Codigo para printar string
	la $a0, mensagem4	#Carrega o endereco do argumento de mensagem4
	syscall			#Chamada de sistema
	
	li $v0, 1		#Codigo para printar um número inteiro
	move $a0, $t9		#Move o conteudo de $t9 para $a0
	syscall			#Chamada de sistema
	
	jal exit		#Vai para exit
	
mensagemVazia:

	li $v0, 4		#Codigo para printar string
	la $a0, mensagem5	#Carrega o endereco do argumento de mensagem5
	syscall			#Chamada de sistema
	
	jal exit		#Vai para exit
	
exit:

	li $v0, 10		#Codigo para finalizar o programa
	syscall			#Chamada de sistema
