/*
 * mffApple.h - MyFbFramework: the C functions of the Objective-C host of macOS (Cocoa/mffCocoa.m) and
 * iOS (UIKit/mffUIKit.m). The FreeBASIC side declares the same functions in Apple/mffApple.bi.
 *
 * A view is the retained NSView/UIView which the host returns (a Form: its NSWindow on macOS, the view of
 * its UIViewController on iOS); ctrl is the Control Ptr of the FreeBASIC side which gets the events of the
 * view (the mffOn* functions of Control.bas). Strings are UTF-8, a returned char* is made with malloc.
 * Colors are BGR (0xBBGGRR) like on Windows, -1 is the default color of the view.
 */
#ifndef MFF_APPLE_H
#define MFF_APPLE_H

#ifdef __cplusplus
extern "C" {
#endif

/* Kind: the class name of the control ("Form", "CommandButton", "Label", "TextBox", "CheckBox",
   "RadioButton", "Panel", "GroupBox", "ListControl", "ComboBoxEdit", "ProgressBar", "TrackBar", ...) or the
   kind of its ClassAncestor "mff:Kind" ("TextArea"). An unknown kind is a plain view which hosts the child
   controls and draws the Canvas of the control. */
void *mffViewCreate(const char *kind, void *ctrl);
void mffViewFree(void *view);
void *mffViewControl(void *view);
void *mffViewLayout(void *view);
void mffViewAddChild(void *parent, void *child);
/* Points from the top left corner of the parent (of the main screen for a Form: its outer frame) */
void mffViewSetBounds(void *view, int x, int y, int w, int h);
int mffViewClientSize(void *view, int vertical);
void mffViewSetText(void *view, const char *text);
char *mffViewGetText(void *view);
void mffViewSetHint(void *view, const char *text);
void mffViewSetVisible(void *view, int value);
void mffViewSetEnabled(void *view, int value);
void mffViewSetFocus(void *view);
int mffViewHasFocus(void *view);
void mffViewSetBackColor(void *view, int color);
void mffViewSetForeColor(void *view, int color);
/* style: 1 - bold, 2 - italic, 4 - underline, 8 - strikeout */
void mffViewSetFont(void *view, const char *name, float size, int style);
void mffViewZOrder(void *view, int toFront);
void mffViewRepaint(void *view);
void mffViewSetChecked(void *view, int value);
int mffViewGetChecked(void *view);
void mffViewSetReadOnly(void *view, int value);
/* 0 - left, 1 - center, 2 - right */
void mffViewSetAlignment(void *view, int value);
void mffTextSetSelection(void *view, int start, int length);
int mffTextGetSelection(void *view, int getLength);
void mffTextSetPassword(void *view, int value);

void mffListInsert(void *view, int index, const char *text);
void mffListRemove(void *view, int index);
void mffListClear(void *view);
int mffListGetIndex(void *view);
void mffListSetIndex(void *view, int index);

void mffRangeSet(void *view, int minValue, int maxValue);
void mffPositionSet(void *view, int value);
int mffPositionGet(void *view);

/* modal: a nested loop until mffFormHide of the form */
void mffFormShow(void *view, int modal);
void mffFormHide(void *view);
/* 0 - normal, 1 - minimized, 2 - maximized */
void mffFormSetState(void *view, int state);
/* FormBorderStyle of Form.bi: 0 - None, 1 - SizableToolWindow, 2 - FixedToolWindow, 3 - Sizable,
   4 - Fixed3D, 5 - FixedSingle, 6 - FixedDialog */
void mffFormSetBorder(void *view, int style);
void mffFormSetMainMenu(void *view, const char *items);
int mffScreenSize(int vertical);

void mffAppRun(void);
void mffAppTerminate(void);
void mffAppDoEvents(void);
void mffAppSetDarkMode(int value);
int mffAppDarkMode(void);
/* MessageType: 0 - info, 1 - warning, 2 - question, 3 - error, 4 - other;
   ButtonsTypes: 0 - none, 1 - OK, 2 - Yes No, 3 - Yes No Cancel, 4 - OK Cancel;
   returns MessageResult: 0 - abort, 1 - cancel, 2 - ignore, 3 - no, 4 - OK, 5 - retry, 6 - yes */
int mffMessageBox(const char *msg, const char *caption, int messageType, int buttonsType);
void mffTimerStart(void *id, int interval);
void mffTimerStop(void *id);
void mffClipboardSetText(const char *text);
char *mffClipboardGetText(void);
void mffOpenURL(const char *url);
void mffMenuBarSet(const char *items);

/* See Apple/mffApple.bi */
void mffListSetChecked(void *Id, int Index, int Value);
int mffListGetChecked(void *Id, int Index);
void mffTabsSet(void *Id, const char *Titles);
void mffTabsSetPosition(void *Id, int Position);
int mffTabsStripHeight(void);
void mffButtonsSet(void *Id, const char *Items);
int mffButtonsItem(void *Id, int Index, int What);
int mffViewFittingWidth(void *Id);
void mffWebLoadURL(void *Id, const char *URL);
void mffWebLoadHTML(void *Id, const char *HTML);
void mffWebAction(void *Id, int Action);
void mffViewLoadImage(void *Id, const char *Path, int Center);
int mffPopupMenu(const char *Items, int x, int y);
char *mffFileDialog(int Mode, const char *Caption, const char *InitialDir, const char *FileName, const char *Filter, int FilterIndex);
char *mffFontDialog(const char *FontName, int Size, int Style, int FontColor);
int mffColorDialog(const char *Caption, int ColorValue);
int mffRegexCompile(const char *Pattern, int Flags);
char *mffRegexError(void);
void mffRegexFree(int Id);
int mffRegexExec(int Id, const char *Subject, int StartByte, int *Offsets, int MaxGroups);
void mffTableInit(void *Id);
void mffTableSetView(void *Id, const char *ViewName);
void mffTableSetColumns(void *Id, const char *Captions, const char *Widths);
void mffTableInsertRow(void *Id, int Index, const char *Cells);
void mffTableSetRow(void *Id, int Index, const char *Cells);
void mffTableCellRect(void *Id, int Row, int Col, void *pRect);
int mffTableDblClick(void);
void mffCanvasBegin(void *Id);
void mffCanvasEnd(void *Id);
void mffCanvasNewPath(void);
void mffCanvasMoveTo(double x, double y);
void mffCanvasLineTo(double x, double y);
void mffCanvasCurveTo(double x1, double y1, double x2, double y2, double x3, double y3);
void mffCanvasArc(double cx, double cy, double r, double a1, double a2, int Negative);
void mffCanvasRectPath(double x, double y, double w, double h);
void mffCanvasClosePath(void);
void mffCanvasClip(void);
void mffCanvasFill(int iColor, int Alpha);
void mffCanvasStroke(int iColor, int Alpha, double LineWidth, const char *Dash);
void mffCanvasFillRect(double x, double y, double w, double h, int iColor, int Alpha);
void mffCanvasInvertRect(double x, double y, double w, double h);
void mffCanvasRotate(double x, double y, double Angle);
void mffCanvasSave(void);
void mffCanvasRestore(void);
void mffCanvasText(double x, double y, const char *Text, int iColor, int iBkColor, const char *FontName, double FontSize, int Bold, int Italic);
int mffCanvasTextWidth(const char *Text, const char *FontName, double FontSize, int Bold, int Italic);
int mffCanvasTextHeight(const char *FontName, double FontSize, int Bold, int Italic);
int mffCanvasGetPixel(double x, double y);
void mffCanvasImage(const char *Path, double x, double y, double w, double h, int Alpha);

/* The events: implemented by the FreeBASIC side (Control.bas) */
void mffOnClick(void *ctrl);
void mffOnChange(void *ctrl, int wParam);
void mffOnDblClick(void *ctrl);
/* action: 0 - down, 1 - up, 2 - move (button -1: none), 3 - leave, 4 - wheel (button 1 up, -1 down),
   5 - horizontal wheel; button: 0 - left, 1 - right, 2 - middle; shift: 1 - Shift, 2 - Ctrl/Command, 4 - Alt */
void mffOnMouse(void *ctrl, int action, int button, int x, int y, int shift);
/* action: 0 - key down, 1 - key up (key: VK_* of Windows), 2 - a character, 3 - got the focus, 4 - lost it.
   Returns 1 if the control handled the key */
int mffOnKey(void *ctrl, int action, int key, int shift);
void mffOnResize(void *ctrl, int width, int height);
void mffOnMove(void *ctrl, int x, int y);
void mffOnClose(void *ctrl);
void mffOnTimer(void *id);
void mffOnPaint(void *ctrl);
/* An item of the bar of the menu: the index of its line of mffMenuBarSet */
void mffOnMenu(int index);

#ifdef __cplusplus
}
#endif

#endif
