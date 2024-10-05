#include <stdio.h>

int main() {
    char letter = 'a';  // 小写字母的起始字符

    for (int i = 0; i < 26; i++,letter++) {
        printf("%c", letter);  // 输出当前字符
        // 每行输出 13 个字符
        if ((i + 1) % 13 == 0) {
            printf("\n");  // 换行
        }
    }



    return 0;
}
