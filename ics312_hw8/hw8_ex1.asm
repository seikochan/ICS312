%include "asm_io.inc"

segment .bss
	Array	resd	10

segment .text
        global  asm_main

asm_main:
	enter	0,0			; setup
	pusha				; setup

	; Call function inputArray
	push 	dword 10
	push	Array
	call	inputArray
	add	esp, 8

	; Call function printArray
	push	dword 10
	push	Array
	call	printArray
	add	esp, 8

	popa				; cleanup
	mov	eax, 0			; cleanup
	leave				; cleanup
	ret					; cleanup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; DO NOT MODIFY ANYTHING ABOVE THIS LINE ;;;;;;;;;;;;;;;

;; Takes 2 arguments, an address and a number n, and queries the user for n
;; 4-byte signed numbers which are stored one after the other starting at 
;; the address passed in.
;; function inputArray
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data
	prompt 	db	"Enter an integer: ", 0d	; prompt for user to enter another integer
	index 	dd 	0d							; current index in Array

segment .text

inputArray:
	push 	ebp 					; save the previous base pointer
	mov 	ebp, esp				; overwrite the base pointer to the stack pointer

	mov 	ebx, dword [ebp+12] 	; n number of integers to get from user (param 2)

inputLoop:

	mov 	ecx, [ebp+8]			; point ecx to the begining of the array (param 1)
	cmp 	dword [index], ebx 		; if(index == n)
	jz 		endInputLoop			; then exit loop
	mov 	eax, prompt 			; else, print the prompt
	call 	print_string
	mov 	eax, 0d 				; clear eax
	call 	read_int				; get the integer the user enters
	mov 	edx, dword [index] 		; move index to an open register
	imul 	edx, 4 					; multiply it by 4 since we are doing 4-bytes
	add 	ecx, edx 				; use the current index to offset the array to the correct position
	mov 	dword [ecx], eax 		; move the user int to the correct index in the array
	inc 	dword [index] 			; increment he index
	jmp 	inputLoop 				; start the inputLoop again


endInputLoop:
	mov 	esp, ebp 				; move the stack pointer back up to the base pointer
	pop 	ebp 					; pop off the previous base pointer and put it back into ebp 
	ret 							; return to where this function was called from


;; Takes 2 arguments, an address and a number n, and prints a comma-separated
;; list of all the integers.
;; To implement: function printArray
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

segment .data
	listPrompt 		db 	"List: ", 0 	; output prompt
	delimeter 	db 	", ", 0 			; list delimeter

segment .bss

segment .text

printArray:
	push 	ebp						; save the previous base pointer
	mov 	ebp, esp		 		; overwrite the base pointer to the stack pointer
	mov 	dword [index], 0d 		; reset the index back to 0 (since we want to loop through the Array again)

	mov 	ebx, [ebp+12] 			; n number of integers to get from user
	mov 	eax, listPrompt 		; print the output prompt
	call 	print_string

outputLoop:
	mov 	ecx, [ebp+8]			; point ecx to the begining of the array
	cmp 	dword [index], ebx 		; if(index == n)
	jz 		endOutputLoop 			; then exit out of loop
	mov 	edx, dword [index] 		; else, move index to an open register
	imul 	edx, 4 					; multiply by 4 since we are doing 4-bytes
	add 	ecx, edx 				; use the current index to offset the array to the correct position
	mov 	eax, 0d 				; clear eax
	mov 	eax, dword [ecx]		; put the 4-byte int at the current index into eax
	call 	print_int  				; print the signed integer value
	mov 	eax, ebx 
	dec 	dword eax
	cmp 	dword [index], eax 		; if(index == (n-1))
	jz 		endOutputLoop 			; then this is the last element in the Array, so don't print the delimeter, and exit loop
	mov 	eax, delimeter 			; print list delimeter
	call 	print_string
	inc 	dword [index] 			; increment the index
	jmp 	outputLoop 				; start output loop again

endOutputLoop:
	call 	print_nl				
	mov 	esp, ebp 				; move the stack pointer back up to the base pointer	
	pop 	ebp						; pop off the previous base pointer and put it back into ebp
	ret 							; return to where this function was called from

