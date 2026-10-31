/* The runtime of FreeBASIC for iOS: its console includes this header, the SDK of iOS has no terminal library.
   The functions are in UIKit/mffUIKit.m */
#ifndef MFF_TERMCAP_H
#define MFF_TERMCAP_H
int tgetent(char *bp, const char *name);
int tgetflag(const char *id);
int tgetnum(const char *id);
char *tgetstr(const char *id, char **area);
char *tgoto(const char *cap, int col, int row);
int tputs(const char *str, int affcnt, int (*putc_)(int));
#endif
