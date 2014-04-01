; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is zero.
; For each entered integer, the program prints out the hex
; representation of the number.
; We assume that the user enters valid numbers 

%include "asm_io.inc"

segment .data
	prompt		db	"Enter an integer: ", 0
	hexRep	db	"Hex representation: ", 0
	hexNumbers  db 	"0123456789ABCDEF"
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
	mov 	eax, hexRep 				; print the string "Hex representation: "
	call 	print_string 

  	mov 	ecx, ebx						; make a copy of the user int
  	shr 	ecx, 16 						; get upper 2 bytes into cx

  	;;find hex conversion of first byte in ch
  	mov edx, 0d 							; clear edx
  	mov dl, ch  							; saving a copy of the byte to use for second nybble
  	shr dl, 4 							; shift first nybble into 4 leftmost bytes
  	mov dl, byte [hexNumbers+edx] 		; add offset of nybble to covert it to its hex value from the hexNumbers array
  	mov al, dl 							; print the first nybble
  	call print_char
  	mov eax, 0d 							; clear eax
  	mov al, ch 							; move over the copy of the byte into al
  	and al, 0Fh 							; mask out bits for second nybble (0000 1111b) zeros out the 4 high bits of the byte
  	mov al, byte [hexNumbers+eax] 		; add offset of nybble to convert it to its hex value from the hexNumbers array
  	call print_char 						; print the second nybble

  	;;find hex conversion of second byte in cl
  	mov edx, 0d 							; clear edx
  	mov dl, cl  							; saving a copy of the byte to use for second nybble
  	shr dl, 4 							; shift first nybble into 4 leftmost bytes
  	mov dl, byte [hexNumbers+edx]
  	mov al, dl
  	call print_char
    mov eax, 0d
  	mov al, cl
  	and al, 0Fh 							
  	mov al, byte [hexNumbers+eax]
  	call print_char

   ;;find hex convertion of third byte in bh
    mov edx, 0d
  	mov dl, bh  							
   	shr dl, 4
  	mov dl, byte [hexNumbers+edx]
  	mov al, dl
  	call print_char
    mov eax, 0d
  	mov al, bh
  	and al, 0Fh 							
  	mov al, byte [hexNumbers+eax]
  	call print_char

    ;;find hex convertion of fourth byte in bl
  	mov edx, 0d
  	mov dl, bl  							
 	shr dl, 4
  	mov dl, byte [hexNumbers+edx]
  	mov al, dl
  	call print_char
    mov eax, 0d
  	mov al, bl
  	and al, 0Fh 							
  	mov al, byte [hexNumbers+eax]
  	call print_char

	call print_nl
	jmp		while 				        

whileEndBlock:				        	; exit the while loop


popa						            ; cleanup
mov	eax, 0					            ; cleanup
leave						            ; cleanup
ret							            ; cleanup