# Dylan Michalak
# Elias Alvarez
# CS2640-02
# Final Project - Bubble Sort implemented in MIPS assembly
# Due 5/14/2023

.macro print_array(%start_address, %length)
.data

	space: .asciiz " "

.text
	# load starting adress of the array, initialize loop counter and end point
	move $t0, %start_address
	li $t1, 0
	move $t2, %length
	
	# loop to print the array
	loop:
		# end loop if counter equals end point
		beq $t1, $t2, end_loop
		
		# multiply counter by 4 and add to starting adress to get adress
		# of current array entry
		mul $t3, $t1, 4
		add $t3, $t3, $t0
		
		# print current array entry
		lw $a0, ($t3)
		li $v0, 1
		syscall
		
		# print space before next entry
		la $a0, space
		li $v0, 4
		syscall
		
		# increment loop
		addi $t1, $t1, 1
		
		j loop
		
	end_loop:
	
.end_macro


.data

array: .word 7, 11, 4, 9, 11, 0, 0, 0, 5, 21
array_length: .word 10
start_text: .asciiz "The array to be sorted is: "
end_text: .asciiz "The sorted array is: "
newline: .asciiz "\n"

.text
main:
# print starting array string
la $a0, start_text
li $v0, 4
syscall

# load array and its length into $t4, $t5 registers
la $t4, array
lw $t5, array_length

print_array($t4, $t5)

la $a0, newline # $v0 already set to print string from macro execution
syscall

# IMPLEMENTATION OF BUBBLE SORT ALGORITHM 

# set $t6 equal to 1 less than the array length, to avoid comparing last array entry to random bytes
subi $t6, $t5, 1

outer_loop:
	
	li $t0, 0 # initialize outer loop end condition -> changes to "1" if any swap is performed during an iteration
	li $t1, 0 # initialize inner loop counter
	
	inner_loop:
		beq $t6, $t1, end_inner # end inner loop after $t5 iterations
		
		# multiply counter by 4 and add to starting adress to get adress
		# of current array entry
		mul $t2, $t1, 4
		add $t2, $t2, $t4
		
		# store current array entry in $s0, following array entry in $s1
		lw $s0, ($t2)
		lw $s1, 4($t2)
		
		# if first value is greater than following, swap them
		bgt $s0, $s1, swap_entries
		return: # doing this because idk how to branch with a link
		
		# increment counter and repeat
		addi $t1, $t1, 1
		j inner_loop
	end_inner:
	
	# end algorithm when the whole array is iterated with no swaps
	beq $t0, 0, end_outer
	j outer_loop
end_outer:

# END IMPLEMENTATION OF BUBBLE SORT ALGORITHM

la $a0, end_text # $v0 still set to print string command
syscall

print_array($t4, $t5) 

# end program
li $v0, 10
syscall

swap_entries:
	
	# store lower value in second spot, store higher value in first spot
	sw $s1, ($t2)
	sw $s0, 4($t2)
	
	# indicate a swap occured to repeat the outer loop
	li $t0, 1
	
	# return to next line in algorithm
	j return