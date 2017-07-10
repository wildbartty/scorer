#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "characters.h"

int character_test()
{
    printf("vbar     prints: %lc \n"
	   "hbar     prints: %lc \n"
	   "tlcorner prints: %lc \n"
	   "trcorner prints: %lc \n"
	   "blcorner prints: %lc \n"
	   "brcorner prints: %lc\n"
	   "leftt    prints: %lc\n"
	   "rightt   prints: %lc\n"
	   "upt      prints: %lc\n"
	   "downt    prints: %lc\n"
	   "midt     prints: %lc\n"
	   ,
	   VBAR, HBAR, TLCORNER, TRCORNER
	   , BLCORNER, BRCORNER);
    return 0;
}
