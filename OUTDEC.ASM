    OUTDEC  PROC
    ;prints AX as a signed decimal integer
    ;input: AX
    ;output: none
            PUSH    AX              ;save registers
            PUSH    BX
            PUSH    CX
            PUSH    DX 
	    PUSH    SI
	    PUSH    DI
    ;if AX < 0
            OR      AX,AX           ;AX < 0?
            JGE     @END_IF1        ;no, > 0
    ;then
            PUSH    AX              ;save number
            MOV     DL,'-'          ;get '-'
            MOV     AH,2            ;print char fcn
            INT     21H             ;print '-'
            POP     AX              ;get AX back
            NEG     AX              ;AX = -AX               
    @END_IF1:
    ;get decimal digits
            XOR     CX,CX           ;CX counts digits                 
            MOV     BX,10D          ;BX has divisor
    @REPEAT1:
            XOR     DX,DX           ;prepare high part of dividend  
            DIV     BX              ;AX = quotient, DX = remainder
            PUSH    DX              ;save remainder on stack
            INC     CX              ;count = count + 1
    ;until
            OR      AX,AX           ;quotient = 0?
            JNE     @REPEAT1        ;no, keep going
    ;convert digits to characters and print
            MOV     AH,2            ;print char fcn
    ;for count times do
    @PRINT_LOOP:
            POP     DX              ;digit in DL
            OR      DL,30H          ;convert to character
            INT     21H             ;print digit
            LOOP    @PRINT_LOOP     ;loop until done
    ;end_for
	    POP     DI
	    POP     SI
            POP     DX              ;restore registers
            POP     CX
            POP     BX
            POP     AX
            RET
    OUTDEC  ENDP

HUE_OUTDEC PROC
;|||||||||||||||||||||||||||||||||||||||||||||
;|||||| bl contain color of char      ||||||||
;|||||| MOV	COLOR,46;SELECT COLOR ||||||||
;|||||| MOV	AX,SIZE_BD	      ||||||||
;|||||| CALL	HUE_OUTDEC	      ||||||||
;|||||||||||||||||||||||||||||||||||||||||||||
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	OR   AX,AX
	JGE  @HEND_IF1

	PUSH AX
	MOV  AL,'-'
	MOV  AH,0EH
	MOV  BL,COLOR   ; set color
	INT  10H
	POP  AX
	NEG  AX

@HEND_IF1:
	XOR  CX,CX
	MOV  BX,10D

@HREPEAT1:
	XOR  DX,DX
	DIV  BX
	PUSH DX
	INC  CX
	OR   AX,AX
	JNE  @HREPEAT1
	
	MOV  AH,0EH
	MOV BL,COLOR
@HPRINT_LOOP:
	POP  DX
	OR   DL,30H
	MOV AL,DL
	INT  10H
	LOOP @HPRINT_LOOP

	POP  DX
	POP  CX
	POP  BX
	POP  AX
	RET
HUE_OUTDEC ENDP
