### AUTHOR: Ethan Holley
###
### DESCRIPTION: This MIPS program sorts an array of integers by implementing the sorting methods 
### MergeSort and Quicksort. QuickSort uses various functon calls and recursion to sort an array of 
### integers.

.text
.globl merge
merge:
	# BLOCK COMMENT: C Code - Function #1
	# void merge(int *a, int aLen, int *b, int bLen, int *out) {
		# int posA=0, posB=0;
		# while (posA < aLen || posB < bLen) {
			# if (posB == bLen || posA < aLen && a[posA] <= b[posB]) {
				# out[posA+posB] = a[posA];
				# posA++;
			# } else {
				# out[posA+posB] = b[posB];
				# posB++;
			# }
			# merge_debug(out, posA+posB);
		# }
	# }
	addiu $sp, $sp, -28         # allocate stack space -- default of 24 here
	sw    $fp, 0($sp)           # save frame pointer of caller
	sw    $ra, 4($sp)           # save return address
	addiu $fp, $sp,  24         # setup frame pointer
	
	add   $t0, $a0, $zero       # copy address of int *a into t0
	add   $t1, $a2, $zero       # copy address of int *b into t1
	add   $t5, $a1, $zero       # copy int aLen into t5
	
	addi  $t2, $zero, 0	    # t2 = posA, posA = 0
	addi  $t3, $zero, 0	    # t3 = posB, posB = 0
	
	lw    $t9, 0($fp)           # t9 = out*, load parameter 5 from stack into register t9
	
WHILE:
	slt   $t8, $t2, $t5         # t8 = posA < aLen
	bne   $t8, $zero, CHECK_IF  # if posA < aLen, branch to IF
	slt   $t6, $t3, $a3         # t8 = posB < bLen
	bne   $t6, $zero, CHECK_IF  # if posB < bLen, branch to IF
	j     EPILOGUE

CHECK_IF:
	bne   $t3, $a3, CHECK_AND   # if posB != bLen, branch to CHECK_AND
	j     ADD_A

CHECK_AND:
	slt   $t8, $t2, $t5         # t8 = posA < aLen
	beq   $t8, $zero, ELSE      # if t8 == 0, branch to ELSE
	sll   $t4, $t2, 2	    # get address of posA
	add   $t6, $t0, $t4 	    
	lw    $t4, 0($t6)	    # t4 = a[posA]
	sll   $t7, $t3, 2	    # get address of posB
	add   $t7, $t1, $t7 
	lw    $t7, 0($t7)	    # t7 = b[posB]
	slt   $t8, $t7, $t4         # t8 = b[posB] < a[posA]
	bne   $t8, $zero, ELSE      # if b[posB] < a[posA], branch to ELSE
	
	add   $t6, $t2, $t3	    # t6 = posA + posB
	sll   $t6, $t6, 2 	    # get address of t6 to store into out array
	add   $t6, $t9, $t6
	sw    $t4, 0($t6)           # store val into out array: out[posA+posB] = a[posA];
	addi  $t2, $t2, 1	    # posA ++
	j     CALL_FUNC

ADD_A:
	sll   $t4, $t2, 2	    # get address of posA
	add   $t6, $t0, $t4 	    
	lw    $t4, 0($t6)	    # t4 = a[posA]
	add   $t6, $t2, $t3	    # t6 = posA + posB
	sll   $t6, $t6, 2 	    # get address of t6 to store into out array
	add   $t7, $t9, $t6
	sw    $t4, 0($t7)           # store val into out array: out[posA+posB] = a[posA];
	addi  $t2, $t2, 1	    # posA ++
	j     CALL_FUNC

ELSE:
	sll   $t4, $t3, 2	    # get int address of posB
	add   $t6, $t1, $t4         # add address to int b array
	lw    $t4, 0($t6)	    # t4 = b[posB]
	add   $t6, $t2, $t3	    # t6 = posA + posB
	sll   $t6, $t6, 2 	    # get address of t6 to store into out array
	add   $t7, $t6, $t9	    # add address to int out array
	sw    $t4, 0($t7)           # store val into out array: out[posA+posB] = b[posB];
	addi  $t3, $t3, 1	    # posB ++
	j     CALL_FUNC
	
