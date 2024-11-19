PUBLIC CONVERT
DATASEG SEGMENT PUBLIC
    EXTRN BUFFER:BYTE
DATASEG ENDS

CODESEG SEGMENT
        ASSUME CS:CODESEG, DS:DATASEG
;负责把AX里的数转化后放到buffer里
CONVERT PROC FAR
        LEA BP,BUFFER
        MOV SI,10
        MOV CX,0
        convert_loop:
            XOR DX, DX
            DIV SI
            PUSH DX
            INC CX
            test ax, ax
            jnz convert_loop
        pop_loop:
            POP DX
            ADD DL, '0'
            mov [BP], dl       ; 保存字符
            INC BP
            LOOP pop_loop
    RET
CONVERT ENDP
CODESEG ENDS
END 