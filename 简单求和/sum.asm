STKSEG SEGMENT STACK
    DW 100 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
   result db 5 dup(0) ; 存储结果字符串
DATASEG ENDS



CODESEG SEGMENT
    ASSUME CS:CODESEG,DS:DATASEG
MAIN PROC FAR
    ;AX16位
    ;AL为低8位，一般用于输入输出内容
    ;AH为高8位,一般在一些特定的中断或功能调用中用于传递参数。
	MOV AX,DATASEG
	MOV DS,AX;确保后续可以访问result
	
	MOV CX,100;循环100次
    mov bx, 0 ; bx用作求和
    MOV AH,9;设定字符串输出
	
sum_loop:
    add bx, cx         ; 将当前计数加到bx
    loop sum_loop      ; 循环直到cx为0

 ; 将结果转换为字符串
    mov ax, bx         ; 将求和结果放入ax(便于下面的DIV操作）
    call WriteNumber    ; 调用输出函数

    ; 输出结果
    mov ah, 9
    lea dx, result;lea（Load Effective Address）指令用于将地址加载到寄存器中
    int 21h


    mov ax, 4C00h      ; 结束程序
    int 21h

WriteNumber proc
    ; 将ax中数字转换为字符串
    mov cx, 0          ; 位数计数器清零

convert_loop:
    xor dx, dx         ; 清空dx
    MOV bx,10
    div bx             ; 除以10，商在ax，余数在dx
    push dx            ; 保存余数
    inc cx             ; 增加位数计数（每push一个进栈，就增加一次CX，pop_loop循环即可自动结束）
    test ax, ax
    jnz convert_loop    ; 如果ax不为0，继续循环

    ; 将余数转回到result
    lea di, result + 4 ; 从字符串末尾开始
    mov byte ptr [di], "$" ; 字符串结束符
    lea di, result

pop_loop:
    pop dx
    add dl, '0'         ; 转换为字符(dl是dx的低8位，也就是pop出来后的个位）
    mov [di], dl       ; 保存字符
    inc di
    loop pop_loop

    ret;ret 指令在汇编语言中用于从子程序返回 类似于函数中的return
WriteNumber endp

MAIN ENDP
CODESEG ENDS
END MAIN