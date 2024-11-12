DATASEG SEGMENT
   years db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
         db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
         db '1993','1994','1995'

    ; 表示 1 年公司总收入
    revenue dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
            dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    ; 表示 1 年雇员人数
    employees dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
              dw 11542,14430,15257,17800
    year_buffer db 5 dup('$')   ; 缓冲区，用于存储4字节年份并加上终止符 '$'
DATASEG ENDS

table SEGMENT
    db 1 dup('year summ ne av ')
table ENDS


CODESEG SEGMENT
     ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC
    ; 设置段寄存器
    MOV AX, DATASEG
    MOV DS, AX
    MOV SS, AX
    MOV AX, table
    MOV ES, AX

    
;导入年份
    MOV DI, OFFSET table    ; Pointer to table
    MOV CH, 1
    MOV BX,OFFSET years
LOAD1:
    MOV CL,4
    L1:
        MOV AX,[BX]
        MOV DI,AX
        INC BX
        INC DI
        DEC CL
        test CL,CL
        jnz L1    
    ADD DI,12
    DEC CH
    test CH,CH
    jnz LOAD1    
;导入总收入
    MOV DI, OFFSET table
    ADD DI,5
    MOV CH, 1
    MOV BX,OFFSET revenue
LOAD2:
    MOV CL,2
    L2:
        MOV AX,[BX]
        MOV DI,AX
        ADD BX,2
        ADD DI, 2
        DEC CL
        test CL,CL
        jnz L2    
    ADD DI,12
    DEC CH
    test CH,CH
    jnz LOAD2  
;导入员工数
    MOV DI, OFFSET table
    ADD DI,10
    MOV CH, 1
    MOV BX,OFFSET employees
LOAD3:
    MOV AX,[BX]
    MOV DI,AX
    ADD BX,2

    ADD DI, 16
    DEC CH
    test CH,CH
    jnz LOAD3  

; 计算人均收入
    MOV DI, OFFSET table
    ADD DI,13
    MOV CH, 1
    MOV BP,OFFSET revenue
    MOV BX,OFFSET employees
LOAD4:
    MOV AX,[BP]
    DIV WORD PTR [BX]

    MOV DI,AX
    ADD BP,16
    ADD BX,16
    ADD DI,16
    DEC CH
    test CH,CH
    jnz LOAD4 

MOV BX, 1              ; 设置循环计数，21行
MOV SI, OFFSET table    ; 设置SI为表的起始位置

print_year:
    MOV DI, OFFSET year_buffer
    MOV CX, 4               ; 复制4字节
    REP MOVSB               ; 将 year 的4字节复制到 year_buffer
    MOV DX, OFFSET year_buffer
    MOV AH, 09h
    INT 21h                 ; 调用DOS中断打印年份

    ; 换行
    MOV AH, 02h
    MOV DL, 0Dh             ; 回车
    INT 21h
    MOV DL, 0Ah             ; 换行
    INT 21h

    ; 移动到下一行
    ADD SI, 12              ; 每行 12 字节
    dec BX
    JNZ print_year

    MOV AH, 4CH             ; Exit program
    INT 21H
MAIN ENDP



CODESEG ENDS
END MAIN