CALL_FUNC:
				# save temporary registers to the stack
    	addiu $sp, $sp, -40         # allocate space for saving $t0-$t9 
    	sw    $t0, 0($sp)           
    	sw    $t1, 4($sp)          
    	sw    $t2, 8($sp)           
    	sw    $t3, 12($sp)          
    	sw    $t4, 16($sp)         
    	sw    $t5, 20($sp)         
    	sw    $t6, 24($sp)         
    	sw    $t7, 28($sp)          
    	sw    $t8, 32($sp)         
    	sw    $t9, 36($sp)          

    	add   $a0, $t9, $zero       # a0 = t9
    	add   $a1, $t2, $t3         # a1 = posA + posB
    	jal   merge_debug           # call merge_debug 

    	lw    $t0, 0($sp)           # restore t registers
    	lw    $t1, 4($sp)          
    	lw    $t2, 8($sp)          
    	lw    $t3, 12($sp)          
    	lw    $t4, 16($sp)         
    	lw    $t5, 20($sp)          
    	lw    $t6, 24($sp)         
    	lw    $t7, 28($sp)          
    	lw    $t8, 32($sp)          
    	lw    $t9, 36($sp)          
    	addiu $sp, $sp, 40          

    	j     WHILE                  # jump to WHILE
	
EPILOGUE:
	lw    $ra, 4($sp)           # get return address from stack
	lw    $fp, 0($sp)           # restore the frame pointer of caller
	addiu $sp, $sp, 28          # restore the stack pointer of caller
	jr    $ra 		    # return to code of caller

.globl quicksort
	# BLOCK COMMENT: C CODE - Function #2
	# void quicksort(int *data, int n) {
		# if (n < 2)
			# return;
		# int left = 1; // first unsorted index. Note that [0] is the pivot.
		# int right = n-1; // last unsorted index
		# while (left <= right) {
			# quicksort_debug(data,n, left,right);
			# while (left <= right && data[left] <= data[0])
				# left++;
			# while (left <= right && data[right] > data[0])
				# right--;
			# if (left < right) {
				# quicksort_debug(data, n, left,right);
				# int tmp = data[left];
				# data[left] = data[right];
				# data[right] = tmp;
				# left++;
				# right--;
			# }
		#}
		# quicksort_debug(data, n, left,right);
		# int tmp = data[0];
		# data[0] = data[left-1];
		# data[left-1] = tmp;
		# quicksort_debug(data, n, -1, -1);
		# quicksort(data, left-1);
		# quicksort(data+left, n-left);
		# quicksort_debug(data, n, -1,-1);
		# }
quicksort:
	addiu $sp, $sp, -24         # allocate stack space -- default of 24 here
	sw    $fp, 0($sp)           # save frame pointer of caller
	sw    $ra, 4($sp)           # save return address
	addiu $fp, $sp,  20         # setup frame pointer
	
	add   $t0, $a0, $zero       # t0 = int *data
	add   $t1, $a1, $zero       # t1 = int n
	
	slti  $t2, $t1, 2  	    # t2 = n < 2
	bne   $t2, $zero, EPILOGUE2 # if n < 2, branch to EPILOGUE2
	
	addi  $t3, $zero, 1	    # t3 = left, left = 1
	addi  $t4, $t1, -1	    # t4 = right, right = n - 1
	
OUTERLOOP:
	slt   $t6, $t4, $t3	    # t5 = right < left
	bne   $t6, $zero, LASTCALL  # if right < left, branch to LASTCALL
	j     FIRSTCALL	    	    
	
FIRSTCALL:
	
	addi  $sp, $sp, -20	    # save important t registers
	sw    $t0, 0($sp)
	sw    $t1, 4($sp)
	sw    $t3, 8($sp)
	sw    $t4, 12($sp)
	sw    $t5, 16($sp)
	
	add   $a0, $t0, $zero	    # a0 = data
	add   $a1, $t1, $zero	    # a1 = n
	add   $a2, $t3, $zero	    # a2 = left
	add   $a3, $t4, $zero	    # a3 = right
	jal   quicksort_debug	    # CALL quicksort_debug(data, n, left,right)
		
	lw    $t0, 0($sp)	    # reload t registers
	lw    $t1, 4($sp)
	lw    $t3, 8($sp)
	lw    $t4, 12($sp)
	lw    $t5, 16($sp)
	addiu $sp, $sp, 20
	
	j     FIRSTWHILE
	
