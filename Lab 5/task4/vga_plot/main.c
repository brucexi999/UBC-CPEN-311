#include <stdio.h>
#include <stdlib.h>

int main()
{
     unsigned  x = 83;
     unsigned  y = 1;
     unsigned  colour = 7;
     unsigned writedata = (colour << 16) + (x << 8) + y;

     printf(writedata);
    return 0;
}
