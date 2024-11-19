PUBLIC CONVERT_NOT_ZERO
DATASEG SEGMENT PUBLIC
    EXTRN BUFFER:BYTE
DATASEG ENDS

CODESEG SEGMENT 
        ASSUME CS:CODESEG, DS:DATASEG
CONVERT_NOT_ZERO PROC FAR
            MOV BX, AX;保留高位
            LEA BP,BUFFER
            MOV AX,DX
            MOV SI,10
            MOV CX,0
            convert_loop1:
                XOR DX, DX
                DIV SI
                PUSH DX
                INC CX
                test ax, ax
                jnz convert_loop1
            CMP BX,0
            JZ  pop_loop1
            MOV AX,BX
            CONVERT_LOOP2:
                XOR DX, DX
                DIV SI
                PUSH DX
                INC CX
                test ax, ax
                jnz convert_loop2
            pop_loop1:
                POP DX
                ADD DL, '0'
                mov [BP], dl       ; 保存字符
                INC BP
                LOOP pop_loop1
        RET
CONVERT_NOT_ZERO ENDP
CODESEG ENDS
END 