FIRSTWHILE:
	slt   $t5, $t4, $t3	      # t5 = right < left
	bne   $t5, $zero, SECONDWHILE # if right < left, branch to SECONDWHILE
	sll   $t7, $t3, 2	      # t7 = left * 4
	add   $t7, $t0, $t7 	      # add base address + t7
	lw    $t7, 0($t7)	      # t7 = data[left]
	lw    $t2, 0($t0) 	      # t2 = data[0]
	slt   $t5, $t2, $t7	      # t5 = data[0] < data[left]
	bne   $t5, $zero, SECONDWHILE # if (data[0] < data[left]), branch to SECONDWHILE
	addi  $t3, $t3, 1	      # left ++
	j     FIRSTWHILE	      # jump back to FIRSTWHILE

SECONDWHILE:
	slt   $t5, $t4, $t3	       # t5 = right < left
	bne   $t5, $zero, IF_STATEMENT # if right < left, branch to IF_STATEMENT
	
	sll   $t7, $t4, 2	       # t7 = right * 4
	add   $t7, $t0, $t7 	       # add base address + t7
	lw    $t7, 0($t7)	       # t7 = data[right]
	lw    $t2, 0($t0) 	       # t2 = data[0]
	
	slt   $t5, $t2, $t7	       # t5 = data[right] > data[0]	       
	beq   $t5, $zero, IF_STATEMENT # if data[right] < data[0], branch to IF_STATEMENT

	addi  $t4, $t4, -1	      # right --
	j     SECONDWHILE	      # jump back to SECONDWHILE

IF_STATEMENT:
	slt   $t5, $t3, $t4	      # t5 = left < right
	bne   $t5, $zero, TRUE        # if left < right, branch to SECONDCALL
	j     OUTERLOOP	    	      # jump back to OUTERLOOP if false
	
TRUE:
	addi  $sp, $sp, -20	      # save important t registers
	sw    $t0, 0($sp)	 
	sw    $t1, 4($sp)
	sw    $t3, 8($sp)
	sw    $t4, 12($sp)
	sw    $t5, 16($sp)
	
	add   $a0, $t0, $zero	      # a0 = data
	add   $a1, $t1, $zero	      # a1 = n
	add   $a2, $t3, $zero	      # a2 = left
	add   $a3, $t4, $zero	      # a3 = right
	jal   quicksort_debug	      # CALL quicksort_debug(data, n, left,right)
	
	lw    $t0, 0($sp)	      # reload t registers
	lw    $t1, 4($sp)	
	lw    $t3, 8($sp)
	lw    $t4, 12($sp)
	lw    $t5, 16($sp)
	addi $sp, $sp, 20
    	
    	sll   $t7, $t3, 2	     # t7 = left * 4
	add   $t7, $t0, $t7 	     # add base address + t7
	lw    $t9, 0($t7)	     # t9 = temp, temp = data[left]
	sll   $t8, $t4, 2	     # t8 = right * 4
	add   $t8, $t0, $t8 	     # t8 = add base address + t8
	lw    $t6, 0($t8) 	     # t6 = data[right]
	
	sw    $t6, 0($t7) 	     # data[left] = data[right]
	sw    $t9, 0($t8) 	     # data[right] = temp
	
	addi  $t3, $t3, 1	     # left ++
	addi  $t4, $t4, -1	     # right --
	j     OUTERLOOP		     # jump back to OUTERLOOP

