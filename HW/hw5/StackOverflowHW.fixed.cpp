// Stack overflow Assignment
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>
using namespace std;

#define BUFSIZE 300

using namespace std;

char *mgets(char *dst)
{
    char *ptr = dst;
    int ch;
    int counter = 0;
    
    while ((ch = getchar()) && (ch == ' ' or ch == '\t'))
        ;

    if ((ch == '\n') or (ch == EOF) or (counter >= BUFSIZE))
    {
        *ptr = '\0';
        return dst;
    }
    else {
        *ptr = ch; 
        counter++;
    }
        
    while (true)
    {
        ch = getchar();
        if (ch == '\n' or ch == EOF or (counter >= BUFSIZE))
            break;
        *(++ptr) = ch;
        counter++;
    }
    *(++ptr) = 0;
    return dst;
}

void bad()
{
    char buffer[BUFSIZE];
    printf("buffer is at %p\n", buffer);
    cout << "Give me some text: ";
    fflush(stdout);
    mgets(buffer);
    cout << "Acknowledged: " << buffer << " with length " << strlen(buffer) << endl;
}

int main(int argc, char *argv[])
{
    gid_t gid = getegid();
    setresgid(gid, gid, gid);
    bad();
    cout << "Good bye!\n";
    return 0;
}