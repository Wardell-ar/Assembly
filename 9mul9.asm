STKSEG SEGMENT STACK
    DW 100 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    str1 DB "The 9mul9 table:$"
    newLine DB 0DH, 0AH, "$"
    resultStr DB "?x?=?  $"
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

    ; 开始输出九九乘法表
    MOV CX, 9      ; 外层循环9次，表示乘法中的第一个数1~9
OUTER_LOOP:
        MOV DX, OFFSET newLine
        MOV AH, 09H
        INT 21H     ; 输出换行

        ;MOV BX, CX  ; BX保存外层循环变量
        MOV BX, 1   ; 内层循环从1开始
    INNER_LOOP:
        MOV AX, BX  ; 保存AX，代表乘法的左操作数
        MUL CX      ; DX = AX * BX (计算乘法结果)
        MOV DX, AX

        ; 更新resultStr中的乘法操作数和结果
        MOV AL, BL      ; 左乘数
        CALL CONVERT_TO_CHAR
        MOV resultStr+2, AL
        
        MOV AL, CL     ; 右乘数
        CALL CONVERT_TO_CHAR
        MOV resultStr, AL
        
        MOV AX,DX ;结果
    convert_loop:
        xor dx, dx         ; 清空dx
        MOV di,10
        div di             ; 除以10，商在ax，余数在dx
        push dx            ; 保存余数
        inc SI             ; 增加位数计数
        test ax, ax
        jnz convert_loop    ; 如果ax不为0，继续循环


    lea di, resultStr+4
    mov [di],32;di是双字节寄存器
    ;masm编译器默认将32作为一个双字节数据传入到di指代的地址里
    ;从而同时将结果的十位赋值为空格(32)，将个位赋值为0h
    

    pop_loop:
        pop dx
        add dl, '0'         ; 转换为字符(dl是dx的低8位，也就是pop出来后的个位）
        mov [di], dl       ; 保存字符
        inc di
        dec si
        test si,si
        jnz pop_loop

    ; 打印结果
    LEA DX, resultStr
    MOV AH, 09H
    INT 21H

    ; 继续内层循环
    INC BX         
    CMP BX,CX      ; 比较AX是否为10
    JB INNER_LOOP

    DEC CX              ; 减少外层循环计数器
    JNZ OUTER_LOOP      ; 如果CX不为0，则继续外层循环

    ; 结束程序
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; 将数字(0-9)转换为字符
CONVERT_TO_CHAR PROC
    ADD AL, 30H  ; 转换为ASCII码
    RET
CONVERT_TO_CHAR ENDP


CODESEG ENDS
END MAIN
