; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is zero.
; For each entered integer, the program prints out the binary 
; representation of the number.
; We assume that the user enters valid numbers 

%include "asm_io.inc"

segment .data
	prompt		db	"Enter an integer: ", 0
	binaryRep		db	"Binary representation: ", 0
	bitNum 		dd  0d

segment .text
        global  asm_main
asm_main:
	enter	0,0					        ; setup
	pusha						        ; setup

while:						            ; start while loop
	mov 	eax, prompt	    	     	; prompts user to input an integer
	call	print_string	
	call	read_int	    	        ; read the integer user inputs (as signed int)
	cmp		eax, 0d				        ; eax-0d, compares uer int to 0d
	je		whileEndBlock		      	; eax=0, user wants to exit loop
	mov 	ebx, eax 					; save user int into ebx
	mov 	eax, binaryRep
	call 	print_string 

for:							        ; for int counter=0, counter<32, i++
  cmp 	dword [bitNum], 32d   			; compare counter to 32
  jge	forEndBlock			      		; counter >= 32 therefore get out of for loop
  shl 	ebx, 1 							; left shift bits in eax by 1, bit shifted out stored in CF
  jnc 	carryNotSet 					; CF = 0, so don't print 1
  mov 	eax, 1d 						; CF = 1, so print 1
  call 	print_int
  inc 	dword [bitNum]
  jmp 	for 							; start for loop over
carryNotSet:							; CF =0, so print 0
  mov 	eax, 0d
  call 	print_int
  inc 	dword [bitNum]	
  jmp 	for 							; start for loop over

forEndBlock:
	mov 	dword [bitNum], 0d 	  		; reset bitNum back to 0
	call 	print_nl
	jmp		while 				        ; start while loop over

whileEndBlock:				        	; exit the while loop


popa						            ; cleanup
mov	eax, 0					            ; cleanup
leave						            ; cleanup
ret							            ; cleanup