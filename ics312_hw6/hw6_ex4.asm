; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is zero.
; For each entered integer, the program prints out the binary 
; representation of the number.
; It then prompts the user for a binary motif to search for.
; Then it prints out the number of times the provided motif occurs 
; in the binary representation.  Patterns can overlap.
; Currently can only handle up to 4 byte motifs.
; We assume that the user enters valid numbers 

%include "asm_io.inc"

segment .data
	enter1		db 			"ENTERED: 1",0
	enter2		db 			"ENTERED: 2",0
	enter3		db 			"ENTERED: 3",0
	enter4		db 			"ENTERED: 4",0

	prompt		db				"Enter an integer: ", 0
	binaryRep	db				"The ninary representation is: ", 0
	numMotifs db 				"The number of motifs is: ", 0
	motifPrompt	db 				"Enter a binary motif: ", 0
	bitArr 		times 32 db 	0d
	bitNum 		dd  0d
	motifCount 	db 0d
	motifLength	db 0d
	motifArr 	times 32 db 	0d


segment .text
        global  asm_main
asm_main:
	enter	0,0					        ; setup
	pusha						        ; setup

	mov 	eax, prompt	    	     	; prompts user to input an integer
	call	print_string	
	call	read_int	    	        ; read the integer user inputs (as signed int)
	cmp		eax, 0d				        ; eax-0d, compares uer int to 0d
	je		exitBlock				      	; eax=0, user wants to exit
	mov 	ebx, eax 					; save user int into ebx
	call 	read_char					; bogus call to read_char to clear left over line feed character from read_int
	mov 	ecx, bitArr					; make ecx point to beginning of bitArr
	mov 	eax, binaryRep
	call 	print_string 

storeBitsLoop:							; for int counter=0, counter<32, i++
  cmp 	dword [bitNum], 32d   			; compare counter to 32
  jge	endBitsLoop		      			; counter >= 32 therefore get out of for loop
  shl 	ebx, 1 							; left shift bits in eax by 1, bit shifted out stored in CF
  jnc 	carryNotSet 					; CF = 0, so don't print 1
  mov 	eax, 1d 						; CF = 1, so print 1
  call 	print_int
  mov 	byte [ecx], 1d 					; store bit in bitArr
  jmp 	skipCarryNotSet
carryNotSet:							; CF =0, so print 0
  mov 	eax, 0d
  call 	print_int
  mov 	byte [ecx], 0d
skipCarryNotSet:
  inc 	ecx								; move pointer to next byte in bitArr
  inc 	dword [bitNum]	
  jmp 	storeBitsLoop 					; start for loop over

endBitsLoop:
  mov 	dword [bitNum], 0d 	  		; reset bitNum back to 0
  call 	print_nl


;; prompt user for binary motif and save it as a hex
  mov 	eax, motifPrompt
  call 	print_string
  mov 	ebx, motifArr


binaryMotifLoop:
  mov 	eax, 0d
  call 	read_char
  cmp 	eax, 10d 					; check if character is ASCII code 10 meaning user pressed enter (line return)
  je 	endBinaryMotifLoop
  cmp 	eax, 48d  					; ASCII code for 0, is 48d
  jne 	skipBinaryZero
  mov   byte [ebx], 0d
  jmp 	continueMotifLoop
skipBinaryZero:
  cmp 	eax, 49d 					; ASCII code for 0, is 49d
  jne 	exitBlock					; not a binary number, exit
  mov 	byte [ebx], 1d
continueMotifLoop:
  inc 	byte [motifLength]
  inc 	byte ebx
  jmp 	binaryMotifLoop

endBinaryMotifLoop:
  mov 	ecx, bitArr 				; move pointer back to beginning of bitArr
  mov 	ebx, 0d 					; i=0

  cmp 	byte [motifLength], 1d
  je 	oneByteMotif
  cmp 	byte [motifLength], 2d
  je 	twoByteMotif
  cmp 	byte [motifLength], 3d
  je 	threeByteMotif
  cmp 	byte [motifLength], 4d
  jne 	endPatternLoop
  mov 	edx, dword [motifArr]
  jmp 	countFourByteMotif
oneByteMotif:
  mov 	dl, byte [motifArr]
  jmp 	countOneByteMotif
twoByteMotif:
  mov 	dx, word [motifArr]
  jmp countTwoBtyeMotif
threeByteMotif:
mov 	eax, motifArr
  mov 	edx, dword [eax]
  shl 	edx, 8
  shr 	edx, 8

;loop through the bitArr and check every 3 bytes if equals 01000001h or 01000101h, incrementing by only 1
countPatternLoop: 						; for int i=0, i<30, i++
	cmp 	ebx, 30d
	je 		endPatternLoop
	mov 	eax, dword [ecx]
	shl 	eax, 8
	shr 	eax, 8
	cmp 	edx, eax 				
	je 		partOfPattern
	jmp 	skipPattern
partOfPattern:
	inc 	byte [motifCount]
skipPattern:
	inc 	byte ecx 					; move pointer over to next byte in bitArr
	inc 	ebx							; i++
	jmp 	countPatternLoop


countTwoBtyeMotif:
	;loop through the bitArr and check every 3 bytes if equals 01000001h or 01000101h, incrementing by only 1
countTwoPatternLoop: 						; for int i=0, i<31, i++
	cmp 	ebx, 31d
	je 		endPatternLoop
	cmp 	dx, word [ecx]			; must compare to reverse since Little Endian	
	je 		partOfPatternTwo
	jmp 	skipPatternTwo
partOfPatternTwo:
	inc 	byte [motifCount]
skipPatternTwo:
	inc 	byte ecx 					; move pointer over to next byte in bitArr
	inc 	ebx							; i++
	jmp 	countTwoPatternLoop



countOneByteMotif:
	;loop through the bitArr and check every 3 bytes if equals 01000001h or 01000101h, incrementing by only 1
countOnePatternLoop: 						; for int i=0, i<32, i++
	cmp 	ebx, 32d
	je 		endPatternLoop
	cmp 	dl, byte [ecx] 				
	je 		partOfPatternOne
	jmp 	skipPatternOne
partOfPatternOne:
	inc 	byte [motifCount]
skipPatternOne:
	inc 	byte ecx 					; move pointer over to next byte in bitArr
	inc 	ebx							; i++
	jmp 	countOnePatternLoop


countFourByteMotif:
;loop through the bitArr and check every 4 bytes if equals 01000001h or 01000101h, incrementing by only 1
countFourPatternLoop: 						; for int i=0, i<29, i++
	cmp 	ebx, 29d
	je 		endPatternLoop
	cmp 	edx, dword [ecx]			; must compare to reverse since Little Endian	
	je 		partOfPatternFour
	jmp 	skipPatternFour
partOfPatternFour:
	inc 	byte [motifCount]
skipPatternFour:
	inc 	byte ecx 					; move pointer over to next byte in bitArr
	inc 	ebx							; i++
	jmp 	countFourPatternLoop



endPatternLoop:
	mov 	eax, numMotifs
	call 	print_string
	movzx 	eax, byte [motifCount]
	call 	print_int
	call 	print_nl

exitBlock:

popa						            ; cleanup
mov	eax, 0					            ; cleanup
leave						            ; cleanup
ret							            ; cleanup