.data
    N = 8      ; N must be even
    error_msg: .asciz "N must be even."
	array: .skip N*4   ; allocate N space for an array (be sure to change the number here too)

.text
main:
    ldr r2, =N        ; load N into r2
    tst r2, #1        ; see if the zero bit is 0
    bne error         ; if it's not, N is not even, so exit with error message
	mov r3, #0		  ; start a counter in r3
	ldr r4, =array    ; store the memory address of the first array element in r4
    b fill_random     ; start loop to fill the array with random numbers
fill_random:
    swi 0x6d          ; get the current time tick
    mov r5, r0        ; store that number in r4 
    and r5, r5, #0xff ; strip off everything but the least important 8 bits
    str r5, [r4], #4  ; store the random number in the array
	add r3, r3, #1	  ; increment the counter
	cmp r3, r2		  ; check if the counter is equal to N (which is in r2)
    blt fill_random   ; loop until end of array
	mov r3, #0		  ; otherwise, reset the counter in r3 to 0 for the next loop
	ldr r2, =N/2	  ; set r2 to half of N (because we want to loop that many times in add_pairs)
	ldr r4, =array    ; store the memory address of the first array element in r4
    b add_pairs       ; start loop to add pairs and print results
add_pairs:
    ldr r5, [r4], #4  ; load the first number in the pair into r5
    ldr r6, [r4], #4  ; load the second number in the pair into r6
    add r5, r5, r6    ; add the two numbers together
    mov r0, #1        ; set r0 to 1 to indicate that we want to print
	mov r1, r5		  ; load the result number thats in r5 into r1 to be printed
    swi 0x6b          ; print the result
	add r3, r3, #1	  ; increment the counter
	cmp r3, r2		  ; check if counter is equal to r2
    blt add_pairs     ; loop until end of array
    b exit            ; otherwise, exit the program
error:
    mov r0, #1        ; set r0 to 1 to indicate that we want to print
    ldr r1, =error_msg	; load the error message
    swi 0x69		  ; print the result
exit:
    swi 0
