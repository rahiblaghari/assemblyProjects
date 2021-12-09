# Name: Rahib Laghari
# UTD ID: rrl190001

#Registers & what I use them for:
#t0: in merge, holds t8 (pointer first element) and used to store back into array (the "merge" part) by incrementing 4 each time, hence pointing to the next elements
#t1 & t2: hold value from arrays, used to compare and store
#t3 & t4: are buffer space to pick from array (index essentially)
#t5 & t6: check if left or right array have been depleted (my version of arr1 or arr2)
#note: t5 & t6 also used in merge: t5 to store num in total array and run for it, along with t6 being a buffer to transfer from one array to another
#t8: holds initial stack pointer + 4 (points to first element in array)
#t9: points to last element in array, a final pointer
#s0: height of merge sort
#s1: number of elements in merge sort
#s2: number of comparisions per merge
#s3: distance between start of array 1 and 2 in the stack
#s4: number of elements in array per run
#s5: number of sorts necessary per run (times I need to call that back)
#s6: used to hold s2 each time for loops, increments 1 and used to know when all comparisions done
.data 
	FirstMessage: .asciiz "Enter the size of your list: "
	GetInput: .asciiz "Enter integer to store in list: "
	space: .asciiz " "
.text
	.globl main
main:
	#$t8 will store initial stack pointer (will use for merge)
	subi $t8, $sp, 4 #(ok, not initial stack pointer, but where stack begins)
	#get input for list size
	li $v0, 4
	la $a0, FirstMessage
	syscall
	
	li $v0, 5
	syscall
	move $a0, $v0
	
	#store in each number:
	move $s0, $a0 #s0 contains size, is used as increment
	move $s1, $s0#s1 contains size, will store size throughout
	getInput:
	subi $s0, $s0, 1 #increment
	subi $sp, $sp, 4 #take stack pointer back 1, keep doing this to store next elements into stack
	
	li $v0, 4 #request input
	la $a0, GetInput
	syscall
	
	li $v0, 5 #get input
	syscall
	sw $v0, 0($sp) #store into stack
	
	bnez $s0, getInput # run until list stored entirely
	
	
	div $s0, $s1, 2 #s0 now contains the num elements/2, aka: our height
	li $s3, 4 #$s3 contains the distance between first element of array one and two
	li $s4, 1 #$s4 contains the number of elements in each array per run
	
	
	move $t9, $sp #$t9 points right before first element in list
	
	
	#first, compare each two, then four, etc in merge sort
	div $s2, $s1, $s4 
	li $s2, 1
	MergeSort: 
	mul $s2, $s2, 2 #$s2 will contain number of comparisions per merge (includes final)
	li $t3, 0
	add $t4, $t3, $s3 #$t4 = dist between array 1 and array 2
	div $s5, $s1, $s4 # num of times sort will be called (ex: 4 for 8 arrays) Works
	div $s5, $s5, 2
	move $s6, $s2
	li $t5, 0
	li $t6, 0
	
	Sort: #do for each array
	#check if both arrays depleted and increment
	beqz $s6, NextSort
	subi $s6, $s6, 1
	#create space in stack to store next
	sub $sp, $sp, 4 ### was called way to much for some reason, prob bc t3 and t4 were too big too
	#check left depleted
	beq $t5, $s4, AddR
	#check right depleted
	beq $t6, $s4, AddL
	#check to see whether to call add left or add right
	#get elements from array and compare them
	add $t1, $t9, $t3
	add $t2, $t9, $t4
	lw $t1, ($t1) #t1 is the number, t3 will represent which element in array 1 we are in
	lw $t2, ($t2) #t2 is the number, t4 will represent which element in array 2 we are in
	bgt $t1, $t2, AddRight
	j AddLeft
	
	AddL:
	add $t1, $t9, $t3
	lw $t1, ($t1)
	AddLeft:
	sw $t1, ($sp)
	addi $t5, $t5, 1
	addi $t3, $t3, 4
	j Sort

	AddR:
	add $t2, $t9, $t4
	lw $t2, ($t2)
	AddRight:
	sw $t2, ($sp)
	addi $t6, $t6, 1
	addi $t4, $t4, 4
	j Sort
	
	NextSort:
	move $t3, $t4
	add $t4, $t3, $s3 #$t4 = dist between array 1 and array 2
	sub $s5, $s5, 1
	move $s6, $s2
	li $t5, 0 #reset counter values for how many times array been visited (t5 and t6)
	li $t6, 0
	bnez $s5, Sort
	#before this, check if another sort needed. If not needed, continue, else, go back
	subi $sp, $t9, 4 #sets $sp correctly before merge, first element in array to be merged in (left of OG stack)
	move $t0, $t9 #t0 gets indexed to last element
	move $t5, $s1
	#MERGE works
	Merge:
	lw $t6, ($sp)
	sw $t6, ($t0)
	subi $sp, $sp, 4
	addi $t0, $t0, 4
	subi $t5, $t5, 1
	bnez $t5, Merge
	
	
	mul $s4, $s4, 2 
	mul $s3, $s3, 2 
	div $s0, $s0, 2 #s0 dictates how many times to run
	move $sp, $t9 #Set stack pointer back
	li $t5, 1
	li $t6, 1
	bnez $s0, MergeSort
	
	
	move $sp, $t9
	PrintList:
	subi $s1, $s1, 1
	lw $a0, 0($sp)
	li $v0, 1 #prints int in $a0
	syscall 
	li $v0, 4
	la $a0, space
	syscall
	addi $sp, $sp, 4	
	bnez $s1, PrintList
	j Exit
	
	Exit:
	li $v0, 10
	syscall