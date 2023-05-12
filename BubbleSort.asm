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

.align 2
array: .word 5, 4, 3, 2, 1
start_text: .asciiz "The array to be sorted is: "
end_text: .asciiz "The sorted array is: "

.text

la $t4, array
li $t5, 5

print_array($t4, $t5)

li $v0, 10
syscall
