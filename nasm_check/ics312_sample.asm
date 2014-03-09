;A simple program simply adds to 32-bit integers together
; and stores the results back in memory

%include "asm_io.inc"

segment .data
	msg1	db	"Enter a number: ", 0
	msg2	db	"The sum of ", 0
	msg3	db	" and ", 0
	msg4	db	" is: ", 0

segment .bss
	integer1		resd     1	; first integer	
	integer2		resd     1	; second integer
	result		resd     1	; result

segment .text
        global  asm_main
asm_main:
	enter	0,0			; setup
	pusha				; setup
	mov 	bx, 0E5h
	mov		cx, 003h
	add     bl, cl
	movsx	eax, bl
	call 	print_int
	call	print_nl
	mov 	eax, 0FFFFFFE8h
	call 	print_int
	call	print_nl
	popa				; cleanup
	mov	eax, 0			; cleanup
	leave				; cleanup
	ret				; cleanup

