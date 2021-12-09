# Name: Rahib Laghari
# UTD ID: rrl190001
# My program is implemented by comparing each element of the array unless one array is complete, and storing the smalles element into a
# different array called arrFin, which will be set back to start and contain the array at the end
.data 
	message: .asciiz ""
	space: .asciiz " "
	#array 1 and 2
	arr1: .word -1, 2, 5, 8, 9
	arr2: .word 0, 3, 4, 5, 7
	arrFin: .space 40
.text
	.globl main
main:
	#"You may assume the number of integers in each list is known"
	li $s0, 5 #arr1 contains 5 integers
	li $s1, 5 #arr2 contains 5 integers
	la $s3, arr1 #s3 is arr1 address
	la $s4, arr2 #s4 is arr2 address
	add $s2, $s1, $s0 #s2 is the number of values that will be in the loop at the end
	add $t5, $s0, $s1 #t5 holds number of elements in final array
	la $s7, arrFin
	loop:
		blez $s2, exit #exit if num of values negative or zero for any reason
		lw $t0, 0($s3) #load array one element in t0
		lw $t1, 0($s4) #load arr2 (arrray 2) element into t1
		#if either list is read through, continue to label storeSecond stores from second array, storeFirst stores from first array
		beqz $s0,storeSecond
		beqz $s1, storeFirst
		blt $t1, $t0, storeSecond #if $t1's elememt less than $t2, store second, otherwise continue below to add from first array
	storeFirst: 
		li $v0, 1
		move $a0, $t0
		syscall #print number about to be stored
		sw $a0, 0($s7) #store
		
		subi $s0, $s0, 1 #increment counter 
		
		add $s3, $s3, 4 #get next storage spot for both s7 and s3
		add $s7, $s7, 4
		j getNext
	storeSecond: #similar structure as storeFirst, look for reference
		li $v0, 1
		move $a0, $t1
		syscall
		sw $a0, 0($s7)
		
		subi $s1, $s1, 1
		
		add $s4, $s4, 4
		add $s7, $s7, 4
	getNext:
		la $a0, space
		li $v0, 4
		syscall
		subi $s2, $s2, 1
		j loop
	exit: #set the array pointer back to beginning of list, then exit
		mul $t5, $t5, 4
		sub $s7, $s7, $t5
		#Test code: the three following commented lines print first element of array
		#li $v0, 1
		#lw $a0, 0($s7)
		#syscall
		li $v0, 10
		syscall