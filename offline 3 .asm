.model small
.stack 100h
.code  

.data
num dw 0
base dw 2
res dw 0
cnt db 0
nl db 0ah,0dh,'$'



main proc
    mov ax,@data
    mov ds,ax 
    call indec
    mov num,ax
    mov ah,9
    lea dx,nl
    int 21h
    mov ax,num
    push ax 
    call base_convert
    mov  res,ax
    call outdec
    mov ah,9
    lea dx,nl
    int 21h
    mov ax,res
    call count_nonzero
    mov cnt,cl
    mov ah,0
    mov al,cnt
    call outdec
    mov ah,4ch
    int 21h
    main endp

base_convert proc
    cmp base,10
    jne next
    ret
    next:
    push bp
    mov bp,sp
    cmp [bp+4],0
    jne cal
    mov ax,0
    jmp return 
    cal:
    mov ax,[bp+4]
    mov dx,0
    mov bx,base
    div bx
    push dx
    push ax
    call base_convert
    mov bx,10
    mul bx
    add ax,[bp-2]
    return:
    pop bp
    ret 4
    base_convert endp


count_nonzero proc 
    mov cl,0
    start:
    cmp ax,0
    je retc
    mov dx,0
    mov bx,10
    div bx
    cmp dx,0
    jg inc_cnt
    jmp start
    inc_cnt:
    inc cl
    jmp start
    retc:
    ret
    count_nonzero endp





OUTDEC PROC
;INPUT AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
OR AX,AX
JGE @END_IF1
PUSH AX
MOV DL,'-'
MOV AH,2
INT 21H
POP AX
NEG AX

@END_IF1:
XOR CX,CX
MOV BX,10D

@REPEAT1:
XOR DX,DX
DIV BX
PUSH DX
INC CX
OR AX,AX
JNE @REPEAT1

MOV AH,2

@PRINT_LOOP:

POP DX
OR DL,30H
INT 21H
LOOP @PRINT_LOOP

POP DX
POP CX
POP BX
POP AX
RET
OUTDEC ENDP

INDEC PROC
;AX HOLDS THE INPUT


PUSH BX
PUSH CX
PUSH DX

@BEGIN:
MOV AH,2
MOV DL,'?'
INT 21H

XOR BX,BX

XOR CX,CX

MOV AH,1
INT 21H

CMP AL,'-'
JE @MINUS
CMP AL,'+'
JE @PLUS
JMP @REPEAT2

@MINUS:
MOV CX,1

@PLUS:
INT 21H

@REPEAT2:
CMP AL,'0'
JNGE @NOT_DIGIT
CMP AL,'9'
JNLE @NOT_DIGIT

AND AX,000FH
PUSH AX

MOV AX,10
MUL BX
POP BX
ADD BX,AX

MOV AH,1
INT 21H
CMP AL,0DH
JNE @REPEAT2

MOV AX,BX

OR CX,CX
JE @EXIT

NEG AX

@EXIT:
POP DX
POP CX
POP BX
RET

@NOT_DIGIT:
MOV AH,2
MOV DL,0DH
INT 21H
MOV DL,0AH
INT 21H
JMP @BEGIN
INDEC ENDP







end main