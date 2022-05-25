.model small 
.386 
.stack 100h

.data 
enter_number_msg db "Enter any number --> ", "$"
enter_operator_msg db "Enter an operator +, - , * , or / --> ", "$"

remainder dd 0

by_10 dd 10
sp_counter_1 db 0
sp_counter_2 db 0

num1 dd 0
last_key dd 0

opr dd 0;
last_key_o dd 0

num2 dd 0
last_key_2 dd 0

.code
main proc
	mov ax, @data ; set up data segment
	mov ds, ax

NUMBER_ONE:    
	mov dx,offset enter_number_msg
	call display_message
	call enter_first_number

OPERATOR:
	mov dx,offset enter_operator_msg
	call display_message
	call enter_operator

NUMBER_TWO:
	mov dx,offset enter_number_msg
	call display_message
	call enter_second_number

CALCULATE:
    cmp opr, 43
    jz short ADDITION
    cmp opr, 45
    jz short SUBTRACTION
    cmp opr, 42
    jz short MULTIPLICATION
    cmp opr, 47
    jz short DIVISION

ADDITION:
	mov eax, num1
    add eax, num2
    jmp short RESULT
SUBTRACTION:
	mov eax, num1
    sub eax, num2
    jmp short RESULT
MULTIPLICATION:
	mov eax, num1
    mul num2
    jmp short RESULT
DIVISION:
	mov eax, num1
    div num2
	mov remainder, edx ; remainder is in the edx register
    jmp short RESULT

RESULT:
mov sp_counter_1, 0	

LP1:
	mov edx, 0
	div by_10
	push dx
    inc sp_counter_1
    cmp eax, 0
    jnz lp1

LP2:
    pop dx
    call display
    dec sp_counter_1
    jnz lp2

	cmp remainder, 0               ; if remainder
	jnz short PRINT_DECIMAL        ; go to display decimal
	jz short DONE                  ; else end program

PRINT_DECIMAL:
	mov dl, 46                     ; '.'
	mov ah, 6
	int 21h
	mov eax, remainder             ; move remainder to eax
	mul by_10                      ; multiply by 10
	div num2                       ; divide by num2 to get decimal

	mov sp_counter_2, 0	

LP1_DECIMAL:
	mov edx, 0
	div by_10
	push dx
    inc sp_counter_2
    cmp eax, 0
    jnz LP1_DECIMAL

LP2_DECIMAL:
    pop dx
    call display
    dec sp_counter_2
    jnz LP2_DECIMAL

DONE:
    mov ax, 4c00h 
    int 21h 

display proc
	add dl, 30h
	mov ah, 6
	int 21h
	ret
display endp

display_message proc
	mov ah, 9 ; to display to screen the string pointed by the DX register.
	int 21h
	ret
display_message endp

enter_first_number proc
	LP_key:
	mov eax, num1
	mul by_10 ; eax = (eax) * 10
	add eax, last_key
	mov num1, eax ; save it to the number to display
	mov ah, 1 ; enables a single key entry
	int 21h
	AND eax, 000000ffh
	cmp al, 13 ; compare the key entered to 13 i.e. ascii of CR
	jz short finkey ; if CR was pressed then exit the enter key routine
	sub al, 30h ; remove the ascii from the number entered to get a pure number.
	MOV LAST_KEY, EAX ; save the last digit entered
	jmp lp_key ; unconditional jump to the enter key routine in a loop
	finkey:	
	ret
enter_first_number endp

enter_operator proc
	LP_key_o:
	mov eax, opr
	mul by_10 ; eax = (eax) * 10
	add eax, last_key_o
	mov opr, eax ; save it to the number to display
	mov ah, 1 ; enables a single key entry
	int 21h
	AND eax, 000000ffh
	cmp al, 13 ; compare the key entered to 13 i.e. ascii of CR
	jz short finkey_o ; if CR was pressed then exit the enter key routine
	MOV LAST_KEY_o, EAX ; save the last digit entered
	jmp lp_key_o ; unconditional jump to the enter key routine in a loop
	finkey_o:	
	ret
enter_operator endp

enter_second_number proc
	LP_key_2:
	mov eax, num2
	mul by_10 ; eax = (eax) * 10
	add eax, last_key_2
	mov num2, eax ; save it to the number to display
	mov ah, 1 ; enables a single key entry
	int 21h
	AND eax, 000000ffh
	cmp al, 13 ; compare the key entered to 13 i.e. ascii of CR
	jz short finkey_2 ; if CR was pressed then exit the enter key routine
	sub al, 30h ; remove the ascii from the number entered to get a pure number.
	MOV last_key_2, EAX ; save the last digit entered
	jmp lp_key_2 ; unconditional jump to the enter key routine in a loop
	finkey_2:	
	ret
enter_second_number endp

main endp
end main
