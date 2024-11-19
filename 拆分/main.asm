EXTRN CLEAN: FAR,CONVERT: FAR,CONVERT_ZERO: FAR,CONVERT_NOT_ZERO: FAR
STKSEG SEGMENT STACK
           DW 2000 DUP(0)
STKSEG ENDS

DATASEG SEGMENT PUBLIC
    PUBLIC years, revenue, employees, BUFFER, TEMP ; 将这些符号导出
    years       db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
                db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
                db '1993','1994','1995'

    ; 表示 1 年公司总收入
    revenue     dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
                dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    ; 表示 1 年雇员人数
    employees   dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
                dw 11542,14430,15257,17800

    BUFFER DB 8 DUP(0)   ; 占用8字节
    TEMP DB 0        ; 定义一个 8 位的内存变量，用于存放 DH                                                          ; 缓冲区，用于存储4字节年份并加上终止符 '$'
DATASEG ENDS
tableSeg SEGMENT
    PUBLIC table ; 导出标号 `table`
    table db 21 dup('year summ ne av ') ; 定义标号 `table`，表示数据的起始位置
tableSeg ENDS


CODESEG SEGMENT
               ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC
    MOV AX,0
    MOV CX,0
    MOV BX,0
    MOV DX,0
    ; 设置段寄存器
               MOV    AX, DATASEG
               MOV    DS, AX
               MOV    ES, AX
               MOV    SS, AX
    
    ;导入年份
               MOV    DI, OFFSET DATASEG        ; Pointer to table
               MOV    CH, 21
               MOV    BX,OFFSET years
    LOAD1:     
               MOV    CL,2
    L1:        
               MOV    AX,[BX]
               MOV    [DI],AX
               ADD    BX,2
               ADD    DI,2
               DEC    CL
               test   CL,CL
               jnz    L1
               ADD    DI,12
               DEC    CH
               test   CH,CH
               jnz    LOAD1
               
    ;导入总收入
               MOV    DI, OFFSET DATASEG
               ADD    DI,5
               MOV    CH, 21
               MOV    BX,OFFSET revenue
    LOAD2:     
               MOV    CL,2
    L2:        
               MOV    AX,[BX]
               MOV    [DI],AX
               ADD    BX,2
               ADD    DI,2
               DEC    CL
               test   CL,CL
               jnz    L2
               ADD    DI,12
               DEC    CH
               test   CH,CH
               jnz    LOAD2
               
    ;导入员工数
               MOV    DI, OFFSET DATASEG
               ADD    DI,10
               MOV    CH, 21
               MOV    BX,OFFSET employees
    LOAD3:     
               MOV    AX,[BX]
               MOV    [DI],AX
               ADD    BX,2

               ADD    DI, 16
               DEC    CH
               test   CH,CH
               jnz    LOAD3

    ; 计算人均收入
               MOV    DI, OFFSET DATASEG
               ADD    DI,13
               MOV    CH,21
               MOV    BP,OFFSET revenue
               MOV    BX,OFFSET employees
    LOAD4:     
               MOV    AX,[BP]
               MOV    DX,[BP+2]
               DIV    WORD PTR [BX]

               MOV    [DI],AX
               ADD    BP,4
               ADD    BX,2
               ADD    DI,16
               DEC    CH
               cmp    CH,0
               JNE    LOAD4
    ;开始打印
    MOV AH,00H ; 清屏
    MOV AL,03H
    INT 10H
    MOV BH, 0
    MOV BL, 4

    ;打印年份
    MOV BP,OFFSET DATASEG
    MOV DH,0
    print_year:
        MOV DL,4
        MOV CX,4
        MOV AL, 1
        MOV AH, 13H
        INT 10H

        ADD BP,16
        INC DH
        CMP DH,21
        JL  print_year

    ;打印预算
    MOV DI,OFFSET DATASEG
    ADD DI,5
    MOV DH,0
    print_rev:
        MOV TEMP,DH
        MOV AX, [DI]
        MOV DX, [DI+2]
        MOV SI,100
        DIV SI; 第一次除法，将DX:AX / 100，商存入AX，余数存入DX
        CMP DX, 0
        JNZ NOT_ZERO     
        ZERO:
            CALL CONVERT_ZERO
            JMP SUBEND
         NOT_ZERO:
            CALL CONVERT_NOT_ZERO
            
    SUBEND:
        LEA BP,BUFFER
        MOV DL, 20
        MOV DH,TEMP
        MOV CX,7
        MOV AL, 1
        MOV AH, 13H
        MOV BH, 0
        MOV BL, 4
        INT 10H

        CALL CLEAN
        ADD DI,16
        INC DH
        CMP DH,21
        JL  print_rev

    ;打印员工数
    MOV DI,OFFSET DATASEG
    ADD DI,10
    MOV DH,0
    print_employee:
        MOV TEMP,DH
        MOV AX, [DI]
        CALL CONVERT

        LEA BP,BUFFER
        MOV DL, 50
        MOV DH,TEMP
        MOV CX,5
        MOV AL, 1
        MOV AH, 13H
        INT 10H

        CALL CLEAN
        ADD DI,16
        INC DH
        CMP DH,21
        JL  print_employee


     ;打印平均收入
    MOV DI,OFFSET DATASEG
    ADD DI,13
    MOV DH,0
    print_avg:
        MOV TEMP,DH
        MOV AX, [DI]
        CALL CONVERT

        LEA BP,BUFFER
        MOV DL, 70
        MOV DH,TEMP
        MOV CX,3
        MOV AL, 1
        MOV AH, 13H
        INT 10H

        CALL CLEAN
        ADD DI,16
        INC DH
        CMP DH,21
        JL  print_avg

    MOV    AH, 4CH                   ; Exit program
    INT    21H
MAIN ENDP
CODESEG ENDS
END MAIN