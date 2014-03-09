; This program will repeatedly prompt the user to enter a signed 
;integer.  Th program stops immediately if the integer is strictly negative
;If positive, the program will print one of the following statements:	
;    "It's the ASCII code for a white space."
;    "It's the ASCII code for a digit."
;    "It's some non-extended ASCII code."
;    "It's some extended ASCII code."
;    "It's not an ASCII code." 

%include "asm_io.inc"

segment .data
	prompt		db	"Enter an integer: ", 0
	space		db	"It's the ASCII code for a white space.", 0
	digit		db	"It's the ASCII code for a digit.", 0
	nonextended	db	"It's some non-extended ASCII code.", 0
	extended	db	"It's some extended ASCII code.", 0
	nonascii	db	"It's not an ASCII code.", 0

segment .text
        global  asm_main
asm_main:
	enter	0,0			; setup
	pusha				; setup
     
      do:				; start do-while loop
	mov 	eax, prompt	    	; prompts user to input an integer
	call	print_string
	call	read_int	    	; read the integer user inputs (as signed int)
	cmp 	eax, 127d		; eax-127d, compares user int to 127d
	jle 	le127block		; eax<=127
	cmp	eax, 255		; eax>127, therefore compare eax-255d
	jle	g127block			; eax>127 & eax<=255
	mov	eax, nonascii		; eax>255, therefore not an ascii character
	call	print_string
	call	print_nl
	jmp	do			; start do-while loop over
      g127block:
	mov	eax, extended		; 127<eax<=255, these are the extended ASCII chars
	call	print_string
	call	print_nl
	jmp 	do			; start do-while loop over
      le127block:			; less than or equal to 127
	cmp	eax, 0d			; eax-0d, compares user int to 0d
	jl	exitblock		; eax<0, user wants to exit while loop
	cmp	eax, 32d		; eax-32d, compares user int to 32d
	je	e32block		; eax = 32d
	mov	eax, nonextended	; 0<=eax<-127. these are the nonextended ASCII chars
	call	print_string
	call	print_nl
	jmp	do			; start do-while loop over
      e32block:			
	mov	eax, space		; eax=32d, which is white space ascii char
	call	print_string
	call 	print_nl
	jmp	do			; start do-while loop over
      exitblock:			; exit do-while loop
	
	popa				; cleanup
	mov	eax, 0			; cleanup
	leave				; cleanup
	ret				; cleanup
