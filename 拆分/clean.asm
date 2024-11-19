PUBLIC CLEAN
DATASEG SEGMENT PUBLIC
    EXTRN BUFFER:BYTE
DATASEG ENDS

CODESEG SEGMENT
        ASSUME CS:CODESEG, DS:DATASEG
CLEAN PROC FAR
    MOV AX, DATASEG
    MOV ES, AX
    MOV DS, AX

    MOV CX, 8         ; 要清空的字节数
    MOV SI, OFFSET BUFFER     ; SI 指向 BUFFER
    MOV AL, 0         ; 准备清零值
    clear_loop:
        MOV [SI], AL  ; 将 AL 的值写入到 BUFFER
        INC SI        ; 移动到下一个字节
        LOOP clear_loop ; 循环 CX 次
    RET
CLEAN ENDP
CODESEG ENDS
END 