; This program will repeatedly prompt the user to enter a signed 
; integer.  The program stops immediately if the integer is strictly negative.
; It will then print out how many of the integers were divisible
; by 1, 2, 3, 4, ..... 50 as a histogram.
; We assume that the user enters valid numbers 

%include "asm_io.inc"

segment .data
	prompt		db	"Enter an integer: ", 0
	divByStr1	db	"The number of integers divisible by ", 0
	divByStr2	db 	" is ", 0
	hashtag 	db 	"#", 0
	dash		db 	"-", 0
	space 		db 	" ", 0
	counter		db 	0d                              ; represents the current index in divisorArr
	forcealign	db 	0d, 0d, 0d 										; ensure that the array below is aligned properly
	divisorArr times 50 dd 0                      ; sets up an array of 50 4 byte 0s
	cpDivisorArr times 50 dd 0                    ; sets up an array of 50 4 byte 0s 

segment .bss
	userInt		resd	1                             ; reserve a 4 byte for the users input int

segment .text
        global  asm_main
asm_main:
	enter	0,0					          ; setup
	pusha						            ; setup

while:						            ; start while loop
	mov 	eax, prompt	    	    ; prompts user to input an integer
	call	print_string
	call	read_int	    	      ; read the integer user inputs (as signed int)
	mov 	[userInt], eax 		    ; save user input
	cmp		eax, 0d				        ; eax-0d, compares uer int to 0d
	jl		whileEndBlock		      ; eax<0, user wants to exit loop

for:							            ; for int counter=0, counter<50, i++
  cmp 	byte [counter], 50d   ; compare counter to 50
  jge		forEndBlock			      ; counter >= 50 therefore get out of for loop
 	cmp 	byte [userInt], 0d    ; user entered a 0, so skip it, no number can divide by 0
 	je 		forEndBlock  
  mov 	eax, [userInt]		    ; reset user input into eax (got overwritten by division quotient)
	mov 	edx, 0d 			        ; clear edx
	movsx 	ecx,  byte [counter]; move divisor into ecx (dividend is in edx:eax)
	inc 	ecx					          ; the divisor is actually 1 greater than the index
	idiv	ecx					          ; edx:eax/ecx, eax=quotient, edx=remainder
	cmp		edx, 0d				        ; edx-0d, compare remainder from edx:eax/2 to 0d
	jne		notDivisible		      ; edx (remainder) != 0, therefore skip incrementing variable
	imul 	ecx, [counter], 4d	  ; calculate offset from beginning of array
	mov 	ebx, divisorArr       ; create a pointer to the beginning of the divisorArr
	add 	ebx, ecx              ; move ptr to offset
	inc 	dword [ebx]           ; increment the content at that specific offset

notDivisible:				          ; not divisible so skip incrementing variable
  inc 	byte [counter]		    ; increment counter to the next divisor
  jmp		for					          ; start for loop over

forEndBlock:
	mov 	byte [counter], 0d 	  ; reset counter back to 0
	jmp		while 				        ; start while loop over

whileEndBlock:				        ; exit the while loop

	mov 	byte[counter], 0d 	  ; reset counter back to 0

makeCopy:                      ; make a copy of divisorArr into cpDivisorArr
	mov 	ebx, divisorArr        ; create a pointer to the beginning of the divisorArr
	mov 	ecx, cpDivisorArr      ; create a pointer to the beginning of the cpDivisorArr
for2:							             ; for int counter = 0, counter<50, i++
	cmp 	byte [counter], 50d    ; compare counter to 50d
	jge 	printHistogram         ; counter >= 50, get out of for loop
  mov 	edx, dword [ebx]       ; make of copy of the dword into cpDivisorArr
  mov 	[ecx], edx
  add 	ebx, 4d                ; move the pointer over to the next number
  add 	ecx, 4d                ; move the pointer over to the next number
  inc 	byte [counter]       
  jmp 	for2                   ; start for loop over

printHistogram:				         ; prints a histogram of what numbers, btw 1-50, the integers entered by the user are divisible by
	mov 	ebx, cpDivisorArr      ; create a pointer to the copy array
	mov 	ebx, [ebx]			       ; get the max height from the divisible by 1 index, will represent the currHeight
	call 	print_nl

while2:						             ; while currHeight (ebx) > 0
	cmp 	ebx, 0                 ; compare currentHeight to 0   
	jle		while2EndBlock         ; currentHeight <= 0 therefore get out of while loop
	mov 	byte [counter], 0d 	   ; reset counter back to 0

for3:							             ; for int counter=0, counter<50, 
	cmp 	byte [counter], 50d    ; compare counter to 50d
	jge		for3EndBlock		       ; counter >= 50 therefore get out of for loop
	imul 	ecx, [counter], 4d	   ; calculate offset from beginning of array
  mov 	edx, cpDivisorArr      ; create pointer to copy array
  add 	edx, ecx               ; move pointer to offset 
  cmp 	ebx, dword [edx]	     
  jne		then                   ; currHeight != divisorArr[counter], therefore don't print hashtag
  mov 	eax, hashtag           ; currHeight == divisorArr[counter], therefore print hashtag
	call 	print_string
	dec 	dword [edx]            ; decrement integer at this location so that it will print hashtag on next for loop
  jmp 	next                   ; skip printing a space since printed a hashtag instead
then:                          ; print a space
	mov 	eax, space
  call 	print_string
next: 
	inc 	byte [counter]         ; increment counter
	jmp 	for3                   ; start for loop over

for3EndBlock:
	dec 	ebx                    ; decrement currHeight 
	call 	print_nl               ; start a new line
	jmp 	while2                 ; start while loop over

while2EndBlock:                ; histogram finished printing 
  mov 	byte[counter], 0d 	  ; reset counter back to 0

for4:							            ; for int counter = 0, counter<50, i++
	cmp 	byte [counter], 50d   ; compare counter to 50
	jge		endBlock			        ; counter >= 50 therefore get out of for loop
  mov		eax, dash             ; print a line of dashes
  call	print_string
  inc 	byte [counter]
  jmp		for4                  ; start for loop over

endBlock:
	call print_nl

popa						              ; cleanup
mov	eax, 0					          ; cleanup
leave						              ; cleanup
ret							              ; cleanup
