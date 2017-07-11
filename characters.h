#ifndef SCORER_CHARACTERS
#define SCORER_CHARACTERS

#ifndef SCORER_CHARACTERS_ASCII
#define VBAR      0x2502
#define HBAR      0x2500
#define TLCORNER  0x250c
#define TRCORNER  0x2510
#define BLCORNER  0x2514
#define BRCORNER  0x2518
#define LEFTT     0x251c
#define RIGHTT    0x2524
#define UPT       0x252c
#define DOWNT     0x2534
#define MIDT      0x253c

#else

#define VBAR      '|'
#define HBAR      '-'
#define TLCORNER  '+'
#define TRCORNER  '+'
#define BLCORNER  '+'
#define BRCORNER  '+'
#define LEFTT     '+'
#define RIGHTT    '+'
#define UPT       '+'
#define DOWNT     '+'
#define MIDT      '+'

#endif

int character_test();

#endif
