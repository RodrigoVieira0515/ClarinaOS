#include <text_mode.h>
#include <stdint.h>

namespace TextMode {
    static uint16_t* VideoMemory = (uint16_t*)0xb8000;
    static uint8_t x=0,y=0;
    static uint8_t color = 0x07;

    void printf(char* str)
    {
        for(int i = 0; str[i] != '\0'; ++i)
        {
            switch(str[i])
            {
                case '\n':
                    x = 0;
                    y++;
                    break;
                default:
                    VideoMemory[80*y+x] = color << 8 | str[i];
                    x++;
                    break;
            }

            if(x >= 80)
            {
                x = 0;
                y++;
            }

            if(y >= 25)
            {
                for(y = 0; y < 25; y++)
                    for(x = 0; x < 80; x++)
                        VideoMemory[80*y+x] = color << 8 | ' ';
                x = 0;
                y = 0;
            }
        }
    }
    void clear() {
        x = 0;
        y = 0;
        for(int y = 0; y < 25; y++)
            for(int x = 0; x < 80; x++)
                VideoMemory[80*y+x] = color << 8 | ' ';
    }
}