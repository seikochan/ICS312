; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is zero.
; For each entered integer, the program prints out the binary 
; representation of the number.
; Then it prints out the number of times the pattern "10*1" occurs 
; in the binary representation.  Patterns can overlap.
; We assume that the user enters valid numbers 

%include "asm_io.inc"

segment .data
	prompt		db				"Enter an integer: ", 0
	binaryRep	db				"Binary representation: ", 0
	numPatterns db 				"# patterns: ", 0
	bitArr 		times 32 db 	0d
	bitNum 		dd  0d
	patternCount db 0d

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
	mov 	ecx, bitArr					; make ecx point to beginning of bitArr
	mov 	eax, binaryRep 				; print the string "Binary representation: "
	call 	print_string 

storeBitsLoop:							; for int i=0, i<32, i++  (i=bitNum)
  cmp 	dword [bitNum], 32d   			; compare i to 32
  jge	endBitsLoop		      			; i >= 32 therefore get out of for loop
  shl 	ebx, 1 							; left shift bits in eax by 1, bit shifted out stored in CF
  jnc 	carryNotSet 					; CF = 0, so don't store/print 1
  mov 	eax, 1d 						; CF = 1, so print 1
  call 	print_int
  mov 	byte [ecx], 1d 					; store bit in bitArr
  jmp 	skipCarryNotSet
carryNotSet:							; CF =0, so print 0
  mov 	eax, 0d
  call 	print_int 
  mov 	byte [ecx], 0d 					; store bit in bitArr
skipCarryNotSet:
  inc 	ecx								; move pointer to next byte in bitArr
  inc 	dword [bitNum]	 				; i++
  jmp 	storeBitsLoop 					; start for loop over

endBitsLoop:
  mov 	dword [bitNum], 0d 	  		; reset bitNum back to 0
  call 	print_nl
  mov 	ecx, bitArr 				; move pointer back to beginning of bitArr
  mov 	ebx, 0d 					; clear ebx

;;loop through the bitArr and check every 4 bytes if equals 01000001h or 01000101h, incrementing by only 1
countPatternLoop: 						; for int i=0, i<29, i++
	cmp 	ebx, 29d 					; compare i to 29
	je 		endPatternLoop 				; if i=29, end loop
	mov 	eax, dword [ecx] 			; move the current 4 bytes of ecx into eax
	cmp 	eax, 01000001h 				; must compare to reverse since Little Endian	
	je 		partOfPattern 				; if equal, then it matches
	mov 	eax, dword [ecx] 			; move the current 4 bytes of ecx into eax
	cmp 	eax, 01010001h 				; must conpare to revesrse since Little Endian
	je 		partOfPattern
	jmp 	skipPattern
partOfPattern:
	inc 	byte [patternCount] 		; it matches so increment counter
skipPattern:
	inc 	byte ecx 					; move pointer over to next byte in bitArr
	inc 	ebx							; i++
	jmp 	countPatternLoop 			; restart loop

endPatternLoop:
	mov 	eax, numPatterns 			; print "# patterns: "
	call 	print_string
	movzx 	eax, byte [patternCount] 	; prints the amount that the pattern 10*1 was found (either 1011 or 1001)
	call 	print_int
	call 	print_nl
	mov 	byte [patternCount], 0d 	; reset pattern counter to 0
	jmp		while 				        ; start while loop over

whileEndBlock:				        	; exit the while loop


popa						            ; cleanup
mov	eax, 0					            ; cleanup
leave						            ; cleanup
ret							            ; cleanup