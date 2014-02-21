; This simple program simply prompts the user for a character, then an
; integer, and then prints out what character and integer the user entered.

%include "asm_io.inc"

segment .data
	msg1	db	"Enter a character: ", 0
	msg2	db	"Enter an integer: ", 0
	msg3	db	"The character entered was: ", 0
	msg4	db	"The integer entered was: ", 0
	singleQuote db	"'", 0

segment .bss
	character		resb     1	; first character
	integer			resd     1	; first integer

segment .text
        global  asm_main
asm_main:
	enter	0,0			; setup
	pusha				; setup
	mov 	eax, msg1	    	; note that this is a pointer!
	call	print_string
	call	read_char	    	; read the first character
	mov 	[character], eax   	; store it in memory
	mov	eax, msg2		; note that this is a pointer!
	call 	print_string
	call	read_int	    	; read the first integer
	mov 	[integer], eax   	; store it in memory
	mov	eax, msg3		; note that this is a pointer!
	call 	print_string
	mov	eax, singleQuote	; note that this is a pointer!
	call 	print_string
	mov	eax, [character]	; note that this is a pointer!
	call 	print_char		; prints the character saved from user
	mov	eax, singleQuote	; note that this is a pointer!
	call 	print_string
	call	print_nl
	mov	eax, msg4		; note that this is a pointer!
	call 	print_string
	mov	eax, [integer]		; note that this is a pointer!
	call 	print_int		; prints the integer saved from user
	call	print_nl
	popa				; cleanup
	mov	eax, 0			; cleanup
	leave				; cleanup
	ret				; cleanup
