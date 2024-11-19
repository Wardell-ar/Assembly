PUBLIC CONVERT_ZERO
DATASEG SEGMENT PUBLIC
    EXTRN BUFFER:BYTE
DATASEG ENDS

CODESEG SEGMENT 
        ASSUME CS:CODESEG, DS:DATASEG
CONVERT_ZERO PROC FAR
    LEA BP,BUFFER
    MOV SI,10
    MOV CX,0
    convert_loop3:
        ADD CX,2
        MOV DX,0
        PUSH DX
        PUSH DX
    CONVERT_LOOP4:        
        XOR DX, DX
        DIV SI
        PUSH DX
        INC CX
        test ax, ax
        jnz convert_loop4
    pop_loop2:
        POP DX
        ADD DL, '0'
        mov [BP], dl       ; 保存字符
        INC BP
        LOOP pop_loop2 
    RET       
CONVERT_ZERO ENDP
CODESEG ENDS
END 