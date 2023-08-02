;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||||| MENU_INSERT GAME |||||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
MENU_INSERT PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	MOV	BMP_X,0
	mov	BMP_Y,0
START_MENU_INSERT:
	LEA	SI,INSERT
	CALL	LOADBMP
	DELAY	1000
	MOV	AH,2		;MOV CURSOR
	XOR	BX,BX
	MOV	DH,15		;ROW
	MOV	DL,9		;COLUM
	INT	10H
	CALL	INDEC
	CMP	AX,4
	JNGE	ERROR_MENU_INSERT
	CMP	AX,10
	JNLE	ERROR_MENU_INSERT
	JMP	COMPLET_MENU_INSERT	
ERROR_MENU_INSERT:
	LEA	SI,INSERT_ERROR
	CALL	LOADBMP
	MOV	AH,2
	MOV	DL,7
	INT	21H
	DELAY	6000
	JMP	START_MENU_INSERT
COMPLET_MENU_INSERT:
	MOV	SIZE_BD,AX
	CALL	MAKE_ARR_BOARD
	CALL	SET_BOARD_BMP
	
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
MENU_INSERT ENDP

;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||| INITIAL ARRAY BOARD |||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
MAKE_ARR_BOARD	PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI

	MOV	AX,SIZE_BD
	DEC	AX
	MOV	SIZE_ARR,AX	
	XOR	BX,BX
	XOR	CX,CX
	MOV	DX,SIZE_BD
MAKE_ARR_BOARD_LP1:
	MOV	CX,SIZE_BD
	XOR	SI,SI
MAKE_ARR_BOARD_LP2:
	MOV	ARRAY_BD[SI+BX],0
	INC	SI
	LOOP	MAKE_ARR_BOARD_LP2
	ADD	BX,10	
	DEC	DX
	JNZ	MAKE_ARR_BOARD_LP1

	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
MAKE_ARR_BOARD	ENDP

;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||| SET CHESSBOARD BMP ||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
SET_BOARD_BMP	PROC

	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	
	MOV	CX,SIZE_BD
	XOR	BX,BX
	SUB	CL,4
	CMP	CL,0
	JE	SET_BOARD_STINIT
SET_BOARD_SEEK:
	ADD	BX,20
	LOOP	SET_BOARD_SEEK
SET_BOARD_STINIT:	
	XOR	SI,SI
	MOV	CX,20
SET_BOARD_INTNAME:
	MOV	AH,BOARD_BMP[BX]
	MOV	PIC_BOARD[SI],AH
	INC	SI
	INC	BX
	LOOP	SET_BOARD_INTNAME

	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SET_BOARD_BMP	ENDP

;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||||||| DISPLAY  BOARD  ||||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
SHOW_BROAD	PROC
	PUSH	SI
	PUSH	BMP_X
	PUSH	BMP_Y
	MOV	BMP_X,85
	MOV	BMP_Y,25
	LEA	SI,PIC_BOARD
	CALL	LOADBMP
	POP	BMP_Y
	POP	BMP_X
	POP	SI
	RET
SHOW_BROAD	ENDP

;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||| DISPLAY ALL ARRAY BOARD ELEMENT ||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
DISPLAY_ARRAY	PROC

	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI

	MOV	AH,0
	MOV	DX,10
	XOR	AX,AX
	XOR	BX,BX
DISPLAY_ARRAY_LP1:
	MOV	CX,10
	XOR	SI,SI
DISPLAY_ARRAY_LP2:
	MOV	AL,ARRAY_BD[SI+BX]
	CALL	OUTDEC
	SPACE
	INC	SI
	LOOP	DISPLAY_ARRAY_LP2
	NEW_LINE
	ADD	BX,10	
	DEC	DX
	JNZ	DISPLAY_ARRAY_LP1

	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
DISPLAY_ARRAY	ENDP
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||||| DISPLAY TEXT COLOR |||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
SHOW_TEXT_COLOR	PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AH,2		;MOV CURSOR
	XOR	BH,BH		;PAGE	
	MOV	DH,0		;ROW
	MOV	DL,0		;COLUM
	INT	10H

	MOV	AH,0
	MOV	CX,256
	MOV	DH,20
	MOV	COLOR,0		;SELECT COLOR
SHOW_TEXT_COLOR_LP1:	
	MOV	AL,8
	CALL	HUE_OUTDEC
	INC	COLOR
	DEC	DH
	JNZ	SHOW_TEXT_COLOR_LP2
	NEW_LINE
	MOV	DH,20
SHOW_TEXT_COLOR_LP2:
	LOOP	SHOW_TEXT_COLOR_LP1

	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SHOW_TEXT_COLOR	ENDP
;]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]