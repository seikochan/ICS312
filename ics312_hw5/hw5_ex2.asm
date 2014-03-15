; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is strictly negative.
; It will then print out how many of the integers were:
;	divisible by 2
;	divisible by 3
;	divisible by 5
; We assume that the user enters valid numbers

%include "asm_io.inc"

segment .data
	prompt		db	"Enter an integer: ", 0
	divBy2		dd	0d	
	divBy3		dd	0d
	divBy5		dd	0d
	divBy2Str	db	"The number of integers divisible by 2 is ", 0
	divBy3Str	db	"The number of integers divisible by 3 is ", 0
	divBy5Str	db	"The number of integers divisible by 5 is ", 0

segment .bss
	userInt		resd	1

segment .text
        global  asm_main
asm_main:
	enter	0,0					; setup
	pusha						; setup
     
  do:						; start do-while loop
	mov 	eax, prompt	    	; prompts user to input an integer
	call	print_string
	call	read_int	    	; read the integer user inputs (as signed int)
	mov 	[userInt], eax 		; save user input
	cmp	eax, 0d					; eax-0d, compares uer int to 0d
	jl	endblock				; eax<0, user wants to exit loop
	mov edx, 0d 				; clear edx
	mov	ecx, 2d					; move divisor into ecx (dividend is in edx:eax)
	idiv	ecx					; edx:eax/2, eax=quotient, edx=remainder
	cmp	edx, 0d					; edx-0d, compare remainder from edx:eax/2 to 0d
	jnz	notDivBy2				; edx (remainder) != 0, therefore skip incrementing variable
	inc dword [divBy2]			; divBy2 = divBy2 + 1

  notDivBy2:					; not divisible by 2 so skip incrementing variable
    mov eax, [userInt]			; reset user input into eax (got overwritten by division quotient)
    mov edx, 0d 				; clear edx 
	mov	ecx, 3d					; move divisor into cx (dividend is in ax)
	idiv	ecx					; edx:eax/3, eax=quotient, edx=remainder
	cmp	edx, 0d					; edx-0d, compare remainder from edx:eax/2 to 0d
	jnz	notDivBy3				; ah (remainder) != 0	
	inc dword [divBy3]			; divBy3 = divBy3 + 1

  notDivBy3:					; not divisible by 3 so skip incrementing variable
 	mov eax, [userInt]			; reset user input into eax (got overwritten by division quotient)				 
	mov edx, 0d 				; clear edx
	mov	ecx, 5d					; move divisor into cx (dividend is in ax)
	idiv	ecx					; edx:eax/5, eax=quotient, edx=remainder
	cmp	edx, 0d					; edx-0d, compare remainder from edx:eax/2 to 0d
	jnz	notDivBy5				; ah (remainder) != 0	
	inc dword [divBy5]			; divBy5 = divBy5 + 1
	
  notDivBy5:					; not divisible by 5 so skip incrementing variable 
      	jmp	do					; start do-while loop over

  endblock:						; exit the do-while loop
	mov		eax, divBy2Str		; print divisible by 2 string
	call	print_string
	mov 	eax, [divBy2]		; print amount of entered ints divisible by 2
	call	print_int
	call	print_nl
	mov		eax, divBy3Str		; print divisible by 3 string
	call	print_string
	mov 	eax, [divBy3]		; print amount of entered ints divisible by 3
	call	print_int
	call	print_nl
	mov		eax, divBy5Str		; print divisible by 5 string
	call	print_string
	mov 	eax, [divBy5]		; print amount of entered ints divisible by 5
	call	print_int
	call	print_nl

	popa						; cleanup
	mov	eax, 0					; cleanup
	leave						; cleanup
	ret							; cleanup