LASTCALL:
	
	addi  $sp, $sp, -20	     # save important t registers
	sw    $t0, 0($sp)
	sw    $t1, 4($sp)
	sw    $t3, 8($sp)
	sw    $t4, 12($sp)
	sw    $t5, 16($sp)
	
	add   $a0, $t0, $zero	     # a0 = data
	add   $a1, $t1, $zero	     # a1 = n
	add   $a2, $t3, $zero	     # a2 = left
	add   $a3, $t4, $zero	     # a3 = right
	jal   quicksort_debug	     # call quicksort_debug(data, n, left,right)
	
	lw    $t0, 0($sp)	     # load back t registers
	lw    $t1, 4($sp)
	lw    $t3, 8($sp)
	lw    $t4, 12($sp)
	lw    $t5, 16($sp)
	addiu $sp, $sp, 20

	
	lw    $t8, 0($t0)	    # t8 = data[0], t8 = temp
	addi  $t7, $t3, -1           # t7 = left - 1
	sll   $t7, $t7, 2	    # t7 = (left - 1) * 4
	add   $t7, $t0, $t7 	    # add base address + t7
	lw    $t9, 0($t7) 	    # t9 = data[left-1]
	
	sw    $t9, 0($t0) 	    # data[0] = data[left-1]
	sw    $t8, 0($t7) 	    # data[left-1] = temp
	
    	
    	addi  $sp, $sp, -20	    # save t registers
	sw    $t0, 0($sp)
	sw    $t1, 4($sp)
	sw    $t3, 8($sp)
	sw    $t4, 12($sp)
	sw    $t5, 16($sp)
	
	addi  $t8, $zero, -1	   
	addi  $t9, $zero, -1
	
	add   $a0, $t0, $zero	    # a0 = data
	add   $a1, $t1, $zero       # a1 = n
	add   $a2, $t8, $zero       # a2 = -1
	add   $a3, $t9, $zero       # a3 = -1
	jal   quicksort_debug	    # CALL quicksort_debug(data, n, -1, -1)
	
	lw    $t0, 0($sp)           # reload t registers
	lw    $t1, 4($sp)
	lw    $t3, 8($sp)
	lw    $t4, 12($sp)
	lw    $t5, 16($sp)
	addiu $sp, $sp, 20
	
	
	addi  $sp, $sp, -20	    # save t registers
	sw    $t0, 0($sp)	   
	sw    $t1, 4($sp)
	sw    $t3, 8($sp)
	sw    $t4, 12($sp)
	sw    $t5, 16($sp)
	
	add   $a0, $t0, $zero	    # a0 = data
	addi  $t8, $t3, -1 	    # t8 = left - 1
	add   $a1, $t8, $zero       # a1 = t8
	jal   quicksort
	
	lw    $t0, 0($sp)	    # reload t registers
	lw    $t1, 4($sp)
	lw    $t3, 8($sp)
	lw    $t4, 12($sp)
	lw    $t5, 16($sp)
	addiu $sp, $sp, 20
	

	addi  $sp, $sp, -20	    # save t registers
	sw    $t0, 0($sp)
	sw    $t1, 4($sp)
	sw    $t3, 8($sp)
	sw    $t4, 12($sp)
	
	sll   $t6, $t3, 2	    # t6 = left * 4
	add   $t6, $t6, $t0	    # t6 = left * 4 + base
	add   $a0, $t6, $zero	    # a0 = data + left
	sub   $t9, $t1, $t3 	    # t9 = n - left
	add   $a1, $t9, $zero	    # a1 = t9
	jal   quicksort	            # call quicksort
	
	lw    $t0, 0($sp)	    # reload t registers
	lw    $t1, 4($sp)
	lw    $t3, 8($sp)
	lw    $t4, 12($sp)
	lw    $t5, 16($sp)
	addiu $sp, $sp, 20
	
	
	addi  $t8, $zero, -1
	addi  $t9, $zero, -1
	
	add   $a0, $t0, $zero	    # a0 = data
	add   $a1, $t1, $zero       # a1 = n
	add   $a2, $t8, $zero       # a2 = -1
	add   $a3, $t9, $zero	    # a3 = -1
	jal   quicksort_debug	    # CALL quicksort_debug(data, n, -1, -1)
	   
	
EPILOGUE2:
	lw    $ra, 4($sp)           # get return address from stack
	lw    $fp, 0($sp)           # restore the frame pointer of caller
	addiu $sp, $sp, 24          # restore the stack pointer of caller
	jr    $ra 	
