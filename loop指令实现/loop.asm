
DATASEG SEGMENT
    MSG1 DB "Hello World$"
	MSG2 DB "a"
DATASEG ENDS



CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR
    ;AX16位，AL为低8位，一般用于输入输出内容;AH为高8位,一般在一些特定的中断或功能调用中用于传递参数。
	MOV AX,DATASEG
	MOV DS,AX;确保后续可以访问MSG
	
	MOV CX,2;循环2次行
    MOV AH,2;功能代码为2，设定单个字符输出
	

L1:
    MOV BX,CX;由BX暂时保管
    MOV CX,13


L2:
    MOV AL,[MSG2]
    MOV DL,AL;功能代码为2时，打印会调用DL
    INC AL
    MOV [MSG2],AL
    INT 21H
    LOOP L2
    
    ; 换行
    MOV DL, 0Dh   ; Carriage Return
    INT 21H
    MOV DL, 0Ah   ; Line Feed
    INT 21H
    ;新一轮大循环
    MOV CX,BX
    LOOP L1
;以下表示终止
	MOV AX,4C00H
	INT 21H
	
MAIN ENDP
CODESEG ENDS
	END MAIN