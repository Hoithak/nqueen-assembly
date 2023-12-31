;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||| PLACED_QUEEN_IN_POSITION ||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
PLACED_QUEEN PROC
	PUSH	BP
	MOV	BP,SP
	INC	COUNT_NODE
MOVE_COL_PLACED_QUEEN:
	MOV	CX,SIZE_BD
	CMP	WORD PTR[BP+4],CX
	JGE	END_PLACED_QUEEN
	CMP	WORD PTR[BP+12],1
	JE	END_PLACED_QUEEN

	CALL	CHECK_POSITION
	CMP	WORD PTR [BP+8],0
	JNE	CHECK_FLAG_POSITION
	MOV	WORD PTR [BP+12],1

	MOV	SI,WORD PTR [BP+4]
	MOV	AX,WORD PTR [BP+6]
	MOV	DX,10
	MUL	DX
	MOV	BX,AX
	MOV	ARRAY_BD[SI+BX],1
	CALL	PLACED_QUEEN_BMP

	MOV	CX,SIZE_BD
	DEC	CX
	CMP	CX,WORD PTR [BP+6]
	JE	INC_COL_PLACED_QUEEN
	XOR	DX,DX
	PUSH	DX
	PUSH	DX
	PUSH	DX
	MOV	DX,WORD	PTR [BP+6]
	INC	DX
	PUSH	DX
	XOR	DX,DX
	PUSH	DX

	CALL	PLACED_QUEEN
	MOV	CX,Q_PLACED
	MOV	WORD PTR [BP+10],CX
	CMP	WORD PTR [BP+10],0
	JNE	INC_COL_PLACED_QUEEN
	MOV	WORD PTR [BP+12],0

	MOV	SI,WORD PTR [BP+4]
	MOV	AX,WORD PTR [BP+6]
	MOV	DX,10
	MUL	DX
	MOV	BX,AX
	MOV	ARRAY_BD[SI+BX],0
	CALL	DELECT_QUEEN_BMP	;FUNCTION STORE QUEEN
CHECKHOME_PLACED:
	MOV	DX,SIZE_BD
	DEC	DX
	JMP	INC_COL_PLACED_QUEEN

CHECK_FLAG_POSITION:
	CMP	WORD PTR [BP+8],1
	JNE	INC_COL_PLACED_QUEEN
	CALL	PLACED_QUEEN_BMP
	CALL	DELECT_QUEEN_BMP
	JMP	CHECKHOME_PLACED
	
INC_COL_PLACED_QUEEN:
	MOV	DX,WORD PTR [BP+4]
	INC	DX
	MOV	WORD PTR [BP+4],DX
	JMP	MOVE_COL_PLACED_QUEEN

END_PLACED_QUEEN:	
	MOV	CX,WORD PTR [BP+12]
	MOV	Q_PLACED,CX
	POP	BP
	RET	10
PLACED_QUEEN ENDP
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||| PLACED_QUEEN ||||||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
PLACED_QUEEN_BMP PROC
	PUSH	AX
	PUSH	BOARD_X
	PUSH	BOARD_Y
	PUSH	SI
	PUSH	BP
	MOV	BP,SP

	MOV	AX,15
	MUL	WORD PTR[BP+16]
	ADD	AX,3
	ADD	AX,BOARD_X
	MOV	BMP_X,AX
	MOV	AX,15
	MUL	WORD PTR[BP+18]
	ADD	AX,2
	ADD	AX,BOARD_Y
	MOV	BMP_Y,AX
	LEA	SI,QUEEN
	CALL	LOADBMP
	
	DELAY	1000	
	POP	BP
	POP	SI
	POP	BOARD_Y
	POP	BOARD_X
	POP	AX
	RET	
PLACED_QUEEN_BMP ENDP

;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||||||||| DELETE_QUEEN ||||||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
DELECT_QUEEN_BMP PROC
	PUSH	AX
	PUSH	BOARD_X
	PUSH	BOARD_Y
	PUSH	SI
	PUSH	BP
	MOV	BP,SP

	MOV	AX,15
	MUL	WORD PTR[BP+16]
	ADD	AX,3
	ADD	AX,BOARD_X
	MOV	BMP_X,AX
	MOV	AX,15
	MUL	WORD PTR[BP+18]
	ADD	AX,2
	ADD	AX,BOARD_Y
	MOV	BMP_Y,AX
	LEA	SI,BLANK
	CALL	LOADBMP
		
	POP	BP
	POP	SI
	POP	BOARD_Y
	POP	BOARD_X
	POP	AX
	RET	
DELECT_QUEEN_BMP ENDP

;|||||||||||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||||||| CHECK_POSITION |||||||||||||||||||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||
CHECK_POSITION PROC
	PUSH	BP
	MOV	BP,SP
	XOR	AX,AX
	XOR	BX,BX
FOR11_CHECK_PO:
	CMP	AX,WORD PTR [BP+10]	;Check row
	JGE	END_CHECK_PO
	XOR	SI,SI
FOR21_CHECK_PO:
	CMP	SI,SIZE_BD		;Check col
	JGE	FOR12_CHECK_PO
	CMP	ARRAY_BD[SI+BX],1
	JNE	FOR22_CHECK_PO
	
	CMP	SI,WORD PTR [BP+8]
	JNE	DIAGONAL1_CHECK_PO
	MOV	WORD PTR[BP+12],1
	JMP	RET_CHECK_PO
DIAGONAL1_CHECK_PO:
	MOV	CX,WORD PTR [BP+8]
	MOV	DX,WORD PTR [BP+10]
	SUB	DX,AX
	CMP	DX,0
	JL	NEG_ROW_CHECK
DIAGONAL2_CHECK_PO:
	SUB	CX,SI
	JL	NEG_COL_CHECK
	JMP	DIAGONAL3_CHECK_PO
NEG_ROW_CHECK:
	NEG	DX
	JMP	DIAGONAL2_CHECK_PO
NEG_COL_CHECK:
	NEG	CX
DIAGONAL3_CHECK_PO:
	CMP	CX,DX
	JNE	FOR22_CHECK_PO
	MOV	WORD PTR[BP+12],1
	JMP	RET_CHECK_PO


FOR22_CHECK_PO:
	INC	SI
	JMP	FOR21_CHECK_PO
FOR12_CHECK_PO:
	INC	AX
	ADD	BX,10
	JMP	FOR11_CHECK_PO
END_CHECK_PO:
	MOV	WORD PTR[BP+12],0
RET_CHECK_PO:
	POP	BP
	RET	
CHECK_POSITION ENDP