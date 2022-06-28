.data
	mat: 		.space 64 # 4x4 * 4	
	
	Mensagem1: 	.asciiz " Insira o valor de mat["
	Mensagem2: 	.asciiz "]["
	Mensagem3: 	.asciiz "]: "
	
	maior_msg:	.asciiz "\nO maior elemento da matriz é: "
	menor_msg: 	.asciiz "\nO menor elemento da matriz é: "
	_i: 		.asciiz "i: "
	_j: 		.asciiz "j: "
	
	pares_msg:	.asciiz "\nO numero de elementos pares da matriz é: "
	primos_msg: 	.asciiz "\nO numero de elementos primos da matriz é: "
	
	ord_msg:	.asciiz "\nMatriz em ordem crescente: "
	
.text
	main: 
		la $a0, mat
		li $a1, 4 #a1 = nlin
		li $a2, 4 #a2 = ncol
	
	
		####Lendo a matriz####
		jal leitura
		move $a0, $v0
	
	
		####Imprimindo a matriz lida####
		jal escrita
		move $a0, $v0
	
	
		####Encontrando o maior elemento da matriz####
		la $a0, maior_msg
		addi $v0, $zero, 4
		syscall 
		
		la $a0, mat
		la $a3, elemento_maior 
		jal elemento_x_da_matriz
		
		
		####Encontrando o menor elemento da matriz####
		la $a0, menor_msg
		addi $v0, $zero, 4
		syscall 
		
		la $a0, mat
		la $a3, elemento_menor
		jal elemento_x_da_matriz
	
	
		####Encontrando o numero de elementos pares da matriz####
	
		la $a0, mat
		la $a3, elemento_par
		jal numero_elementos_y_da_matriz
		addi $s0, $v0, 0
		
		la $a1, pares_msg
		addi $a2, $s0, 0
		jal imprimir_string_seguida_de_inteiro
		addi $a1, $zero, 4
		addi $a2, $zero, 4
		
		####Encontrando o numero de elementos primos da matriz####
		
		la $a0, mat
		la $a3, elemento_primo
		jal numero_elementos_y_da_matriz
		addi $s1, $v0, 0
		
		la $a1, primos_msg
		addi $a2, $s1, 0
		jal imprimir_string_seguida_de_inteiro
		addi $a1, $zero, 4
		addi $a2, $zero, 4
	
		####Ordenando a matriz em ordem crescente####
		
		la $a0, mat
		jal sort
		
		la $a0, ord_msg
		addi $v0, $zero, 4
		syscall 
		
		la $a0, mat
		jal escrita
	
		####Finalizando o programa####
		li $v0, 10
		syscall 
	
	
	indice: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol) -> calcula o endereço do elemento mat[i][j]
	 
		mul $v0, $t0, $a2  # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $t1  # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2    # [(i * ncol) + j] (calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a0  #retona a soma do endereço base da matriz e do deslocamento (i.e, return &mat[i][j])
		jr $ra 


	leitura:
		subi $sp, $sp, 4
		sw $ra, ($sp)
		move $a3, $a0
	
		l: 
			la $a0, Mensagem1
			li $v0, 4
			syscall 
	    
      		move $a0, $t0
			li $v0, 1
			syscall 
	
			la $a0, Mensagem2
			li $v0, 4
			syscall 
	
			move $a0, $t1
			li $v0, 1
			syscall 
	
			la $a0, Mensagem3
			li $v0, 4
			syscall 
	
			li $v0, 5
			syscall 
			move $t2, $v0 
			
			la $a0, ($a3)
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
	
	
	escrita: #(a0 = endereço base da matriz, a1 = nlin, a2 = ncol)
		subi $sp, $sp, 4
		sw $ra, ($sp)
		move $a3, $a0 
	
		la $a0, 10 
		li $v0, 11
		syscall
	
		e: 
			la $a0, ($a3)
			jal indice 
			lw $a0, ($v0)
			li $v0, 1
			syscall 
	
			la $a0, 32
			li $v0, 11
			syscall
	
			addi $t1, $t1, 1
			blt $t1, $a2, e 
 	
			la $a0, 10
			syscall
	
			li $t1, 0
			addi $t0, $t0, 1
			blt $t0, $a1, e 
			li $t0, 0
	 
		lw $ra, ($sp)
		addi $sp, $sp, 4
		move $v0, $a3
		jr $ra


	elemento_x_da_matriz: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol, a3 = endereço do procedimento que sera chamado para todos os elementos de mat afim de encontrar o elemento x)
		
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		
		la $s0, ($a0)
		addi $t0, $zero, 0
		addi $t1, $zero, 1
		
		lw $t2, ($s0)
		addi $t8, $zero, 0
		addi $t9, $zero, 0
		
		loop_elementos_x:
			la $a0, ($s0)
			jal indice
			lw $t3, ($v0)
			
			addi $sp, $sp, -4
			sw $a1, 0($sp) #empilhando um dos parametros do procedimento atual.
			addi $a0, $t3, 0 
			addi $a1, $t2, 0
			jalr $a3 
			lw $a1, 0($sp)
			addi $sp, $sp, 4
			
			beq $v0, $zero, elem_x_inc_j #if $v0 == 0 (o elemento atual mat[i][j] nao é o X), then goto elem_x_inc_j, else mat[i][j] passa a ser o elemento X.
			addi $t2, $t3, 0 
			addi $t8, $t0, 0 
			addi $t9, $t1, 0 
			
			elem_x_inc_j:
			addi $t1, $t1, 1
			slt $t3, $t1, $a2
			bne $t3, $zero, loop_elementos_x
	
			elem_x_inc_i:
			addi $t1, $zero, 0 
			addi $t0, $t0, 1
			slt $t3, $t0, $a1
			bne $t3, $zero, loop_elementos_x
			
			addi $t0, $zero, 0
		
		
		addi $sp, $sp, -8
		sw $a1, 0($sp) 
		sw $a2, 4($sp) 
		
		addi $a0, $t2, 0
		addi $v0, $zero, 1
		syscall 	
					
		la $a1, _i
		addi $a2, $t8, 0
		jal imprimir_string_seguida_de_inteiro 
		
		la $a1, _j
		addi $a2, $t9, 0
		jal imprimir_string_seguida_de_inteiro 
			
		lw $a1, 0($sp)
		lw $a2, 4($sp)
		addi $sp, $sp, 8
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		
					
	elemento_maior: #(a0 = elemento1, a1 = elemento2) -> testa se o elemento1 é maior que o elemento2
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		
		slt $t0, $a1, $a0 
		
		addi $v0, $t0, 0 
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		jr $ra 
	
	
	elemento_menor: #(a0 = elemento1, a1 = elemento2) -> testa se o elemento1 é menor que o elemento2
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		
		slt $t0, $a0, $a1 
		
		addi $v0, $t0, 0 
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		jr $ra 
		
		
	numero_elementos_y_da_matriz: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol, a3 = endereço do procedimento que sera chamado para todos os elementos de mat afim de encontrar quantos desses sao y)
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		
		la $s0, ($a0) 
		addi $t0, $zero, 0 
		addi $t1, $zero, 0 
		addi $t2, $zero, 0 
		
		loop_elementos_y:
			la $a0, ($s0)
			jal indice 
			lw $t3, ($v0) 
			
			addi $a0, $t3, 0
			jalr $a3
			
			beq $v0, $zero, elems_y_inc_j 
			addi $t2, $t2, 1 
			
			elems_y_inc_j:
			addi $t1, $t1, 1 
			slt $t3, $t1, $a2
			bne $t3, $zero, loop_elementos_y 
			
			elems_y_inc_y:
			addi $t1, $zero, 0 
			addi $t0, $t0, 1
			slt $t3, $t0, $a1
			bne $t3, $zero, loop_elementos_y 
			
			addi $t0, $zero, 0
		
		addi $v0, $t2, 0
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
					
	
	elemento_par: #(a0: numero) -> retorna 1 se o numero for par, se nao retorna 0
		addi $sp, $sp, -4
		sw $t2, 0($sp)
		
		addi $t2, $zero, 2 
		
		div $a0, $t2 
		mfhi $t2 
		
		addi $v0, $zero, 0
		
		bne $t2, $zero, fim_par 
		addi $v0, $v0, 1 
		
		fim_par:
		lw $t2, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	
	elemento_primo: #(a0: numero) -> retorna 1 se o numero for primo, se nao retorna 0
		
		addi $sp, $sp, -16
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $t0, 8($sp)
		sw $ra, 12($sp)
		
		addi $s0, $zero, 0, 
		addi $s1, $zero, 1 
		
		beq $a0, $s1, fim_primo 
		
		jal soma_dos_divisores
		addi $t0, $v0, 0 
		
		bne $t0, $s1, fim_primo 
		addi $s0, $zero, 1 

	fim_primo:
		addi $v0, $s0, 0 
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $t0, 8($sp)
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		
		
	soma_dos_divisores: #(a0 = numero)
		addi $sp, $sp, -16
		sw $s0, 0($sp)
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		
		addi $s0, $zero, 0 
		addi $t0, $zero, 1
		
		loop_divisores:
			div $a0, $t0 
			mfhi $t1 
			
			bne $t1, $zero, inc_i_divisores 
			add $s0, $s0, $t0 
			
		inc_i_divisores:
			addi $t0, $t0, 1
			slt $t2, $t0, $a0
			bne $t2, $zero, loop_divisores 
		
		addi $v0, $s0, 0 
		lw $s0, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		lw $t2, 12($sp)
		addi $sp, $sp, 16
		jr $ra
	
	
	sort: #(a0 = endereço base de mat, a1 = nlin, a2 = ncol)
		
		addi $sp, $sp, -8
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		
		la $t0, ($a0) 
		mul $t1, $a1, $a2 #t1 (mat_length) = nlin * ncol
		addi $v0, $zero, 0, 
		
		sll $t1, $t1, 2          #t1 *= 4 -> t1 vai passar a guardar a quantidade de bytes necessarios para guardar mat_length elementos. e.g, mat_length == 16 elementos, ..., t1 = 16 * 4 bytes = 64 bytes
  		
  		loop_gnome:
   	 		slt $t3, $v0, $t1       
			beq $t3, $zero, fim_gnome     
			bne $v0, $zero, comparar_gnome  
			addiu $v0, $v0, 4          
  		
  			comparar_gnome:
    			addu $t2, $t0, $v0        # $t2 = endereço base + deslocamento em bytes (=&arr[i])
    			lw $t4, -4($t2)         
    			lw $t5, 0($t2)          
    			blt $t5, $t4, swap_gnome       
    			addiu $v0, $v0, 4         
    			j loop_gnome
  		
  			swap_gnome:
    			sw $t4, 0($t2)          # swap (arr[i], arr[i-1])
    			sw $t5, -4($t2)
    			addiu $v0, $v0, -4      
    			j loop_gnome
  		
  		fim_gnome:
   		lw $t0, 0($sp)
   		lw $t1, 4($sp)           
  	 	addi $sp, $sp, 8           
   		jr $ra                  
	
	
	imprimir_string_seguida_de_inteiro: #($a1: string, $a2: inteiro)
		la $a0, 10 
		li $v0, 11
		syscall 
		
		addi $v0, $zero, 4 
		la $a0, ($a1) 
		syscall	
		addi $v0, $zero, 1
		add $a0, $a2, $zero
		syscall 
		
		la $a0, 10 
		li $v0, 11
		syscall 
		jr $ra 
	
