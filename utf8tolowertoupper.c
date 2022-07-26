#include <string.h>
#include <stdio.h>
#include <ctype.h>

bool isutf8(const char c) {
    return (((c)&0xC0)>=0x80);
}

void convert_to_uppercase(char *p) {
    for (; *p; ++p) {
        if (isutf8(*p)==true) {
            ++p;
            *p = toupper((unsigned char)*p)-32;
        } 
    else
        *p = tolower(*p);
    }
}

void convert_to_lowercase(char *p) {
    for (; *p; ++p) {
        if (isutf8(*p)==true) {
            ++p;
            *p = tolower((unsigned char)*p)+32;
        } 
    else
        *p = tolower(*p);
    }
}

int main () {
    char str[] = "ç";
    char conv[] = "Ç";
    convert_to_lowercase(conv);
    printf("%d -> %d  %d -> %d",str[0],conv[0],str[1],conv[1]);
    
    return 0;
}
