#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curses.h>
#include <locale.h>
#include "characters.h"

int main() {
    setlocale(LC_ALL, "");
    character_test();
    return 0;
}

