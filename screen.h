// Video memory:
//          0     1     2     3     ... 80
// line 0   char  color char  color ...
// line 1   char  color char  color ...
// ...
// line 25

#define SCREEN_WIDTH    80
#define SCREEN_HEIGHT   25
#define CHAR_COLOR      15 // white

void screen_init();
void printchar(char);
void print(char *);
void println();
void printi(int);
