/* mffMainThread.h - included twice by the hosts: the functions of Apple/mffApple.h run on the main thread, AppKit and
   UIKit work only there (the IDE compiles in a thread). First the implementations get the names real_*, at the end of
   the host (MFF_MAIN_THREAD_WRAPPERS) the functions with the names of mffApple.h call them on the main thread */
#ifndef MFF_MAIN_THREAD_WRAPPERS
#define mffViewCreate real_mffViewCreate
#define mffViewFree real_mffViewFree
#define mffViewControl real_mffViewControl
#define mffViewLayout real_mffViewLayout
#define mffViewAddChild real_mffViewAddChild
#define mffViewSetBounds real_mffViewSetBounds
#define mffViewClientSize real_mffViewClientSize
#define mffViewSetText real_mffViewSetText
#define mffViewGetText real_mffViewGetText
#define mffViewSetHint real_mffViewSetHint
#define mffViewSetVisible real_mffViewSetVisible
#define mffViewSetEnabled real_mffViewSetEnabled
#define mffViewSetFocus real_mffViewSetFocus
#define mffViewHasFocus real_mffViewHasFocus
#define mffViewSetBackColor real_mffViewSetBackColor
#define mffViewSetForeColor real_mffViewSetForeColor
#define mffViewSetFont real_mffViewSetFont
#define mffViewZOrder real_mffViewZOrder
#define mffViewRepaint real_mffViewRepaint
#define mffViewSetChecked real_mffViewSetChecked
#define mffViewGetChecked real_mffViewGetChecked
#define mffViewSetReadOnly real_mffViewSetReadOnly
#define mffViewSetAlignment real_mffViewSetAlignment
#define mffTextSetSelection real_mffTextSetSelection
#define mffTextScrollTo real_mffTextScrollTo
#define mffTextSetRTF real_mffTextSetRTF
#define mffLinkSetMarkup real_mffLinkSetMarkup
#define mffLinkClicked real_mffLinkClicked
#define mffSelectItemImage real_mffSelectItemImage
#define mffTextGetSelection real_mffTextGetSelection
#define mffTextSetPassword real_mffTextSetPassword
#define mffListInsert real_mffListInsert
#define mffListRemove real_mffListRemove
#define mffListClear real_mffListClear
#define mffListGetIndex real_mffListGetIndex
#define mffListSetIndex real_mffListSetIndex
#define mffRangeSet real_mffRangeSet
#define mffPositionSet real_mffPositionSet
#define mffMarqueeSet real_mffMarqueeSet
#define mffScrollPageSet real_mffScrollPageSet
#define mffPositionGet real_mffPositionGet
#define mffFormShow real_mffFormShow
#define mffFormHide real_mffFormHide
#define mffFormSetState real_mffFormSetState
#define mffFormSetBorder real_mffFormSetBorder
#define mffFormSetMainMenu real_mffFormSetMainMenu
#define mffScreenSize real_mffScreenSize
#define mffAppRun real_mffAppRun
#define mffAppTerminate real_mffAppTerminate
#define mffAppDoEvents real_mffAppDoEvents
#define mffAppSetDarkMode real_mffAppSetDarkMode
#define mffAppDarkMode real_mffAppDarkMode
#define mffMessageBox real_mffMessageBox
#define mffTimerStart real_mffTimerStart
#define mffTimerStop real_mffTimerStop
#define mffClipboardSetText real_mffClipboardSetText
#define mffClipboardGetText real_mffClipboardGetText
#define mffOpenURL real_mffOpenURL
#define mffPageCreate real_mffPageCreate
#define mffPageFree real_mffPageFree
#define mffPageDraw real_mffPageDraw
#define mffPagesPrint real_mffPagesPrint
#define mffFileViewFill real_mffFileViewFill
#define mffFileViewAttr real_mffFileViewAttr
#define mffMenuBarSet real_mffMenuBarSet
#define mffListSetChecked real_mffListSetChecked
#define mffListGetChecked real_mffListGetChecked
#define mffTabsSet real_mffTabsSet
#define mffTabsSetPosition real_mffTabsSetPosition
#define mffTabsStripHeight real_mffTabsStripHeight
#define mffButtonsSet real_mffButtonsSet
#define mffButtonsItem real_mffButtonsItem
#define mffViewFittingWidth real_mffViewFittingWidth
#define mffWebLoadURL real_mffWebLoadURL
#define mffWebLoadHTML real_mffWebLoadHTML
#define mffWebAction real_mffWebAction
#define mffViewLoadImage real_mffViewLoadImage
#define mffPopupMenu real_mffPopupMenu
#define mffFileDialog real_mffFileDialog
#define mffInputBox real_mffInputBox
#define mffFontDialog real_mffFontDialog
#define mffColorDialog real_mffColorDialog
#define mffRegexCompile real_mffRegexCompile
#define mffRegexError real_mffRegexError
#define mffRegexFree real_mffRegexFree
#define mffRegexExec real_mffRegexExec
#define mffTableInit real_mffTableInit
#define mffTableSetView real_mffTableSetView
#define mffTableSetColumns real_mffTableSetColumns
#define mffTableInsertRow real_mffTableInsertRow
#define mffTableSetRow real_mffTableSetRow
#define mffTableCellRect real_mffTableCellRect
#define mffTableDblClick real_mffTableDblClick
#define mffCanvasBegin real_mffCanvasBegin
#define mffCanvasEnd real_mffCanvasEnd
#define mffCanvasNewPath real_mffCanvasNewPath
#define mffCanvasMoveTo real_mffCanvasMoveTo
#define mffCanvasLineTo real_mffCanvasLineTo
#define mffCanvasCurveTo real_mffCanvasCurveTo
#define mffCanvasArc real_mffCanvasArc
#define mffCanvasRectPath real_mffCanvasRectPath
#define mffCanvasClosePath real_mffCanvasClosePath
#define mffCanvasClip real_mffCanvasClip
#define mffCanvasFill real_mffCanvasFill
#define mffCanvasStroke real_mffCanvasStroke
#define mffCanvasFillRect real_mffCanvasFillRect
#define mffCanvasInvertRect real_mffCanvasInvertRect
#define mffCanvasRotate real_mffCanvasRotate
#define mffCanvasSave real_mffCanvasSave
#define mffCanvasRestore real_mffCanvasRestore
#define mffCanvasText real_mffCanvasText
#define mffCanvasTextWidth real_mffCanvasTextWidth
#define mffCanvasTextHeight real_mffCanvasTextHeight
#define mffCanvasGetPixel real_mffCanvasGetPixel
#define mffCanvasImage real_mffCanvasImage
#else
#undef mffViewCreate
#undef mffViewFree
#undef mffViewControl
#undef mffViewLayout
#undef mffViewAddChild
#undef mffViewSetBounds
#undef mffViewClientSize
#undef mffViewSetText
#undef mffViewGetText
#undef mffViewSetHint
#undef mffViewSetVisible
#undef mffViewSetEnabled
#undef mffViewSetFocus
#undef mffViewHasFocus
#undef mffViewSetBackColor
#undef mffViewSetForeColor
#undef mffViewSetFont
#undef mffViewZOrder
#undef mffViewRepaint
#undef mffViewSetChecked
#undef mffViewGetChecked
#undef mffViewSetReadOnly
#undef mffViewSetAlignment
#undef mffTextSetSelection
#undef mffTextScrollTo
#undef mffTextSetRTF
#undef mffLinkSetMarkup
#undef mffLinkClicked
#undef mffSelectItemImage
#undef mffTextGetSelection
#undef mffTextSetPassword
#undef mffListInsert
#undef mffListRemove
#undef mffListClear
#undef mffListGetIndex
#undef mffListSetIndex
#undef mffRangeSet
#undef mffPositionSet
#undef mffMarqueeSet
#undef mffScrollPageSet
#undef mffPositionGet
#undef mffFormShow
#undef mffFormHide
#undef mffFormSetState
#undef mffFormSetBorder
#undef mffFormSetMainMenu
#undef mffScreenSize
#undef mffAppRun
#undef mffAppTerminate
#undef mffAppDoEvents
#undef mffAppSetDarkMode
#undef mffAppDarkMode
#undef mffMessageBox
#undef mffTimerStart
#undef mffTimerStop
#undef mffClipboardSetText
#undef mffClipboardGetText
#undef mffOpenURL
#undef mffPageCreate
#undef mffPageFree
#undef mffPageDraw
#undef mffPagesPrint
#undef mffFileViewFill
#undef mffFileViewAttr
#undef mffMenuBarSet
#undef mffListSetChecked
#undef mffListGetChecked
#undef mffTabsSet
#undef mffTabsSetPosition
#undef mffTabsStripHeight
#undef mffButtonsSet
#undef mffButtonsItem
#undef mffViewFittingWidth
#undef mffWebLoadURL
#undef mffWebLoadHTML
#undef mffWebAction
#undef mffViewLoadImage
#undef mffPopupMenu
#undef mffFileDialog
#undef mffInputBox
#undef mffFontDialog
#undef mffColorDialog
#undef mffRegexCompile
#undef mffRegexError
#undef mffRegexFree
#undef mffRegexExec
#undef mffTableInit
#undef mffTableSetView
#undef mffTableSetColumns
#undef mffTableInsertRow
#undef mffTableSetRow
#undef mffTableCellRect
#undef mffTableDblClick
#undef mffCanvasBegin
#undef mffCanvasEnd
#undef mffCanvasNewPath
#undef mffCanvasMoveTo
#undef mffCanvasLineTo
#undef mffCanvasCurveTo
#undef mffCanvasArc
#undef mffCanvasRectPath
#undef mffCanvasClosePath
#undef mffCanvasClip
#undef mffCanvasFill
#undef mffCanvasStroke
#undef mffCanvasFillRect
#undef mffCanvasInvertRect
#undef mffCanvasRotate
#undef mffCanvasSave
#undef mffCanvasRestore
#undef mffCanvasText
#undef mffCanvasTextWidth
#undef mffCanvasTextHeight
#undef mffCanvasGetPixel
#undef mffCanvasImage
void *mffViewCreate(const char *kind, void *ctrl) { if ([NSThread isMainThread]) return real_mffViewCreate(kind, ctrl); __block void *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewCreate(kind, ctrl); }); return r_; }
void mffViewFree(void *view) { if ([NSThread isMainThread]) real_mffViewFree(view); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewFree(view); }); }
void *mffViewControl(void *view) { if ([NSThread isMainThread]) return real_mffViewControl(view); __block void *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewControl(view); }); return r_; }
void *mffViewLayout(void *view) { if ([NSThread isMainThread]) return real_mffViewLayout(view); __block void *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewLayout(view); }); return r_; }
void mffViewAddChild(void *parent, void *child) { if ([NSThread isMainThread]) real_mffViewAddChild(parent, child); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewAddChild(parent, child); }); }
void mffViewSetBounds(void *view, int x, int y, int w, int h) { if ([NSThread isMainThread]) real_mffViewSetBounds(view, x, y, w, h); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetBounds(view, x, y, w, h); }); }
int mffViewClientSize(void *view, int vertical) { if ([NSThread isMainThread]) return real_mffViewClientSize(view, vertical); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewClientSize(view, vertical); }); return r_; }
void mffViewSetText(void *view, const char *text) { if ([NSThread isMainThread]) real_mffViewSetText(view, text); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetText(view, text); }); }
char *mffViewGetText(void *view) { if ([NSThread isMainThread]) return real_mffViewGetText(view); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewGetText(view); }); return r_; }
void mffViewSetHint(void *view, const char *text) { if ([NSThread isMainThread]) real_mffViewSetHint(view, text); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetHint(view, text); }); }
void mffViewSetVisible(void *view, int value) { if ([NSThread isMainThread]) real_mffViewSetVisible(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetVisible(view, value); }); }
void mffViewSetEnabled(void *view, int value) { if ([NSThread isMainThread]) real_mffViewSetEnabled(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetEnabled(view, value); }); }
void mffViewSetFocus(void *view) { if ([NSThread isMainThread]) real_mffViewSetFocus(view); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetFocus(view); }); }
int mffViewHasFocus(void *view) { if ([NSThread isMainThread]) return real_mffViewHasFocus(view); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewHasFocus(view); }); return r_; }
void mffViewSetBackColor(void *view, int color) { if ([NSThread isMainThread]) real_mffViewSetBackColor(view, color); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetBackColor(view, color); }); }
void mffViewSetForeColor(void *view, int color) { if ([NSThread isMainThread]) real_mffViewSetForeColor(view, color); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetForeColor(view, color); }); }
void mffViewSetFont(void *view, const char *name, float size, int style) { if ([NSThread isMainThread]) real_mffViewSetFont(view, name, size, style); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetFont(view, name, size, style); }); }
void mffViewZOrder(void *view, int toFront) { if ([NSThread isMainThread]) real_mffViewZOrder(view, toFront); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewZOrder(view, toFront); }); }
void mffViewRepaint(void *view) { if ([NSThread isMainThread]) real_mffViewRepaint(view); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewRepaint(view); }); }
void mffViewSetChecked(void *view, int value) { if ([NSThread isMainThread]) real_mffViewSetChecked(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetChecked(view, value); }); }
int mffViewGetChecked(void *view) { if ([NSThread isMainThread]) return real_mffViewGetChecked(view); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewGetChecked(view); }); return r_; }
void mffViewSetReadOnly(void *view, int value) { if ([NSThread isMainThread]) real_mffViewSetReadOnly(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetReadOnly(view, value); }); }
void mffViewSetAlignment(void *view, int value) { if ([NSThread isMainThread]) real_mffViewSetAlignment(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewSetAlignment(view, value); }); }
void mffTextScrollTo(void *view, int toEnd) { if ([NSThread isMainThread]) real_mffTextScrollTo(view, toEnd); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTextScrollTo(view, toEnd); }); }
void mffTextSetRTF(void *view, const char *rtf) { if ([NSThread isMainThread]) real_mffTextSetRTF(view, rtf); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTextSetRTF(view, rtf); }); }
void mffLinkSetMarkup(void *view, const char *markup) { if ([NSThread isMainThread]) real_mffLinkSetMarkup(view, markup); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffLinkSetMarkup(view, markup); }); }
const char *mffLinkClicked(void) { if ([NSThread isMainThread]) return real_mffLinkClicked(); __block const char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffLinkClicked(); }); return r_; }
void mffSelectItemImage(void *view, int index, const char *path, int indent) { if ([NSThread isMainThread]) real_mffSelectItemImage(view, index, path, indent); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffSelectItemImage(view, index, path, indent); }); }
void mffTextSetSelection(void *view, int start, int length) { if ([NSThread isMainThread]) real_mffTextSetSelection(view, start, length); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTextSetSelection(view, start, length); }); }
int mffTextGetSelection(void *view, int getLength) { if ([NSThread isMainThread]) return real_mffTextGetSelection(view, getLength); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffTextGetSelection(view, getLength); }); return r_; }
void mffTextSetPassword(void *view, int value) { if ([NSThread isMainThread]) real_mffTextSetPassword(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTextSetPassword(view, value); }); }
void mffListInsert(void *view, int index, const char *text) { if ([NSThread isMainThread]) real_mffListInsert(view, index, text); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffListInsert(view, index, text); }); }
void mffListRemove(void *view, int index) { if ([NSThread isMainThread]) real_mffListRemove(view, index); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffListRemove(view, index); }); }
void mffListClear(void *view) { if ([NSThread isMainThread]) real_mffListClear(view); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffListClear(view); }); }
int mffListGetIndex(void *view) { if ([NSThread isMainThread]) return real_mffListGetIndex(view); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffListGetIndex(view); }); return r_; }
void mffListSetIndex(void *view, int index) { if ([NSThread isMainThread]) real_mffListSetIndex(view, index); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffListSetIndex(view, index); }); }
void mffRangeSet(void *view, int minValue, int maxValue) { if ([NSThread isMainThread]) real_mffRangeSet(view, minValue, maxValue); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffRangeSet(view, minValue, maxValue); }); }
void mffPositionSet(void *view, int value) { if ([NSThread isMainThread]) real_mffPositionSet(view, value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffPositionSet(view, value); }); }
void mffMarqueeSet(void *view, int marqueeOn) { if ([NSThread isMainThread]) real_mffMarqueeSet(view, marqueeOn); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffMarqueeSet(view, marqueeOn); }); }
void mffScrollPageSet(void *view, int page) { if ([NSThread isMainThread]) real_mffScrollPageSet(view, page); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffScrollPageSet(view, page); }); }
int mffPositionGet(void *view) { if ([NSThread isMainThread]) return real_mffPositionGet(view); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffPositionGet(view); }); return r_; }
void mffFormShow(void *view, int modal) { if ([NSThread isMainThread]) real_mffFormShow(view, modal); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffFormShow(view, modal); }); }
void mffFormHide(void *view) { if ([NSThread isMainThread]) real_mffFormHide(view); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffFormHide(view); }); }
void mffFormSetState(void *view, int state) { if ([NSThread isMainThread]) real_mffFormSetState(view, state); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffFormSetState(view, state); }); }
void mffFormSetBorder(void *view, int style) { if ([NSThread isMainThread]) real_mffFormSetBorder(view, style); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffFormSetBorder(view, style); }); }
void mffFormSetMainMenu(void *view, const char *items) { if ([NSThread isMainThread]) real_mffFormSetMainMenu(view, items); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffFormSetMainMenu(view, items); }); }
int mffScreenSize(int vertical) { if ([NSThread isMainThread]) return real_mffScreenSize(vertical); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffScreenSize(vertical); }); return r_; }
void mffAppRun(void) { if ([NSThread isMainThread]) real_mffAppRun(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffAppRun(); }); }
void mffAppTerminate(void) { if ([NSThread isMainThread]) real_mffAppTerminate(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffAppTerminate(); }); }
void mffAppDoEvents(void) { if ([NSThread isMainThread]) real_mffAppDoEvents(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffAppDoEvents(); }); }
void mffAppSetDarkMode(int value) { if ([NSThread isMainThread]) real_mffAppSetDarkMode(value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffAppSetDarkMode(value); }); }
int mffAppDarkMode(void) { if ([NSThread isMainThread]) return real_mffAppDarkMode(); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffAppDarkMode(); }); return r_; }
int mffMessageBox(const char *msg, const char *caption, int messageType, int buttonsType) { if ([NSThread isMainThread]) return real_mffMessageBox(msg, caption, messageType, buttonsType); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffMessageBox(msg, caption, messageType, buttonsType); }); return r_; }
void mffTimerStart(void *id, int interval) { if ([NSThread isMainThread]) real_mffTimerStart(id, interval); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTimerStart(id, interval); }); }
void mffTimerStop(void *id) { if ([NSThread isMainThread]) real_mffTimerStop(id); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTimerStop(id); }); }
void mffClipboardSetText(const char *text) { if ([NSThread isMainThread]) real_mffClipboardSetText(text); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffClipboardSetText(text); }); }
char *mffClipboardGetText(void) { if ([NSThread isMainThread]) return real_mffClipboardGetText(); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffClipboardGetText(); }); return r_; }
void mffOpenURL(const char *url) { if ([NSThread isMainThread]) real_mffOpenURL(url); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffOpenURL(url); }); }
void *mffPageCreate(int width, int height) { if ([NSThread isMainThread]) return real_mffPageCreate(width, height); __block void *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffPageCreate(width, height); }); return r_; }
void mffPageFree(void *page) { if ([NSThread isMainThread]) real_mffPageFree(page); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffPageFree(page); }); }
void mffPageDraw(void *page, int x, int y, int w, int h) { if ([NSThread isMainThread]) real_mffPageDraw(page, x, y, w, h); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffPageDraw(page, x, y, w, h); }); }
void mffPagesPrint(void **pages, int count, const char *name) { if ([NSThread isMainThread]) real_mffPagesPrint(pages, count, name); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffPagesPrint(pages, count, name); }); }
void mffFileViewFill(void *view, const char *dir, const char *patterns, int multiple) { if ([NSThread isMainThread]) real_mffFileViewFill(view, dir, patterns, multiple); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffFileViewFill(view, dir, patterns, multiple); }); }
char *mffFileViewAttr(void *view, const char *name) { if ([NSThread isMainThread]) return real_mffFileViewAttr(view, name); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffFileViewAttr(view, name); }); return r_; }
void mffMenuBarSet(const char *items) { if ([NSThread isMainThread]) real_mffMenuBarSet(items); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffMenuBarSet(items); }); }
void mffListSetChecked(void *Id, int Index, int Value) { if ([NSThread isMainThread]) real_mffListSetChecked(Id, Index, Value); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffListSetChecked(Id, Index, Value); }); }
int mffListGetChecked(void *Id, int Index) { if ([NSThread isMainThread]) return real_mffListGetChecked(Id, Index); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffListGetChecked(Id, Index); }); return r_; }
void mffTabsSet(void *Id, const char *Titles) { if ([NSThread isMainThread]) real_mffTabsSet(Id, Titles); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTabsSet(Id, Titles); }); }
void mffTabsSetPosition(void *Id, int Position) { if ([NSThread isMainThread]) real_mffTabsSetPosition(Id, Position); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTabsSetPosition(Id, Position); }); }
int mffTabsStripHeight(void) { if ([NSThread isMainThread]) return real_mffTabsStripHeight(); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffTabsStripHeight(); }); return r_; }
void mffButtonsSet(void *Id, const char *Items) { if ([NSThread isMainThread]) real_mffButtonsSet(Id, Items); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffButtonsSet(Id, Items); }); }
int mffButtonsItem(void *Id, int Index, int What) { if ([NSThread isMainThread]) return real_mffButtonsItem(Id, Index, What); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffButtonsItem(Id, Index, What); }); return r_; }
int mffViewFittingWidth(void *Id) { if ([NSThread isMainThread]) return real_mffViewFittingWidth(Id); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffViewFittingWidth(Id); }); return r_; }
void mffWebLoadURL(void *Id, const char *URL) { if ([NSThread isMainThread]) real_mffWebLoadURL(Id, URL); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffWebLoadURL(Id, URL); }); }
void mffWebLoadHTML(void *Id, const char *HTML) { if ([NSThread isMainThread]) real_mffWebLoadHTML(Id, HTML); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffWebLoadHTML(Id, HTML); }); }
void mffWebAction(void *Id, int Action) { if ([NSThread isMainThread]) real_mffWebAction(Id, Action); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffWebAction(Id, Action); }); }
void mffViewLoadImage(void *Id, const char *Path, int Center) { if ([NSThread isMainThread]) real_mffViewLoadImage(Id, Path, Center); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffViewLoadImage(Id, Path, Center); }); }
int mffPopupMenu(const char *Items, int x, int y) { if ([NSThread isMainThread]) return real_mffPopupMenu(Items, x, y); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffPopupMenu(Items, x, y); }); return r_; }
char *mffInputBox(const char *caption, const char *msg, const char *defaultText, int password) { if ([NSThread isMainThread]) return real_mffInputBox(caption, msg, defaultText, password); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffInputBox(caption, msg, defaultText, password); }); return r_; }
char *mffFileDialog(int Mode, const char *Caption, const char *InitialDir, const char *FileName, const char *Filter, int FilterIndex) { if ([NSThread isMainThread]) return real_mffFileDialog(Mode, Caption, InitialDir, FileName, Filter, FilterIndex); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffFileDialog(Mode, Caption, InitialDir, FileName, Filter, FilterIndex); }); return r_; }
char *mffFontDialog(const char *FontName, int Size, int Style, int FontColor) { if ([NSThread isMainThread]) return real_mffFontDialog(FontName, Size, Style, FontColor); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffFontDialog(FontName, Size, Style, FontColor); }); return r_; }
int mffColorDialog(const char *Caption, int ColorValue) { if ([NSThread isMainThread]) return real_mffColorDialog(Caption, ColorValue); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffColorDialog(Caption, ColorValue); }); return r_; }
int mffRegexCompile(const char *Pattern, int Flags) { if ([NSThread isMainThread]) return real_mffRegexCompile(Pattern, Flags); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffRegexCompile(Pattern, Flags); }); return r_; }
char *mffRegexError(void) { if ([NSThread isMainThread]) return real_mffRegexError(); __block char *r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffRegexError(); }); return r_; }
void mffRegexFree(int Id) { if ([NSThread isMainThread]) real_mffRegexFree(Id); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffRegexFree(Id); }); }
int mffRegexExec(int Id, const char *Subject, int StartByte, int *Offsets, int MaxGroups) { if ([NSThread isMainThread]) return real_mffRegexExec(Id, Subject, StartByte, Offsets, MaxGroups); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffRegexExec(Id, Subject, StartByte, Offsets, MaxGroups); }); return r_; }
void mffTableInit(void *Id) { if ([NSThread isMainThread]) real_mffTableInit(Id); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTableInit(Id); }); }
void mffTableSetView(void *Id, const char *ViewName) { if ([NSThread isMainThread]) real_mffTableSetView(Id, ViewName); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTableSetView(Id, ViewName); }); }
void mffTableSetColumns(void *Id, const char *Captions, const char *Widths) { if ([NSThread isMainThread]) real_mffTableSetColumns(Id, Captions, Widths); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTableSetColumns(Id, Captions, Widths); }); }
void mffTableInsertRow(void *Id, int Index, const char *Cells) { if ([NSThread isMainThread]) real_mffTableInsertRow(Id, Index, Cells); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTableInsertRow(Id, Index, Cells); }); }
void mffTableSetRow(void *Id, int Index, const char *Cells) { if ([NSThread isMainThread]) real_mffTableSetRow(Id, Index, Cells); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTableSetRow(Id, Index, Cells); }); }
void mffTableCellRect(void *Id, int Row, int Col, void *pRect) { if ([NSThread isMainThread]) real_mffTableCellRect(Id, Row, Col, pRect); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffTableCellRect(Id, Row, Col, pRect); }); }
int mffTableDblClick(void) { if ([NSThread isMainThread]) return real_mffTableDblClick(); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffTableDblClick(); }); return r_; }
void mffCanvasBegin(void *Id) { if ([NSThread isMainThread]) real_mffCanvasBegin(Id); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasBegin(Id); }); }
void mffCanvasEnd(void *Id) { if ([NSThread isMainThread]) real_mffCanvasEnd(Id); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasEnd(Id); }); }
void mffCanvasNewPath(void) { if ([NSThread isMainThread]) real_mffCanvasNewPath(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasNewPath(); }); }
void mffCanvasMoveTo(double x, double y) { if ([NSThread isMainThread]) real_mffCanvasMoveTo(x, y); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasMoveTo(x, y); }); }
void mffCanvasLineTo(double x, double y) { if ([NSThread isMainThread]) real_mffCanvasLineTo(x, y); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasLineTo(x, y); }); }
void mffCanvasCurveTo(double x1, double y1, double x2, double y2, double x3, double y3) { if ([NSThread isMainThread]) real_mffCanvasCurveTo(x1, y1, x2, y2, x3, y3); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasCurveTo(x1, y1, x2, y2, x3, y3); }); }
void mffCanvasArc(double cx, double cy, double r, double a1, double a2, int Negative) { if ([NSThread isMainThread]) real_mffCanvasArc(cx, cy, r, a1, a2, Negative); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasArc(cx, cy, r, a1, a2, Negative); }); }
void mffCanvasRectPath(double x, double y, double w, double h) { if ([NSThread isMainThread]) real_mffCanvasRectPath(x, y, w, h); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasRectPath(x, y, w, h); }); }
void mffCanvasClosePath(void) { if ([NSThread isMainThread]) real_mffCanvasClosePath(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasClosePath(); }); }
void mffCanvasClip(void) { if ([NSThread isMainThread]) real_mffCanvasClip(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasClip(); }); }
void mffCanvasFill(int iColor, int Alpha) { if ([NSThread isMainThread]) real_mffCanvasFill(iColor, Alpha); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasFill(iColor, Alpha); }); }
void mffCanvasStroke(int iColor, int Alpha, double LineWidth, const char *Dash) { if ([NSThread isMainThread]) real_mffCanvasStroke(iColor, Alpha, LineWidth, Dash); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasStroke(iColor, Alpha, LineWidth, Dash); }); }
void mffCanvasFillRect(double x, double y, double w, double h, int iColor, int Alpha) { if ([NSThread isMainThread]) real_mffCanvasFillRect(x, y, w, h, iColor, Alpha); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasFillRect(x, y, w, h, iColor, Alpha); }); }
void mffCanvasInvertRect(double x, double y, double w, double h) { if ([NSThread isMainThread]) real_mffCanvasInvertRect(x, y, w, h); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasInvertRect(x, y, w, h); }); }
void mffCanvasRotate(double x, double y, double Angle) { if ([NSThread isMainThread]) real_mffCanvasRotate(x, y, Angle); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasRotate(x, y, Angle); }); }
void mffCanvasSave(void) { if ([NSThread isMainThread]) real_mffCanvasSave(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasSave(); }); }
void mffCanvasRestore(void) { if ([NSThread isMainThread]) real_mffCanvasRestore(); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasRestore(); }); }
void mffCanvasText(double x, double y, const char *Text, int iColor, int iBkColor, const char *FontName, double FontSize, int Bold, int Italic) { if ([NSThread isMainThread]) real_mffCanvasText(x, y, Text, iColor, iBkColor, FontName, FontSize, Bold, Italic); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasText(x, y, Text, iColor, iBkColor, FontName, FontSize, Bold, Italic); }); }
int mffCanvasTextWidth(const char *Text, const char *FontName, double FontSize, int Bold, int Italic) { if ([NSThread isMainThread]) return real_mffCanvasTextWidth(Text, FontName, FontSize, Bold, Italic); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffCanvasTextWidth(Text, FontName, FontSize, Bold, Italic); }); return r_; }
int mffCanvasTextHeight(const char *FontName, double FontSize, int Bold, int Italic) { if ([NSThread isMainThread]) return real_mffCanvasTextHeight(FontName, FontSize, Bold, Italic); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffCanvasTextHeight(FontName, FontSize, Bold, Italic); }); return r_; }
int mffCanvasGetPixel(double x, double y) { if ([NSThread isMainThread]) return real_mffCanvasGetPixel(x, y); __block int r_; dispatch_sync(dispatch_get_main_queue(), ^{ r_ = real_mffCanvasGetPixel(x, y); }); return r_; }
void mffCanvasImage(const char *Path, double x, double y, double w, double h, int Alpha) { if ([NSThread isMainThread]) real_mffCanvasImage(Path, x, y, w, h, Alpha); else dispatch_sync(dispatch_get_main_queue(), ^{ real_mffCanvasImage(Path, x, y, w, h, Alpha); }); }
#endif
