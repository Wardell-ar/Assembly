int main() {
00007FF7651B1860  push        rbp               ; 保存原来的基址指针（RBP）
00007FF7651B1862  push        rdi               ; 保存调用者的第一个参数寄存器（RDI）
00007FF7651B1863  sub         rsp,128h          ; 为局部变量分配128字节的栈空间
00007FF7651B186A  lea         rbp,[rsp+20h]     ; 设置新的基址指针，指向当前栈帧
00007FF7651B186F  lea         rcx,[__FF7866AF_字符输出@c (07FF7651C1008h)]  
                                                   ; 加载字符串输出格式的地址
00007FF7651B1876  call        __CheckForDebuggerJustMyCode (07FF7651B135Ch)  
                                                   ; 调用检查是否在调试器中的函数

    int sum = 0;
00007FF7651B187B  mov         dword ptr [sum],0 ; 初始化 sum 为 0

    for (int i = 1; i <= 100; i++) {
00007FF7651B1882  mov         dword ptr [rbp+24h],1  ; 初始化循环变量 i = 1
00007FF7651B1889  jmp         main+33h (07FF7651B1893h) ; 跳转到循环条件检查

00007FF7651B188B  mov         eax,dword ptr [rbp+24h] ; 将 i 的值加载到 EAX
00007FF7651B188E  inc         eax                     ; i = i + 1
00007FF7651B1890  mov         dword ptr [rbp+24h],eax ; 更新 i 的值

00007FF7651B1893  cmp         dword ptr [rbp+24h],64h ; 比较 i 和 100（64h 是 100 的十六进制表示）
00007FF7651B1897  jg          main+48h (07FF7651B18A8h) ; 如果 i > 100，跳出循环

        sum += i;
00007FF7651B1899  mov         eax,dword ptr [rbp+24h] ; 将 i 的值加载到 EAX
00007FF7651B189C  mov         ecx,dword ptr [sum]     ; 将 sum 的值加载到 ECX
00007FF7651B189F  add         ecx,eax                  ; sum = sum + i
00007FF7651B18A1  mov         eax,ecx                  ; 将新计算的 sum 放回 EAX
00007FF7651B18A3  mov         dword ptr [sum],eax      ; 更新 sum 的值

    }
00007FF7651B18A6  jmp         main+2Bh (07FF7651B188Bh) ; 跳回循环的开始处

    printf("%d", sum);
00007FF7651B18A8  mov         edx,dword ptr [sum]      ; 将 sum 的值加载到 EDX（参数）
00007FF7651B18AB  lea         rcx,[string "%d" (07FF7651B9C24h)]  
                                                   ; 加载格式字符串的地址
00007FF7651B18B2  call        printf (07FF7651B118Bh)   ; 调用 printf 函数输出 sum

    return 0;
00007FF7651B18B7  xor         eax,eax                  ; 返回 0（使用 EAX 寄存器）
}
00007FF7651B18B9  lea         rsp,[rbp+108h]          ; 清理栈空间，恢复栈指针
00007FF7651B18C0  pop         rdi                       ; 恢复调用者的第一个参数
00007FF7651B18C1  pop         rbp                       ; 恢复基址指针
00007FF7651B18C2  ret                                  ; 返回到调用者
