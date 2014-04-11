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
	prompt 	db	"Enter an integer: ", 0					; prompt for user to enter another integer
	error 	db 	"Value already entered, try again!", 0 	; Error message for when user enters a value they have already entered
	index 	dd 	0										; current index in Array

segment .bss
	userInt 	resd 	1

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
	mov 	dword [userInt], eax 	; save user int

	; Call function findValue (return value in eax)
	push 	eax			 			; pass the 4-byte signed int to look for
	mov 	eax, dword [index] 		; grab the value index not the address
	push	eax						; pass the index of the Array to search up to
	push	Array 					; pass the address of the beginning of the Array to search
	call 	findValue
	add	esp, 12 					; "pop" off the 3 parameter values from the stack

	cmp 	eax, 0d 				; if(returnValue == 0)
	jz 		skipError 			 	; then didn't find value in Array so skip printing error

	mov 	eax, error 				; else, value was found in array 
	call 	print_string 			; so print an error message
	call 	print_nl
	jmp 	skipInc 	 			; skip incrementing index and storing repeated value

skipError:
	mov 	edx, dword [index] 		; move index to an open register
	imul 	edx, 4 					; multiply it by 4 since we are doing 4-bytes
	add 	ecx, edx 				; use the current index to offset the array to the correct position
	mov 	eax, dword [userInt]
	mov 	dword [ecx], eax 		; move the user int to the correct index in the array
	inc 	dword [index] 			; increment he index
	
skipInc:
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


;; Takes 3 arguments, an address, a number n, and a 4-byte 
;; signed integer value.  Then the function goes through 
;; 4-byte values starting at the addressed passed, going through
;; at MOST n values.  If the value passedd as the 3rd argument is
;; found, then it returns the address of that 4-byte value.  
;;  If not found, it returns 0.
;; If n = 0, function does nothing and returns 0.
;; function: findValue

segment .data
	index2 	dd 	0d

segment .bss
	retVal 	resd 	1 					; the return value, if 0 value not found, if not 0, value found at specified address

segment .text

findValue:
	push 	ebp						; save the previous base pointer
	mov 	ebp, esp		 		; overwrite the base pointer to the stack pointer	
	pusha 							; save all the register values from caller

	mov 	ebx, [ebp+12] 			; n number of integers to loop over 
	mov 	edx, [ebp+16] 			; 4-byte int that we are searching for

arrayLoop:
	mov 	ecx, [ebp+8]			; point ecx to the begining of the array to loop through
	cmp 	dword [index2], ebx 	; if(index2 == n)
	jz 		notFoundIt	 			; then exit out of loop, unsuccessful at finding int looking for

	mov 	eax, dword [index2] 	; else, move index to an open register
	imul 	eax, 4 					; multiply by 4 since we are doing 4-bytes
	add 	ecx, eax 				; use the current index to offset the array to the correct position
	cmp 	edx, dword [ecx] 		; if(intSearchingFor == currentInt)
	jz 		foundIt 				; then, we found int looking for can exit loop

	inc 	dword [index2]
	jmp 	arrayLoop				; else, start loop over again

foundIt:
	mov 	dword [retVal], ecx 	; return the address of where we found the int
	jmp 	endArrayLoop


notFoundIt:
	mov 	dword [retVal], 0d		; return the value 0 since findValue was unsuccessful

endArrayLoop:
	mov 	dword [index2], 0d 		; reset the index2 back to 0
	popa	 						; restore register values from caller
	mov 	eax, dword [retVal] 	; overwrite eax with the return value
	pop 	ebp						; pop off the previous base pointer and put it back into ebp
	ret 							; return to where this function was called from

