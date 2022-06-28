   .data
first:      .asciiz     "First string: "
last:       .asciiz     "Second string: "
full:       .asciiz     "Full string: "
newline:    .asciiz     "\n"

string1:    .space      256             # buffer for first string
string2:    .space      256             # buffer for second string
string3:    .space      512             # combined output buffer

    .text

main:
    # prompt and read first string
    la      $a0,first              
    la      $a1,string1            
    jal     prompt
    move    $s0,$v0                 

    # prompt and read second string
    la      $a0,last                
    la      $a1,string2            
    jal     prompt
    move    $s1,$v0                 

    la      $a0,string3



    la      $a1,string1
    jal     strcat


    la      $a1,string2
    jal     strcat

    j       print_full


# show results
print_full:
    # output the prefix message for the full string
    li      $v0,4
    la      $a0,full
    syscall

    # output the combined string
    li      $v0,4
    la      $a0,string3
    syscall

    # finish the line
    li      $v0,4
    la      $a0,newline
    syscall

    li      $v0,10
    syscall

prompt:
    # output the prompt
    li      $v0,4                  
    syscall

    # get string from user
    li      $v0,8                  
    move    $a0,$a1                 
    li      $a1,256               
    syscall

    li      $v1,0x0A              
    move    $a1,$a0               

# strip newline and get string length
prompt_nltrim:
    lb      $v0,0($a0)              
    addi    $a0,$a0,1              
    beq     $v0,$v1,prompt_nldone   
    bnez    $v0,prompt_nltrim       

prompt_nldone:
    subi    $a0,$a0,1               
    sb      $zero,0($a0)           
    sub     $v0,$a0,$a1             
    jr      $ra                    

strcat:
    lb      $v0,0($a1)              
    beqz    $v0,strcat_done      

    sb      $v0,0($a0)              

    addi    $a0,$a0,1               
    addi    $a1,$a1,1              
    j       strcat

strcat_done:
    sb      $zero,0($a0)            
    jr      $ra                     