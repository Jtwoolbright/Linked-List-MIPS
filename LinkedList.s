 #
 # 	Coded by: 	Woolbright Josh
 # 	Date: 		11/17/2019
 # 	Description:
 # 			This program creates a linked list of strings
 #			inputted by the user and prints them.
 #

	.data
 enter: .asciiz "Enter text? "
 name:	.asciiz "J. Woolbright's Link List\n"
 newlin:.asciiz "\n"
 head:	.word	0
 input:	.space  32

	.text
 main:
	la	$a0, name	# print name
	li	$v0, 4
	syscall
	
	la	$a0, newlin	# print new line
	li	$v0, 4
	syscall
 loop:
	la	$a0, enter	# prompt for string
	li	$v0, 4
	syscall

	la	$a0, input	# read string
	li	$a1, 32
	li	$v0, 8
	syscall

	jal 	strdup		# duplicate string on heap
	beq	$v0, 1, cont	# if input is empty, branch 

	move	$a1, $v0	# starting address for data = $a1
	lw	$a2, head
	jal	addnode		# add a new node

	sw	$v0, head	# store new node's data address into head

	b 	loop
 cont: 
	la	$a0, newlin	# print new line
	li	$v0, 4
	syscall

	lw	$a0, head	# $a0 contains the last node's data address
	beqz	$a0, end	# if list is empty, branch
	la	$a1, print	# $a1 contains address for print function
	jal	traverse	# traverse list for printing
 end:
	li	$v0, 10
	syscall

 strdup:
	addi	$sp, -4		
	sw	$ra, ($sp)

	jal 	strlen		# call function to find the length of string

	lw	$ra, ($sp)	
	addi	$sp, 4

	beq	$v0, 1, finish	# if input is empty, branch

	addi	$v0, 1

	move	$a0, $v0	# allocate space on heap
	li	$v0, 9
	syscall

	move	$v1, $v0	# move starting address for input to v1
	la	$a0, input
	li	$t1, 0
 storstr:
	lb 	$t0, ($a0)      # load next character
  	sb 	$t0, ($v1)      # store character on heap
  	addi 	$a0, 1		# increment input address
 	addi 	$v1, 1		# increment heap address
	bnez	$t0, storstr	
 finish:
	jr	$ra

 strlen:
	li	$v0, 0		# designate register for counting
 while:
	lb	$t1, ($a0)	# load next character
	beqz	$t1, done	# check if character is 0 bit
	addi	$v0, 1		# increment count register
	addi	$a0, 1		# increment input address
	b 	while
 done:
	jr	$ra

 addnode:
	li	$a0, 8		# allocate space on heap
	li	$v0, 9
	syscall

	sw	$a1, ($v0)	# store starting address of data on heap
	sw	$a2, 4($v0)	# set next to previous data address

	jr	$ra

 traverse:
	addi	$sp, -8		# allocate space on stack and store return 
	sw	$ra, ($sp)	# address
	sw	$a0, 4($sp) 	# push current node's data address on stack
	
	addi	$a0, 4		# increment address to node's next address
	lw	$a0, ($a0)	# load the previous node's data address into $a0
	beqz	$a0, return	# if node was top node, branch
	jal	traverse
 return:
	lw	$a0, 4($sp)	# pop top node's data address off stack
	jalr	$a1		# jump to print 
	lw	$ra, ($sp)	# restore return address
	addi	$sp, 8		# deallocate stack space
	jr	$ra

 print: 
	lw	$a0, ($a0)	# print current node's data
	li	$v0, 4
	syscall

	jr	$ra
