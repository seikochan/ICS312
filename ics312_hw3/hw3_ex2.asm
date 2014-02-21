; This simple program simply prompts the user to type a 5-character string. It then
; reads the first 5 characters of that string and prints 2 strings:
;	1. contains the 5 characters entered by the user but in reverse order
;	2. contains the 5 characters entered by the user but whose ASCII code has
;	   been decremented by 32.

%include "asm_io.inc"

segment .data
	msg1	db	"Enter a 5-character string : ", 0
	msg2	db	"String #1: ", 0
	msg3	db	"String #2: ", 0

segment .bss
	char1			resb     1	; first character
	char2			resb     1	; second character
	char3			resb     1	; third character
	char4			resb     1	; fourth character
	char5			resb     1	; fifth character


segment .text
        global  asm_main
asm_main:
	enter	0,0			; setup
	pusha				; setup
	mov 	eax, msg1	    	; note that this is a pointer!
	call	print_string
	call	read_char	    	; read the first character
	mov 	[char1], eax   		; store it in memory
	call	read_char	    	; read the second character
	mov 	[char2], eax   		; store it in memory
	call	read_char	    	; read the third character
	mov 	[char3], eax   		; store it in memory
	call	read_char	    	; read the fourth character
	mov 	[char4], eax   		; store it in memory
	call	read_char	    	; read the fifth character
	mov 	[char5], eax   		; store it in memory
	mov		eax, msg2			; note that this is a pointer!
	call 	print_string
	mov		eax, [char5]			; printing the chars in reverse order			
	call	print_char
	mov		eax, [char4]			
	call	print_char
	mov		eax, [char3]			
	call	print_char
	mov		eax, [char2]			
	call	print_char
	mov		eax, [char1]			
	call	print_char
	call	print_nl
	mov		eax, msg3			; note that this is a pointer!
	call 	print_string
	mov		eax, [char1]
	sub		eax, 32d			; eax = char1 - 32d
	call 	print_char
	mov		eax, [char2]
	sub		eax, 32d			; eax = char2 - 32d
	call 	print_char
	mov		eax, [char3]
	sub		eax, 32d			; eax = char3 - 32d
	call 	print_char
	mov		eax, [char4]
	sub		eax, 32d			; eax = char4 - 32d
	call 	print_char
	mov		eax, [char5]
	sub		eax, 32d			; eax = char5 - 32d
	call 	print_char
	call	print_nl
	popa				; cleanup
	mov	eax, 0			; cleanup
	leave				; cleanup
	ret				; cleanup
