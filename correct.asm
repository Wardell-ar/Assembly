STKSEG SEGMENT STACK
    DW 100 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    str1 DB "X Y$"
    STR2 DB "   ERROR$"
    newLine DB 0DH, 0AH, "$"
    checkTable db 7, 2, 3, 4, 5, 6, 7, 8, 9
              db 2, 4, 7, 8, 10, 12, 14, 16, 18
              db 3, 6, 9, 12, 15, 18, 21, 24, 27
              db 4, 8, 12, 16, 7, 24, 28, 32, 36
              db 5, 10, 15, 20, 25, 30, 35, 40, 45
              db 6, 12, 18, 24, 30, 7, 42, 48, 54
              db 7, 14, 21, 28, 35, 42, 49, 56, 63
              db 8, 16, 24, 32, 40, 48, 56, 7, 72
              db 9, 18, 27, 36, 45, 54, 63, 72, 81
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC
    ; 初始化寄存器
    MOV AX, DATASEG
    MOV DS, AX

    ; 打印标题
    LEA DX, str1
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET newLine
    MOV AH, 09H
    INT 21H     ; 输出换行
    ; 开始输出九九乘法表
    MOV CX, 0      ; 表示行
    LEA DI,checkTable
Outer_Loop:
    INC CX
    CMP CX,9
    JA  OVER
    MOV BX,0    ;表示列
    INNER_LOOP:
        INC BX
        MOV AX,BX
        MUL CX
        MOV DX,[DI]
        CMP AL,DL
        JE  NO_ERROR
        JNE ERROR
    

NO_ERROR:
    INC DI
    CMP BX,9 
    JE  OUTER_LOOP
    JB  INNER_LOOP

ERROR:
    
    MOV DL,CL
    ADD DL,30H
    MOV AH, 02H
    INT 21H

    MOV DL,32
    MOV AH, 02H
    INT 21H

    MOV DL, BL
    ADD DL,30H
    MOV AH, 02H
    INT 21H 

    MOV DX, OFFSET STR2
    MOV AH, 09H
    INT 21H     

    MOV DX, OFFSET newLine
    MOV AH, 09H
    INT 21H     ; 输出换行
    
    JMP NO_ERROR

OVER:
    MOV AH, 4CH
    INT 21H

MAIN ENDP

CODESEG ENDS
END MAIN
