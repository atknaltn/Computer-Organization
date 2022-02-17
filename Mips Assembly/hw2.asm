.data
	arr: .word 163,241,55,1,21,9,3,83
	tempArr: .space 400
	resultArr: .space 400
	newLine: .asciiz "\n"
	comma: .asciiz ","
	size : .asciiz "Size: "
	result: .asciiz "Longest Increasing Subsequence Is: "
	specialCaseText: .asciiz "There is no Longest Increasing Subsequence with given input."
.text
	.globl main
	main:
		li $s0,32 # size of array
		li $s1,0 # max size of lis
		li $t0,0 #i
		li $t1,0 #j
		li $t2,0 #k
		li $t3,0 #count
		li $t6,0 #sp index
		li $s1,0 #size of maximum arr
		sub $sp,$sp,32
		jal computeLIS
		
		bne $s1,0,specialCase
		li $v0,4
		la $a0,specialCaseText
		syscall
		# end of the program
		li $v0,10
		syscall	
		specialCase:
		li $v0,4
		la $a0,newLine
		syscall
			
		li $v0,4
		la $a0,result
		syscall
				
		li $t4,0
		printResult:
			lw $t5,resultArr($t4)
			li $v0,1
			la $a0,($t5)
			syscall
				
			li $v0,4
			la $a0,comma
			syscall
			
			addi $t4,$t4,4
			mul $t0,$s1,4
			blt $t4,$t0,printResult
					
			li $v0,4
			la $a0,size
			syscall

			li $v0,1
			div $t4,$t3,4
			la $a0,($s1)
			syscall
				
			li $v0,4
			la $a0,newLine
			syscall
		# end of the program
		li $v0,10
		syscall	
	computeLIS:
		addi $t4,$t0,4 # j=i+1
		la $t1,($t4)
		j secondFor
		secondForEnd:
			addi $t0,$t0,4 #i++
			addi $t4,$s0,-4 # last element is ignored
			blt $t0,$t4,computeLIS 
			jr $ra
	secondFor:
		li $t3,0 #count=0
		lw $t4,arr($t0) # tempArr[count]=arr[i];
		sw $t4,tempArr($t3)
		addi $t3,$t3,4 #count++
		
		#if statement for tempArr[count-1]<=arr[j]
		addi $t4,$t3,-4 # $t4=[count-1]
		lw $t5,tempArr($t4) # $t5= tempArr[count-1]
		lw $t4,arr($t1) #t4 = arr[j],$t1=j
		slt $v0,$t5,$t4 #if tempArr[count-1]<= arr[j] $v0=1
		beq $v0,1,ifStatement
		beq $v0,0,else
		thirdForEnd:
			li $t4,0
			print:
				lw $t5,tempArr($t4)
				li $v0,1
				la $a0,($t5)
				syscall
				
				li $v0,4
				la $a0,comma
				syscall
				
				addi $t4,$t4,4
				blt $t4,$t3,print
				
				li $v0,4
				la $a0,size
				syscall

				li $v0,1
				div $t4,$t3,4
				la $a0,($t4)
				syscall
				
				li $v0,4
				la $a0,newLine
				syscall
				
				sgt $v0,$t4,$s1
				li $t4,0 #array index = 0
				bne $v0,0,findResult
				j else
			findResult:
				div $t5,$t3,4 # calculating max
				la $s1,($t5) #max is updated by count
				lw $t6,tempArr($t4) # $t6=tempArr[i]
				sw $t6,resultArr($t4) # resultArr[i]=tempArr[i]
				addi $t4,$t4,4
				blt $t4,$t3,findResult
				j else
			else:
				addi $t1,$t1,4 # j++
				blt $t1,$s0,secondFor 
				j secondForEnd
	ifStatement:
		# tempArr[count++]=arr[j];
		lw $t4,arr($t1) # $t4 = arr[j]
		sw $t4,tempArr($t3) # tempArr[count++]=arr[j]
		addi $t3,$t3,4 #count++
		addi $t4,$t1,4 # k=j+1
		la $t2,($t4)
		j thirdFor
	#thirdFor
	thirdFor:
		addi $t4,$t3,-4 #count-1
		lw $t5,tempArr($t4) # $t5 = tempArr[count-1])
		lw $t4,arr($t2) # $t4=arr[k]
		slt $v0,$t5,$t4  #if(arr[k]>=tempArr[count-1])
		beq $v0,1,secondIf 
		secondIfEnd:
			addi $t2,$t2,4
			blt $t2,$s0,thirdFor
			j thirdForEnd
	secondIf:
		lw $t4,arr($t2) # $t4=arr[k]
		sw $t4,tempArr($t3) # tempArr[count++]=arr[k];
		addi $t3,$t3,4 #count++
		j secondIfEnd