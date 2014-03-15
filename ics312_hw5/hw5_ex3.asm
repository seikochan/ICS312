; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is strictly negative.
; It will then print out how many of the integers were divisible
; by 1, 2, 3, 4, ..... 50.
; We assume that the user enters valid numbers 

%include "asm_io.inc"

segment .data
	prompt		db	"Enter an integer: ", 0
	divByStr1	db	"The number of integers divisible by ", 0
	divByStr2	db 	" is ", 0
	counter		db 	0d
	forcealign	db 	0d, 0d, 0d 										; ensure that the array below is aligned properly
	divisorArr times 50 dd 0
	increment 	db 	" incremented ", 0

segment .bss
	userInt		resd	1
	;divisorArr	resb	50

segment .text
        global  asm_main
asm_main:
	enter	0,0					; setup
	pusha						; setup

  while:						; start while loop
	mov 	eax, prompt	    	; prompts user to input an integer
	call	print_string
	call	read_int	    	; read the integer user inputs (as signed int)
	mov 	[userInt], eax 		; save user input
	cmp		eax, 0d				; eax-0d, compares uer int to 0d
	jl		whileEndBlock		; eax<0, user wants to exit loop

  for:							; for int counter=0, counter<50, i++
  	cmp 	byte [counter], 50d ; compare counter to 50
  	jge		forEndBlock			; counter >= 50 therefore get out of for loop
 	cmp 	byte [userInt], 0d  ; user entered a 0, so skip it, no number can divide by 0
 	je 		forEndBlock 

  	mov 	eax, [userInt]		; reset user input into eax (got overwritten by division quotient)
	mov 	edx, 0d 			; clear edx
	movsx 	ecx,  byte [counter]; move divisor into ecx (dividend is in edx:eax)
	inc 	ecx					; the divisor is actually 1 greater than the index
	idiv	ecx					; edx:eax/ecx, eax=quotient, edx=remainder
	cmp		edx, 0d				; edx-0d, compare remainder from edx:eax/2 to 0d
	jne		notDivisible		; edx (remainder) != 0, therefore skip incrementing variable
	imul 	ecx, [counter], 4d	; calculate offset from beginning of array
	mov 	ebx, divisorArr
	add 	ebx, ecx
	inc 	dword [ebx]

  notDivisible:					; not divisible so skip incrementing variable
    inc 	byte [counter]		; increment counter to the next divisor
    jmp		for					; start for loop over

  forEndBlock:
  	mov 	byte [counter], 0d 	; reset counter back to 0
  	jmp		while 				; start while loop over

  whileEndBlock:				; exit the while loop

  	mov 	byte[counter], 0d 	; reset counter back to 0

  for2:							; for int counter = 0, counter<50, i++
  	cmp 	byte [counter], 50d
  	jge		endBlock			; counter >= 50 therefore get out of for loop
	mov		eax, divByStr1		; print divisible by string
	call	print_string
	movsx 	eax, byte [counter]	; print the counter
	inc 	eax 				; need to increment it since it is 1 less than the actual divisor numbers
	call 	print_int
	mov 	eax, divByStr2		; print second part of divisible by string
	call	print_string
	mov 	eax, 0d 			; clear eax
	mov 	ebx, 0d 			; clear ebx
	mov 	ecx, 0d 			; clear ecx
	imul 	ecx, [counter], 4d	; calculate offset from beginning of array
	mov 	eax, divisorArr 	; create a pointer to beginning of array
	add 	eax, ecx  			; offset array to current index
	mov 	eax, [eax] 			; print the value at the index in the divisorArr
	call	print_int
	call	print_nl
	inc 	byte [counter]
	jmp		for2
  
  endBlock:

	popa						; cleanup
	mov	eax, 0					; cleanup
	leave						; cleanup
	ret							; cleanup
