DATASEG SEGMENT
    MSG1 DB "Hello World$"
	MSG2 DB "a"
DATASEG ENDS



CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR

	MOV AX,DATASEG
	MOV DS,AX;确保后续可以访问MSG
	
	MOV CX,26;循环26次
    MOV AH,2;功能代码为2，设定单个字符输出
	;MOV DX,OFFSET MSG

L1:	
    MOV AL,[MSG2]
    MOV DL,AL;功能代码为2时，打印会调用DL
    INC AL
    MOV [MSG2],AL
    INT 21H
    DEC CX; 每轮减少一次CX
    CMP CX,13;循环到13次时跳转换行
    JZ  L2
    CMP CX,0
    JNZ L1;比较CX和0，不等于则继续
    JZ  L3;等于则直接结束
L2:
    ; 换行
    MOV DL, 0Dh   ; Carriage Return
    INT 21H
    MOV DL, 0Ah   ; Line Feed
    INT 21H
    JMP L1

;以下表示终止
L3:
	MOV AX,4C00H
	INT 21H
	
MAIN ENDP
CODESEG ENDS
	END MAIN