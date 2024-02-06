#include <stdint.h>
#include <multiboot.h>
#include <text_mode.h>

using namespace TextMode;

extern "C" void kernelMain(const void* multiboot_structure, uint32_t multiboot_magic)
{
    clear();
    printf("Hello world from kernel\n");
    if(multiboot_magic == Multiboot::magic)
    {
        printf("Multiboot magic is ok\n");
    }
    while(true);
}