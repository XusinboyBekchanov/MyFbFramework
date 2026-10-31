/*
 * mffCocoa.m - MyFbFramework: the AppKit host of macOS (-d __USE_COCOA__).
 * The program (the C code of fbc -gen gcc) is linked with it:
 *   clang -fobjc-arc -framework Cocoa mffCocoa.m Program.c libfb.a -o Program
 * The functions are described in Apple/mffApple.h.
 */
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Apple/mffApple.h"

static char kMffCtrlKey;
/* The host sets the frame of a window (no mffOnResize then) / the user moved or resized it (mffOnResize, mffOnMove:
   the bounds which the control sets meanwhile are the ones of the window already) */
static BOOL mffSettingFrame, mffInWindowEvent;
/* The program changes the selection (the events are for the changes of the user); a double click on a row of a table */
static BOOL mffSilent;
static int mffDblClick, mffPopupResult = -1;
static char kMffTableKey, kMffChecksKey, kMffFileViewKey;
static void mffFileViewChoose(id table, id owner, NSInteger row, BOOL activate);

/* The Control Ptr of the FreeBASIC side which gets the events of the object */
static void mffSetCtrl(id obj, void *ctrl) {
	objc_setAssociatedObject(obj, &kMffCtrlKey, [NSValue valueWithPointer:ctrl], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void *mffGetCtrl(id obj) {
	NSValue *v = objc_getAssociatedObject(obj, &kMffCtrlKey);
	return v ? [v pointerValue] : NULL;
}

static NSString *mffStr(const char *s) {
	return s ? ([NSString stringWithUTF8String:s] ?: @"") : @"";
}

static char *mffDup(NSString *s) {
	return strdup(s ? [s UTF8String] : "");
}

/* The text of a button, a label, ... without the & of the access keys of Windows ("&&" is "&") */
static NSString *mffNoMnemonic(NSString *s) {
	NSMutableString *r = [NSMutableString stringWithCapacity:[s length]];
	for (NSUInteger i = 0; i < [s length]; i++) {
		unichar c = [s characterAtIndex:i];
		if (c == '&') {
			if (i + 1 < [s length] && [s characterAtIndex:i + 1] == '&') { [r appendString:@"&"]; i++; }
			continue;
		}
		[r appendFormat:@"%C", c];
	}
	return r;
}

/* BGR of Windows */
static NSColor *mffColor(int c) {
	return [NSColor colorWithSRGBRed:(c & 255) / 255.0 green:((c >> 8) & 255) / 255.0 blue:((c >> 16) & 255) / 255.0 alpha:1.0];
}

static int mffShift(NSEventModifierFlags f) {
	return ((f & NSEventModifierFlagShift) ? 1 : 0) | ((f & (NSEventModifierFlagCommand | NSEventModifierFlagControl)) ? 2 : 0) | ((f & NSEventModifierFlagOption) ? 4 : 0);
}

/* The key code of Windows (VK_*) of a key of the keyboard of the Mac */
static int mffVirtualKey(NSEvent *e) {
	switch ([e keyCode]) {
	case 36: case 76: return 0x0D;  /* Return, Enter */
	case 48: return 0x09;           /* Tab */
	case 49: return 0x20;           /* Space */
	case 51: return 0x08;           /* Backspace */
	case 53: return 0x1B;           /* Esc */
	case 117: return 0x2E;          /* Delete */
	case 115: return 0x24;          /* Home */
	case 119: return 0x23;          /* End */
	case 116: return 0x21;          /* Page Up */
	case 121: return 0x22;          /* Page Down */
	case 123: return 0x25;          /* Left */
	case 124: return 0x27;          /* Right */
	case 125: return 0x28;          /* Down */
	case 126: return 0x26;          /* Up */
	case 122: return 0x70; case 120: return 0x71; case 99: return 0x72; case 118: return 0x73;
	case 96: return 0x74; case 97: return 0x75; case 98: return 0x76; case 100: return 0x77;
	case 101: return 0x78; case 109: return 0x79; case 103: return 0x7A; case 111: return 0x7B;
	}
	NSString *ch = [[e charactersIgnoringModifiers] uppercaseString];
	if ([ch length] == 1) {
		unichar c = [ch characterAtIndex:0];
		if ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) return c;
		switch (c) {
		case '+': case '=': return 187; case '-': return 189; case ',': return 188; case '.': return 190;
		case '/': return 191; case '`': return 192; case '[': return 219; case '\\': return 220;
		case ']': return 221; case '\'': return 222; case ';': return 186;
		}
	}
	return 0;
}

static void mffEnsureApp(void) {
	static BOOL done;
	if (done) return;
	done = YES;
	[NSApplication sharedApplication];
	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
	/* The menu of the program with Quit (Command+Q) */
	NSMenu *bar = [[NSMenu alloc] init];
	NSMenuItem *appItem = [[NSMenuItem alloc] init];
	[bar addItem:appItem];
	NSMenu *appMenu = [[NSMenu alloc] init];
	NSString *name = [[NSProcessInfo processInfo] processName];
	[appMenu addItemWithTitle:[@"Quit " stringByAppendingString:name] action:@selector(terminate:) keyEquivalent:@"q"];
	[appItem setSubmenu:appMenu];
	[NSApp setMainMenu:bar];
}

/* The view of a control without a view of its own kind (Panel, Picture, ...) and the content view of a window:
   the coordinates are from the top left corner like on Windows, it draws the Canvas of the control and gives the
   mouse and the keys to it */
@interface MffView : NSView {
	NSTrackingArea *trackingArea;
}
@property (nonatomic, strong) NSColor *mffBackColor;
@property (nonatomic, strong) NSImage *mffImage;
@property (nonatomic) BOOL mffImageCenter;
@end

@implementation MffView
- (instancetype)initWithFrame:(NSRect)f {
	self = [super initWithFrame:f];
	/* Since macOS 14 a view can draw out of its bounds: it would paint over the views next to it */
	if (self && [self respondsToSelector:@selector(setClipsToBounds:)]) [self setValue:@YES forKey:@"clipsToBounds"];
	return self;
}
- (BOOL)isFlipped { return YES; }
- (BOOL)acceptsFirstResponder { return mffGetCtrl(self) != NULL; }
- (BOOL)acceptsFirstMouse:(NSEvent *)e { return YES; }
- (void)drawRect:(NSRect)r {
	if (self.mffBackColor) {
		[self.mffBackColor setFill];
		/* The dirty rectangle can be larger than the view */
		NSRectFill(NSIntersectionRect(r, [self bounds]));
	}
	if (self.mffImage) {
		NSSize s = [self.mffImage size];
		NSRect b = [self bounds];
		NSRect to = self.mffImageCenter ? NSMakeRect((b.size.width - s.width) / 2, (b.size.height - s.height) / 2, s.width, s.height) : b;
		[self.mffImage drawInRect:to fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1 respectFlipped:YES hints:nil];
	}
	void *ctrl = mffGetCtrl(self);
	if (ctrl) mffOnPaint(ctrl);
}
- (void)updateTrackingAreas {
	if (trackingArea) [self removeTrackingArea:trackingArea];
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow | NSTrackingInVisibleRect owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
	[super updateTrackingAreas];
}
- (void)mouse:(NSEvent *)e action:(int)action button:(int)button {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl) return;
	NSPoint p = [self convertPoint:[e locationInWindow] fromView:nil];
	mffOnMouse(ctrl, action, button, (int)p.x, (int)p.y, mffShift([e modifierFlags]));
}
- (void)mouseDown:(NSEvent *)e {
	if ([self acceptsFirstResponder]) [[self window] makeFirstResponder:self];
	[self mouse:e action:0 button:0];
	if ([e clickCount] == 2 && mffGetCtrl(self)) mffOnDblClick(mffGetCtrl(self));
}
- (void)mouseUp:(NSEvent *)e {
	[self mouse:e action:1 button:0];
	if (mffGetCtrl(self) && [e clickCount] == 1 && [self superview] != nil && [[self window] contentView] != self) mffOnClick(mffGetCtrl(self));
}
- (void)rightMouseDown:(NSEvent *)e { [self mouse:e action:0 button:1]; }
- (void)rightMouseUp:(NSEvent *)e { [self mouse:e action:1 button:1]; }
- (void)otherMouseDown:(NSEvent *)e { [self mouse:e action:0 button:2]; }
- (void)otherMouseUp:(NSEvent *)e { [self mouse:e action:1 button:2]; }
- (void)mouseMoved:(NSEvent *)e { [self mouse:e action:2 button:-1]; }
- (void)mouseDragged:(NSEvent *)e { [self mouse:e action:2 button:0]; }
- (void)rightMouseDragged:(NSEvent *)e { [self mouse:e action:2 button:1]; }
- (void)mouseExited:(NSEvent *)e { [self mouse:e action:3 button:-1]; }
- (void)scrollWheel:(NSEvent *)e {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl) { [super scrollWheel:e]; return; }
	NSPoint p = [self convertPoint:[e locationInWindow] fromView:nil];
	if ([e scrollingDeltaY] != 0) mffOnMouse(ctrl, 4, [e scrollingDeltaY] > 0 ? 1 : -1, (int)p.x, (int)p.y, mffShift([e modifierFlags]));
	if ([e scrollingDeltaX] != 0) mffOnMouse(ctrl, 5, [e scrollingDeltaX] > 0 ? 1 : -1, (int)p.x, (int)p.y, mffShift([e modifierFlags]));
}
- (void)keyDown:(NSEvent *)e {
	void *ctrl = mffGetCtrl(self);
	int handled = 0;
	if (ctrl) {
		handled = mffOnKey(ctrl, 0, mffVirtualKey(e), mffShift([e modifierFlags]));
		NSString *chars = [e characters];
		if (!handled && [chars length] == 1 && !([e modifierFlags] & NSEventModifierFlagCommand)) {
			unichar c = [chars characterAtIndex:0];
			if (c >= 32 && c != 127 && (c < 0xF700 || c > 0xF8FF)) handled = mffOnKey(ctrl, 2, c, mffShift([e modifierFlags]));
			else if (c == 13 || c == 9 || c == 8 || c == 27) handled = mffOnKey(ctrl, 2, c, mffShift([e modifierFlags]));
		}
	}
	if (!handled) [super keyDown:e];
}
- (void)keyUp:(NSEvent *)e {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl || !mffOnKey(ctrl, 1, mffVirtualKey(e), mffShift([e modifierFlags]))) [super keyUp:e];
}
- (BOOL)becomeFirstResponder {
	void *ctrl = mffGetCtrl(self);
	if (ctrl) mffOnKey(ctrl, 3, 0, 0);
	return YES;
}
- (BOOL)resignFirstResponder {
	void *ctrl = mffGetCtrl(self);
	if (ctrl) mffOnKey(ctrl, 4, 0, 0);
	return YES;
}
@end

/* The actions of the controls and the notifications of the windows, the text fields and the tables */
@interface MffTarget : NSObject <NSWindowDelegate, NSTextFieldDelegate, NSTextViewDelegate, NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSValue *, NSTimer *> *timers;
@end

static MffTarget *mffTarget(void) {
	static MffTarget *t;
	if (!t) {
		t = [[MffTarget alloc] init];
		t.timers = [NSMutableDictionary dictionary];
	}
	return t;
}

/* The checked rows of a CheckedListBox (nil - a list without check boxes) */
static NSMutableIndexSet *mffChecks(id table) {
	NSMutableIndexSet *s = objc_getAssociatedObject(table, &kMffChecksKey);
	if (!s) {
		s = [NSMutableIndexSet indexSet];
		objc_setAssociatedObject(table, &kMffChecksKey, s, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return s;
}

/* The text of a cell without Chr(1) picture Chr(1) */
static NSString *mffCellText(NSString *s) {
	if ([s hasPrefix:@"\x01"]) {
		NSRange end = [s rangeOfString:@"\x01" options:0 range:NSMakeRange(1, [s length] - 1)];
		if (end.location != NSNotFound) return [s substringFromIndex:end.location + 1];
	}
	return s;
}

/* The items of a list (NSTableView of a ListControl) */
static char kMffItemsKey;
static NSMutableArray<NSString *> *mffItems(id table) {
	NSMutableArray *a = objc_getAssociatedObject(table, &kMffItemsKey);
	if (!a) {
		a = [NSMutableArray array];
		objc_setAssociatedObject(table, &kMffItemsKey, a, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return a;
}

@implementation MffTarget
- (void)action:(id)sender {
	void *ctrl = mffGetCtrl(sender);
	if (!ctrl) return;
	if ([sender isKindOfClass:[NSPopUpButton class]] || [sender isKindOfClass:[NSSlider class]]) {
		mffOnChange(ctrl, [sender isKindOfClass:[NSSlider class]] ? [sender intValue] : (int)[sender indexOfSelectedItem]);
		return;
	}
	mffOnClick(ctrl);
}
- (BOOL)windowShouldClose:(NSWindow *)w {
	void *ctrl = mffGetCtrl(w);
	if (!ctrl) return YES;
	/* The form decides (OnClose): it hides the window itself */
	mffOnClose(ctrl);
	return NO;
}
- (void)windowDidResize:(NSNotification *)n {
	NSWindow *w = [n object];
	void *ctrl = mffGetCtrl(w);
	if (!ctrl || mffSettingFrame) return;
	NSRect f = [w frame];
	NSRect s = [[[NSScreen screens] firstObject] frame];
	mffInWindowEvent = YES;
	/* Resized at its left or top edge the window moved too */
	mffOnMove(ctrl, (int)f.origin.x, (int)(s.size.height - f.origin.y - f.size.height));
	mffOnResize(ctrl, (int)f.size.width, (int)f.size.height);
	mffInWindowEvent = NO;
}
- (void)windowDidMove:(NSNotification *)n {
	NSWindow *w = [n object];
	void *ctrl = mffGetCtrl(w);
	if (!ctrl || mffSettingFrame) return;
	NSRect f = [w frame];
	NSRect s = [[[NSScreen screens] firstObject] frame];
	mffInWindowEvent = YES;
	mffOnMove(ctrl, (int)f.origin.x, (int)(s.size.height - f.origin.y - f.size.height));
	mffInWindowEvent = NO;
}
- (void)controlTextDidChange:(NSNotification *)n {
	void *ctrl = mffGetCtrl([n object]);
	if (ctrl) mffOnChange(ctrl, 0);
}
- (void)textDidChange:(NSNotification *)n {
	/* The NSTextView of a TextArea: the control is the one of its scroll view */
	NSView *v = [n object];
	while (v && !mffGetCtrl(v)) v = [v superview];
	if (v) mffOnChange(mffGetCtrl(v), 0);
}
- (void)comboBoxSelectionDidChange:(NSNotification *)n {
	NSComboBox *c = [n object];
	void *ctrl = mffGetCtrl(c);
	if (ctrl) mffOnChange(ctrl, (int)[c indexOfSelectedItem]);
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)t { return [mffItems(t) count]; }
- (id)tableView:(NSTableView *)t objectValueForTableColumn:(NSTableColumn *)c row:(NSInteger)row {
	NSArray *a = mffItems(t);
	if (row >= (NSInteger)[a count]) return @"";
	id item = a[row];
	if ([item isKindOfClass:[NSArray class]]) {
		NSUInteger i = [[t tableColumns] indexOfObject:c];
		return i < [item count] ? mffCellText(item[i]) : @"";
	}
	if (objc_getAssociatedObject(t, &kMffChecksKey)) return [([mffChecks(t) containsIndex:row] ? @"\u2611 " : @"\u2610 ") stringByAppendingString:item];
	return item;
}
- (void)tableViewSelectionDidChange:(NSNotification *)n {
	if (mffSilent) return;
	NSTableView *t = [n object];
	NSView *v = [t enclosingScrollView];
	void *ctrl = v ? mffGetCtrl(v) : NULL;
	if (objc_getAssociatedObject(t, &kMffFileViewKey)) { mffFileViewChoose(t, v, [t selectedRow], NO); return; }
	if (ctrl) mffOnChange(ctrl, (int)[t selectedRow]);
}
/* A click on a row of a CheckedListBox changes its check box */
- (void)tableClick:(NSTableView *)t {
	NSInteger row = [t clickedRow];
	if (row < 0 || !objc_getAssociatedObject(t, &kMffChecksKey)) return;
	if ([mffChecks(t) containsIndex:row]) [mffChecks(t) removeIndex:row]; else [mffChecks(t) addIndex:row];
	[t reloadData];
	void *ctrl = mffGetCtrl([t enclosingScrollView]);
	if (ctrl) mffOnChange(ctrl, (int)row);
}
- (void)tabsClick:(NSSegmentedControl *)s {
	void *ctrl = mffGetCtrl([s superview]);
	if (ctrl) mffOnChange(ctrl, (int)[s selectedSegment]);
}
- (void)buttonsClick:(NSButton *)b {
	void *ctrl = mffGetCtrl([b superview]);
	if (ctrl) mffOnChange(ctrl, (int)[b tag]);
}
- (void)popupChosen:(NSMenuItem *)m {
	mffPopupResult = (int)[m tag];
}
- (void)menuBarChosen:(NSMenuItem *)m {
	mffOnMenu((int)[m tag]);
}
- (void)tableDoubleClick:(NSTableView *)t {
	NSView *v = [t enclosingScrollView];
	void *ctrl = v ? mffGetCtrl(v) : NULL;
	if (!ctrl) return;
	if (objc_getAssociatedObject(t, &kMffFileViewKey)) { mffFileViewChoose(t, v, [t clickedRow], YES); return; }
	/* ListView, TreeView: the double click is a change with TableDblClick */
	if (objc_getAssociatedObject(t, &kMffTableKey)) {
		mffDblClick = 1;
		mffOnChange(ctrl, (int)[t clickedRow]);
		mffDblClick = 0;
	}
	mffOnDblClick(ctrl);
}
- (void)timerFired:(NSTimer *)t {
	mffOnTimer([[t userInfo] pointerValue]);
}
@end

/* The object of a handle: the NSWindow of a form or a view */
static id mffObj(void *view) {
	return (__bridge id)view;
}

static NSWindow *mffWindow(void *view) {
	id o = mffObj(view);
	return [o isKindOfClass:[NSWindow class]] ? o : nil;
}

static NSView *mffView(void *view) {
	id o = mffObj(view);
	return [o isKindOfClass:[NSView class]] ? o : nil;
}

/* The table of a ListControl in its scroll view */
static NSTableView *mffTable(void *view) {
	NSView *v = mffView(view);
	if ([v isKindOfClass:[NSScrollView class]] && [[(NSScrollView *)v documentView] isKindOfClass:[NSTableView class]]) return [(NSScrollView *)v documentView];
	return nil;
}

static NSTextView *mffTextView(void *view) {
	NSView *v = mffView(view);
	if ([v isKindOfClass:[NSScrollView class]] && [[(NSScrollView *)v documentView] isKindOfClass:[NSTextView class]]) return [(NSScrollView *)v documentView];
	return nil;
}

/* A GroupBox: the coordinates of its controls are from the top left corner of its frame like on Windows (the content
   view of NSBox is smaller than the box by the title and the margins) */
@interface MffGroupView : MffView
@property (nonatomic, copy) NSString *mffTitle;
@end

@implementation MffGroupView
- (void)drawRect:(NSRect)r {
	/* First: the color of the view is under the frame */
	[super drawRect:r];
	NSDictionary *a = @{NSFontAttributeName: [NSFont systemFontOfSize:[NSFont smallSystemFontSize]], NSForegroundColorAttributeName: [NSColor labelColor]};
	NSSize s = self.mffTitle ? [self.mffTitle sizeWithAttributes:a] : NSZeroSize;
	NSRect box = NSInsetRect(NSMakeRect(0, s.height / 2, [self bounds].size.width, [self bounds].size.height - s.height / 2), 0.5, 0.5);
	[[NSColor separatorColor] setStroke];
	[[NSBezierPath bezierPathWithRoundedRect:box xRadius:5 yRadius:5] stroke];
	if ([self.mffTitle length]) {
		[(self.mffBackColor ?: [NSColor windowBackgroundColor]) setFill];
		NSRectFill(NSMakeRect(8, 0, s.width + 6, s.height));
		[self.mffTitle drawAtPoint:NSMakePoint(11, 0) withAttributes:a];
	}
}
@end

/* A TabControl: the strip of its tabs, the pages are its child controls */
@interface MffTabsView : MffView
@property (nonatomic, strong) NSSegmentedControl *segments;
@property (nonatomic) int tabPosition;
- (void)layoutStrip;
@end

@implementation MffTabsView
- (void)layoutStrip {
	/* 3 - at the bottom; NSSegmentedControl has no vertical form: the tabs on the left and on the right are at the top */
	NSRect b = [self bounds];
	CGFloat h = mffTabsStripHeight();
	[self.segments setFrame:NSMakeRect(0, self.tabPosition == 3 ? b.size.height - h : 0, b.size.width, h)];
}
- (void)setFrameSize:(NSSize)s {
	[super setFrameSize:s];
	[self layoutStrip];
}
@end

/* A ToolBar, a ToolPalette: its row of buttons */
@interface MffButtonsView : MffView
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) CGFloat contentWidth;
@end

@implementation MffButtonsView
@end

void *mffViewCreate(const char *kind, void *ctrl) {
	mffEnsureApp();
	NSString *k = mffStr(kind);
	NSRect r = NSMakeRect(0, 0, 100, 30);
	id obj = nil;
	MffTarget *t = mffTarget();
	if ([k isEqualToString:@"Form"]) {
		NSWindow *w = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 350, 300) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable backing:NSBackingStoreBuffered defer:NO];
		[w setReleasedWhenClosed:NO];
		MffView *content = [[MffView alloc] initWithFrame:[[w contentView] frame]];
		mffSetCtrl(content, ctrl);
		[w setContentView:content];
		[w setDelegate:t];
		obj = w;
	} else if ([k isEqualToString:@"CommandButton"] || [k isEqualToString:@"CheckBox"] || [k isEqualToString:@"RadioButton"]) {
		NSButton *b = [[NSButton alloc] initWithFrame:r];
		if ([k isEqualToString:@"CheckBox"]) [b setButtonType:NSButtonTypeSwitch];
		else if ([k isEqualToString:@"RadioButton"]) [b setButtonType:NSButtonTypeRadio];
		else [b setBezelStyle:NSBezelStyleRounded];
		[b setTitle:@""];
		[b setTarget:t];
		[b setAction:@selector(action:)];
		obj = b;
	} else if ([k isEqualToString:@"Label"] || [k isEqualToString:@"LinkLabel"]) {
		NSTextField *f = [NSTextField labelWithString:@""];
		[f setFrame:r];
		[[f cell] setWraps:YES];
		[f setLineBreakMode:NSLineBreakByWordWrapping];
		obj = f;
	} else if ([k isEqualToString:@"TextBox"]) {
		NSTextField *f = [[NSTextField alloc] initWithFrame:r];
		[f setDelegate:t];
		[[f cell] setScrollable:YES];
		obj = f;
	} else if ([k isEqualToString:@"TextArea"] || [k isEqualToString:@"RichTextBox"]) {
		NSScrollView *s = [[NSScrollView alloc] initWithFrame:r];
		[s setHasVerticalScroller:YES];
		[s setBorderType:NSBezelBorder];
		NSTextView *tv = [[NSTextView alloc] initWithFrame:[[s contentView] bounds]];
		[tv setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		[tv setRichText:NO];
		[tv setDelegate:t];
		[s setDocumentView:tv];
		obj = s;
	} else if ([k isEqualToString:@"GroupBox"]) {
		obj = [[MffGroupView alloc] initWithFrame:r];
	} else if ([k isEqualToString:@"TabControl"]) {
		MffTabsView *v = [[MffTabsView alloc] initWithFrame:r];
		v.segments = [[NSSegmentedControl alloc] initWithFrame:NSZeroRect];
		[v.segments setTrackingMode:NSSegmentSwitchTrackingSelectOne];
		[v.segments setSegmentStyle:NSSegmentStyleTexturedSquare];
		[v.segments setTarget:t];
		[v.segments setAction:@selector(tabsClick:)];
		[v addSubview:v.segments];
		[v layoutStrip];
		obj = v;
	} else if ([k isEqualToString:@"ToolBar"] || [k isEqualToString:@"ToolPalette"]) {
		MffButtonsView *v = [[MffButtonsView alloc] initWithFrame:r];
		v.buttons = [NSMutableArray array];
		obj = v;
	} else if ([k isEqualToString:@"WebBrowser"]) {
		obj = [[WKWebView alloc] initWithFrame:r configuration:[[WKWebViewConfiguration alloc] init]];
	} else if ([k isEqualToString:@"ListControl"] || [k isEqualToString:@"CheckedListBox"] || [k isEqualToString:@"ListView"] || [k isEqualToString:@"TreeView"] || [k isEqualToString:@"TreeListView"] || [k isEqualToString:@"GridData"] || [k isEqualToString:@"Grid"] || [k isEqualToString:@"OpenFileControl"]) {
		NSScrollView *s = [[NSScrollView alloc] initWithFrame:r];
		[s setHasVerticalScroller:YES];
		[s setBorderType:NSBezelBorder];
		NSTableView *tv = [[NSTableView alloc] initWithFrame:[[s contentView] bounds]];
		NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:@"mff"];
		[col setResizingMask:NSTableColumnAutoresizingMask];
		[tv addTableColumn:col];
		[tv setHeaderView:nil];
		[tv setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
		[tv setDataSource:t];
		[tv setDelegate:t];
		[tv setTarget:t];
		[tv setDoubleAction:@selector(tableDoubleClick:)];
		if ([k isEqualToString:@"CheckedListBox"]) {
			(void)mffChecks(tv);
			[tv setAction:@selector(tableClick:)];
		}
		[s setDocumentView:tv];
		obj = s;
	} else if ([k isEqualToString:@"ComboBoxEdit"] || [k isEqualToString:@"ComboBoxEx"]) {
		NSPopUpButton *p = [[NSPopUpButton alloc] initWithFrame:r pullsDown:NO];
		[p setTarget:t];
		[p setAction:@selector(action:)];
		obj = p;
	} else if ([k isEqualToString:@"ComboBox"]) {
		NSComboBox *c = [[NSComboBox alloc] initWithFrame:r];
		[c setDelegate:t];
		obj = c;
	} else if ([k isEqualToString:@"ProgressBar"]) {
		NSProgressIndicator *p = [[NSProgressIndicator alloc] initWithFrame:r];
		[p setIndeterminate:NO];
		[p setMinValue:0];
		[p setMaxValue:100];
		obj = p;
	} else if ([k isEqualToString:@"TrackBar"]) {
		NSSlider *s = [[NSSlider alloc] initWithFrame:r];
		[s setMinValue:0];
		[s setMaxValue:10];
		[s setTarget:t];
		[s setAction:@selector(action:)];
		obj = s;
	} else {
		obj = [[MffView alloc] initWithFrame:r];
	}
	mffSetCtrl(obj, ctrl);
	return (__bridge_retained void *)obj;
}

void mffViewFree(void *view) {
	if (!view) return;
	id o = (__bridge_transfer id)view;
	mffSetCtrl(o, NULL);
	if ([o isKindOfClass:[NSWindow class]]) {
		NSWindow *w = o;
		if ([NSApp modalWindow] == w) [NSApp stopModal];
		mffSetCtrl([w contentView], NULL);
		[w setDelegate:nil];
		[w orderOut:nil];
		[w close];
	} else if ([o isKindOfClass:[NSView class]]) {
		[(NSView *)o removeFromSuperview];
	}
}

void *mffViewControl(void *view) {
	return view ? mffGetCtrl(mffObj(view)) : NULL;
}

void *mffViewLayout(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSWindow class]]) return (__bridge void *)[(NSWindow *)o contentView];
	if ([o isKindOfClass:[NSBox class]]) return (__bridge void *)[(NSBox *)o contentView];
	return view;
}

void mffViewAddChild(void *parent, void *child) {
	NSView *p = (__bridge NSView *)mffViewLayout(parent);
	NSView *c = mffView(child);
	if (p && c && [c superview] != p) [p addSubview:c];
}

void mffViewSetBounds(void *view, int x, int y, int w, int h) {
	NSWindow *win = mffWindow(view);
	if (win) {
		if (mffInWindowEvent) return;
		/* The outer frame from the top left corner of the main screen like on Windows */
		NSRect s = [[[NSScreen screens] firstObject] frame];
		NSRect f = NSMakeRect(x, s.size.height - y - h, w, h);
		if (NSEqualRects(f, [win frame])) return;
		mffSettingFrame = YES;
		[win setFrame:f display:YES];
		mffSettingFrame = NO;
		return;
	}
	NSView *v = mffView(view);
	if (!v) return;
	/* The parent of the view is flipped (MffView): the coordinates are from its top left corner */
	NSRect f = NSMakeRect(x, y, w, h);
	if (!NSEqualRects(f, [v frame])) [v setFrame:f];
}

int mffViewClientSize(void *view, int vertical) {
	NSView *v = (__bridge NSView *)mffViewLayout(view);
	if (![v isKindOfClass:[NSView class]]) return -1;
	return (int)(vertical ? [v bounds].size.height : [v bounds].size.width);
}

void mffViewSetText(void *view, const char *text) {
	id o = mffObj(view);
	NSString *s = mffStr(text);
	if ([o isKindOfClass:[NSWindow class]]) [(NSWindow *)o setTitle:s];
	else if ([o isKindOfClass:[NSButton class]] && ![o isKindOfClass:[NSPopUpButton class]]) [(NSButton *)o setTitle:mffNoMnemonic(s)];
	else if ([o isKindOfClass:[MffGroupView class]]) { ((MffGroupView *)o).mffTitle = mffNoMnemonic(s); [(NSView *)o setNeedsDisplay:YES]; }
	else if ([o isKindOfClass:[NSTextField class]]) [(NSTextField *)o setStringValue:[(NSTextField *)o isEditable] ? s : mffNoMnemonic(s)];
	else if (mffTextView(view)) [mffTextView(view) setString:s];
}

char *mffViewGetText(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSWindow class]]) return mffDup([(NSWindow *)o title]);
	if ([o isKindOfClass:[NSPopUpButton class]]) return mffDup([(NSPopUpButton *)o titleOfSelectedItem]);
	if ([o isKindOfClass:[NSButton class]]) return mffDup([(NSButton *)o title]);
	if ([o isKindOfClass:[MffGroupView class]]) return mffDup(((MffGroupView *)o).mffTitle);
	if ([o isKindOfClass:[NSTextField class]]) return mffDup([(NSTextField *)o stringValue]);
	if (mffTextView(view)) return mffDup([mffTextView(view) string]);
	return mffDup(@"");
}

void mffViewSetHint(void *view, const char *text) {
	NSView *v = mffView(view);
	if (v) [v setToolTip:[mffStr(text) length] ? mffStr(text) : nil];
}

void mffViewSetVisible(void *view, int value) {
	NSWindow *w = mffWindow(view);
	if (w) {
		if (value) [w makeKeyAndOrderFront:nil]; else [w orderOut:nil];
		return;
	}
	[mffView(view) setHidden:!value];
}

void mffViewSetEnabled(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSControl class]]) [(NSControl *)o setEnabled:value != 0];
	else if (mffTable(view)) [mffTable(view) setEnabled:value != 0];
	else if (mffTextView(view)) [mffTextView(view) setEditable:value != 0];
}

void mffViewSetFocus(void *view) {
	NSWindow *w = mffWindow(view);
	if (w) { [w makeKeyAndOrderFront:nil]; return; }
	NSView *v = mffView(view);
	if (mffTable(view)) v = mffTable(view);
	else if (mffTextView(view)) v = mffTextView(view);
	[[v window] makeFirstResponder:v];
}

int mffViewHasFocus(void *view) {
	NSWindow *w = mffWindow(view);
	if (w) return [w isKeyWindow];
	NSView *v = mffView(view);
	id r = [[v window] firstResponder];
	if (!r) return 0;
	if (r == v) return 1;
	/* The field editor of a text field */
	if ([r isKindOfClass:[NSText class]] && [(NSText *)r delegate] == (id)v) return 1;
	return [r isKindOfClass:[NSView class]] && [(NSView *)r isDescendantOf:v];
}

void mffViewSetBackColor(void *view, int color) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSWindow class]]) {
		[(NSWindow *)o setBackgroundColor:color < 0 ? [NSColor windowBackgroundColor] : mffColor(color)];
		o = [(NSWindow *)o contentView];
	}
	if ([o isKindOfClass:[MffView class]]) {
		((MffView *)o).mffBackColor = color < 0 ? nil : mffColor(color);
		[(NSView *)o setNeedsDisplay:YES];
	} else if ([o isKindOfClass:[NSTextField class]]) {
		NSTextField *f = o;
		if (color < 0) {
			[f setDrawsBackground:[f isEditable]];
			[f setBackgroundColor:[NSColor textBackgroundColor]];
		} else {
			[f setDrawsBackground:YES];
			[f setBackgroundColor:mffColor(color)];
		}
	} else if ([o isKindOfClass:[NSBox class]]) {
		NSBox *b = o;
		if (color >= 0) { [b setBoxType:NSBoxCustom]; [b setFillColor:mffColor(color)]; }
	} else if (mffTextView(view)) {
		[mffTextView(view) setBackgroundColor:color < 0 ? [NSColor textBackgroundColor] : mffColor(color)];
	} else if ([o isKindOfClass:[NSButton class]] && color >= 0) {
		[(NSButton *)o setBezelColor:mffColor(color)];
	}
}

void mffViewSetForeColor(void *view, int color) {
	id o = mffObj(view);
	NSColor *c = color < 0 ? nil : mffColor(color);
	if ([o isKindOfClass:[NSTextField class]]) [(NSTextField *)o setTextColor:c ?: [NSColor controlTextColor]];
	else if (mffTextView(view)) [mffTextView(view) setTextColor:c ?: [NSColor textColor]];
	else if ([o isKindOfClass:[NSButton class]] && ![o isKindOfClass:[NSPopUpButton class]] && c) {
		NSButton *b = o;
		NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:[b title]];
		[s addAttribute:NSForegroundColorAttributeName value:c range:NSMakeRange(0, [s length])];
		[b setAttributedTitle:s];
	}
}

void mffViewSetFont(void *view, const char *name, float size, int style) {
	id o = mffObj(view);
	if (mffTextView(view)) o = mffTextView(view);
	if (![o respondsToSelector:@selector(setFont:)]) return;
	CGFloat sz = size > 0 ? size * 96.0 / 72.0 : [NSFont systemFontSize];
	NSFont *f = (name && *name) ? [NSFont fontWithName:mffStr(name) size:sz] : nil;
	if (!f) f = [NSFont systemFontOfSize:sz];
	NSFontManager *m = [NSFontManager sharedFontManager];
	if (style & 1) f = [m convertFont:f toHaveTrait:NSBoldFontMask];
	if (style & 2) f = [m convertFont:f toHaveTrait:NSItalicFontMask];
	[o setFont:f];
}

void mffViewZOrder(void *view, int toFront) {
	NSView *v = mffView(view);
	NSView *p = [v superview];
	if (!p) return;
	[v removeFromSuperviewWithoutNeedingDisplay];
	[p addSubview:v positioned:toFront ? NSWindowAbove : NSWindowBelow relativeTo:nil];
}

void mffViewRepaint(void *view) {
	NSWindow *w = mffWindow(view);
	if (w) { [[w contentView] setNeedsDisplay:YES]; return; }
	[mffView(view) setNeedsDisplay:YES];
}

void mffViewSetChecked(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSButton class]]) {
		NSButton *b = o;
		if (value == 2) [b setAllowsMixedState:YES];
		[b setState:value == 1 ? NSControlStateValueOn : (value == 2 ? NSControlStateValueMixed : NSControlStateValueOff)];
	}
}

int mffViewGetChecked(void *view) {
	id o = mffObj(view);
	if (![o isKindOfClass:[NSButton class]]) return 0;
	NSControlStateValue s = [(NSButton *)o state];
	return s == NSControlStateValueOn ? 1 : (s == NSControlStateValueMixed ? 2 : 0);
}

void mffViewSetReadOnly(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSTextField class]]) [(NSTextField *)o setEditable:!value];
	else if (mffTextView(view)) [mffTextView(view) setEditable:!value];
}

void mffViewSetAlignment(void *view, int value) {
	id o = mffObj(view);
	NSTextAlignment a = value == 1 ? NSTextAlignmentCenter : (value == 2 ? NSTextAlignmentRight : NSTextAlignmentLeft);
	if ([o isKindOfClass:[NSTextField class]]) [(NSTextField *)o setAlignment:a];
	else if (mffTextView(view)) [mffTextView(view) setAlignment:a];
}

void mffTextSetSelection(void *view, int start, int length) {
	id o = mffObj(view);
	NSText *t = mffTextView(view);
	if (!t && [o isKindOfClass:[NSTextField class]]) t = [(NSTextField *)o currentEditor];
	if (t) [t setSelectedRange:NSMakeRange(start, length)];
}

int mffTextGetSelection(void *view, int getLength) {
	id o = mffObj(view);
	NSText *t = mffTextView(view);
	if (!t && [o isKindOfClass:[NSTextField class]]) t = [(NSTextField *)o currentEditor];
	if (!t) return 0;
	NSRange r = [t selectedRange];
	return (int)(getLength ? r.length : r.location);
}

void mffTextSetPassword(void *view, int value) {
	/* NSSecureTextField is another class: the TextBox of a password is made with the kind "PasswordBox" */
	(void)view; (void)value;
}

void mffListInsert(void *view, int index, const char *text) {
	id o = mffObj(view);
	NSString *s = mffStr(text);
	NSTableView *t = mffTable(view);
	if (t) {
		NSMutableArray *a = mffItems(t);
		if (index < 0 || index > (int)[a count]) [a addObject:s]; else [a insertObject:s atIndex:index];
		[t reloadData];
	} else if ([o isKindOfClass:[NSPopUpButton class]]) {
		NSPopUpButton *p = o;
		/* The titles of the items of NSPopUpButton must be different: the item is made with an empty title */
		NSInteger i = (index < 0 || index > [p numberOfItems]) ? [p numberOfItems] : index;
		[p insertItemWithTitle:@"" atIndex:i];
		[[p itemAtIndex:i] setTitle:s];
	} else if ([o isKindOfClass:[NSComboBox class]]) {
		NSComboBox *c = o;
		if (index < 0 || index > [c numberOfItems]) [c addItemWithObjectValue:s]; else [c insertItemWithObjectValue:s atIndex:index];
	}
}

void mffListRemove(void *view, int index) {
	id o = mffObj(view);
	NSTableView *t = mffTable(view);
	if (t) {
		NSMutableArray *a = mffItems(t);
		if (index >= 0 && index < (int)[a count]) [a removeObjectAtIndex:index];
		[t reloadData];
	} else if ([o isKindOfClass:[NSPopUpButton class]]) {
		if (index >= 0 && index < [(NSPopUpButton *)o numberOfItems]) [(NSPopUpButton *)o removeItemAtIndex:index];
	} else if ([o isKindOfClass:[NSComboBox class]]) {
		if (index >= 0 && index < [(NSComboBox *)o numberOfItems]) [(NSComboBox *)o removeItemAtIndex:index];
	}
}

void mffListClear(void *view) {
	id o = mffObj(view);
	NSTableView *t = mffTable(view);
	if (t) { [mffItems(t) removeAllObjects]; [t reloadData]; }
	else if ([o isKindOfClass:[NSPopUpButton class]]) [(NSPopUpButton *)o removeAllItems];
	else if ([o isKindOfClass:[NSComboBox class]]) [(NSComboBox *)o removeAllItems];
}

int mffListGetIndex(void *view) {
	id o = mffObj(view);
	NSTableView *t = mffTable(view);
	if (t) return (int)[t selectedRow];
	if ([o isKindOfClass:[NSPopUpButton class]]) return (int)[(NSPopUpButton *)o indexOfSelectedItem];
	if ([o isKindOfClass:[NSComboBox class]]) return (int)[(NSComboBox *)o indexOfSelectedItem];
	return -1;
}

void mffListSetIndex(void *view, int index) {
	id o = mffObj(view);
	NSTableView *t = mffTable(view);
	if (t) {
		if (index < 0) { mffSilent = YES; [t deselectAll:nil]; mffSilent = NO; }
		else {
			/* Like the messages of Windows: only a change of the user raises the event */
			mffSilent = YES;
			[t selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
			mffSilent = NO;
			[t scrollRowToVisible:index];
		}
	} else if ([o isKindOfClass:[NSPopUpButton class]]) [(NSPopUpButton *)o selectItemAtIndex:index];
	else if ([o isKindOfClass:[NSComboBox class]]) {
		if (index < 0) [(NSComboBox *)o deselectItemAtIndex:[(NSComboBox *)o indexOfSelectedItem]];
		else [(NSComboBox *)o selectItemAtIndex:index];
	}
}

void mffRangeSet(void *view, int minValue, int maxValue) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSProgressIndicator class]]) { [(NSProgressIndicator *)o setMinValue:minValue]; [(NSProgressIndicator *)o setMaxValue:maxValue]; }
	else if ([o isKindOfClass:[NSSlider class]]) { [(NSSlider *)o setMinValue:minValue]; [(NSSlider *)o setMaxValue:maxValue]; }
}

void mffPositionSet(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffTabsView class]]) { if (value >= 0 && value < [((MffTabsView *)o).segments segmentCount]) [((MffTabsView *)o).segments setSelectedSegment:value]; }
	else if ([o isKindOfClass:[NSProgressIndicator class]]) [(NSProgressIndicator *)o setDoubleValue:value];
	else if ([o isKindOfClass:[NSSlider class]]) [(NSSlider *)o setIntValue:value];
}

int mffPositionGet(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffTabsView class]]) return (int)[((MffTabsView *)o).segments selectedSegment];
	if ([o isKindOfClass:[NSProgressIndicator class]]) return (int)[(NSProgressIndicator *)o doubleValue];
	if ([o isKindOfClass:[NSSlider class]]) return [(NSSlider *)o intValue];
	return 0;
}

void mffFormShow(void *view, int modal) {
	NSWindow *w = mffWindow(view);
	if (!w) return;
	[w makeKeyAndOrderFront:nil];
	if (modal) [NSApp runModalForWindow:w];
}

void mffFormHide(void *view) {
	NSWindow *w = mffWindow(view);
	if (!w) return;
	if ([NSApp modalWindow] == w) [NSApp stopModal];
	[w orderOut:nil];
}

void mffFormSetState(void *view, int state) {
	NSWindow *w = mffWindow(view);
	if (!w) return;
	if (state == 1) [w miniaturize:nil];
	else {
		if ([w isMiniaturized]) [w deminiaturize:nil];
		if ((state == 2) != [w isZoomed]) [w zoom:nil];
	}
}

void mffFormSetBorder(void *view, int style) {
	NSWindow *w = mffWindow(view);
	if (!w) return;
	NSWindowStyleMask m;
	switch (style) {
	case 0: m = NSWindowStyleMaskBorderless; break;
	case 1: case 3: m = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable; break;
	case 6: m = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable; break;
	default: m = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable; break;
	}
	if ([w styleMask] == m) return;
	NSRect f = [w frame];
	mffSettingFrame = YES;
	[w setStyleMask:m];
	[w setFrame:f display:YES];
	mffSettingFrame = NO;
}

void mffFormSetMainMenu(void *view, const char *items) {
	(void)view; (void)items;
}

int mffScreenSize(int vertical) {
	mffEnsureApp();
	NSRect s = [[[NSScreen screens] firstObject] frame];
	return (int)(vertical ? s.size.height : s.size.width);
}

/* The test of a program without a screen recording (CI): MFF_SNAPSHOT=Name saves the windows as Name_1.png, ...
   two seconds (MFF_SNAPSHOT_DELAY) after the start; MFF_CLICK=Caption clicks the button with that caption then, and the windows (a
   message box too) are saved again as Name_2_*.png; then the program ends */
static void mffSnapshot(NSString *base, int step) {
	int n = 0;
	for (NSWindow *w in [NSApp windows]) {
		if (![w isVisible]) continue;
		NSView *v = [[w contentView] superview] ?: [w contentView];
		NSBitmapImageRep *rep = [v bitmapImageRepForCachingDisplayInRect:[v bounds]];
		if (!rep) continue;
		[v cacheDisplayInRect:[v bounds] toBitmapImageRep:rep];
		NSData *png = [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
		[png writeToFile:[NSString stringWithFormat:@"%@_%d_%d.png", base, step, ++n] atomically:YES];
	}
}

static NSButton *mffFindButton(NSView *v, NSString *title) {
	if ([v isKindOfClass:[NSButton class]] && [mffNoMnemonic([(NSButton *)v title]) isEqualToString:title]) return (NSButton *)v;
	for (NSView *s in [v subviews]) {
		NSButton *b = mffFindButton(s, title);
		if (b) return b;
	}
	return nil;
}

static void mffStartSnapshotTest(void) {
	const char *snap = getenv("MFF_SNAPSHOT");
	if (!snap || !*snap) return;
	NSString *base = mffStr(snap);
	NSString *click = mffStr(getenv("MFF_CLICK"));
	__block int step = 0;
	const char *delay = getenv("MFF_SNAPSHOT_DELAY");
	NSTimer *tm = [NSTimer timerWithTimeInterval:(delay && atof(delay) > 0) ? atof(delay) : 2.0 repeats:YES block:^(NSTimer *t) {
		step++;
		mffSnapshot(base, step);
		if (step == 1 && [click length]) {
			for (NSWindow *w in [NSApp windows]) {
				NSButton *b = mffFindButton([w contentView], click);
				if (b) {
					/* After this timer: the click can open a modal loop (MsgBox) where the timer runs again */
					dispatch_async(dispatch_get_main_queue(), ^{ [b performClick:nil]; });
					return;
				}
			}
			fprintf(stderr, "MFF_CLICK: no button \"%s\"\n", [click UTF8String]);
		}
		[t invalidate];
		exit(0);
	}];
	[[NSRunLoop currentRunLoop] addTimer:tm forMode:NSRunLoopCommonModes];
}

void mffAppRun(void) {
	mffEnsureApp();
	[NSApp activateIgnoringOtherApps:YES];
	mffStartSnapshotTest();
	[NSApp run];
}

void mffAppTerminate(void) {
	/* The run loop stops: mffAppRun returns and the program ends its main like on the other systems */
	[NSApp stop:nil];
	NSEvent *e = [NSEvent otherEventWithType:NSEventTypeApplicationDefined location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0 context:nil subtype:0 data1:0 data2:0];
	[NSApp postEvent:e atStart:YES];
}

void mffAppDoEvents(void) {
	mffEnsureApp();
	NSEvent *e;
	while ((e = [NSApp nextEventMatchingMask:NSEventMaskAny untilDate:[NSDate distantPast] inMode:NSDefaultRunLoopMode dequeue:YES])) {
		[NSApp sendEvent:e];
	}
	[NSApp updateWindows];
}

void mffAppSetDarkMode(int value) {
	mffEnsureApp();
	if (value < 0) [NSApp setAppearance:nil];
	else [NSApp setAppearance:[NSAppearance appearanceNamed:value ? NSAppearanceNameDarkAqua : NSAppearanceNameAqua]];
}

int mffAppDarkMode(void) {
	mffEnsureApp();
	NSAppearanceName n = [[NSApp effectiveAppearance] bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
	return [n isEqualToString:NSAppearanceNameDarkAqua];
}

int mffMessageBox(const char *msg, const char *caption, int messageType, int buttonsType) {
	mffEnsureApp();
	NSAlert *a = [[NSAlert alloc] init];
	/* A message box always has a title: App.Title can be empty */
	[a setMessageText:(caption && *caption) ? mffStr(caption) : [[NSProcessInfo processInfo] processName]];
	[a setInformativeText:mffStr(msg)];
	/* A program without a bundle would have the icon of a folder */
	if (messageType != 1 && messageType != 3) [a setIcon:[NSImage imageNamed:NSImageNameInfo]];
	[a setAlertStyle:messageType == 3 ? NSAlertStyleCritical : (messageType == 1 ? NSAlertStyleWarning : NSAlertStyleInformational)];
	/* The results of the buttons in their order (MessageResult) */
	int results[3] = {4, 1, 1};
	switch (buttonsType) {
	case 2: [a addButtonWithTitle:@"Yes"]; [a addButtonWithTitle:@"No"]; results[0] = 6; results[1] = 3; break;
	case 3: [a addButtonWithTitle:@"Yes"]; [a addButtonWithTitle:@"No"]; [a addButtonWithTitle:@"Cancel"]; results[0] = 6; results[1] = 3; results[2] = 1; break;
	case 4: [a addButtonWithTitle:@"OK"]; [a addButtonWithTitle:@"Cancel"]; results[0] = 4; results[1] = 1; break;
	default: [a addButtonWithTitle:@"OK"]; results[0] = 4; break;
	}
	[NSApp activateIgnoringOtherApps:YES];
	NSModalResponse r = [a runModal];
	int i = (int)(r - NSAlertFirstButtonReturn);
	return (i >= 0 && i < 3) ? results[i] : 1;
}

void mffTimerStart(void *id_, int interval) {
	mffTimerStop(id_);
	MffTarget *t = mffTarget();
	NSValue *key = [NSValue valueWithPointer:id_];
	NSTimer *tm = [NSTimer timerWithTimeInterval:interval / 1000.0 target:t selector:@selector(timerFired:) userInfo:key repeats:YES];
	/* The common modes: the timer runs also in a modal loop (ShowModal, MsgBox) and while a menu is open */
	[[NSRunLoop currentRunLoop] addTimer:tm forMode:NSRunLoopCommonModes];
	t.timers[key] = tm;
}

void mffTimerStop(void *id_) {
	MffTarget *t = mffTarget();
	NSValue *key = [NSValue valueWithPointer:id_];
	[t.timers[key] invalidate];
	[t.timers removeObjectForKey:key];
}

void mffClipboardSetText(const char *text) {
	NSPasteboard *p = [NSPasteboard generalPasteboard];
	[p clearContents];
	[p setString:mffStr(text) forType:NSPasteboardTypeString];
}

char *mffClipboardGetText(void) {
	NSString *s = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
	return s ? mffDup(s) : NULL;
}

void mffOpenURL(const char *url) {
	NSURL *u = [NSURL URLWithString:mffStr(url)];
	if (u) [[NSWorkspace sharedWorkspace] openURL:u];
}

/* ---- CheckedListBox, tables ---- */

void mffListSetChecked(void *view, int index, int value) {
	NSTableView *t = mffTable(view);
	if (!t || index < 0) return;
	if (value) [mffChecks(t) addIndex:index]; else [mffChecks(t) removeIndex:index];
	[t reloadData];
}

int mffListGetChecked(void *view, int index) {
	NSTableView *t = mffTable(view);
	return (t && index >= 0 && [mffChecks(t) containsIndex:index]) ? 1 : 0;
}

void mffTableInit(void *view) {
	NSTableView *t = mffTable(view);
	if (t) objc_setAssociatedObject(t, &kMffTableKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void mffTableSetView(void *view, const char *viewName) {
	/* The rows of a table are the only view of a ListView here */
	(void)view; (void)viewName;
}

void mffTableSetColumns(void *view, const char *captions, const char *widths) {
	NSTableView *t = mffTable(view);
	if (!t) return;
	NSArray *caps = [mffStr(captions) componentsSeparatedByString:@"\n"];
	NSArray *wids = [mffStr(widths) componentsSeparatedByString:@"\n"];
	while ([[t tableColumns] count]) [t removeTableColumn:[[t tableColumns] lastObject]];
	for (NSUInteger i = 0; i < [caps count]; i++) {
		NSTableColumn *c = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
		[[c headerCell] setStringValue:caps[i]];
		if (i < [wids count] && [wids[i] intValue] > 0) [c setWidth:[wids[i] intValue]];
		[c setResizingMask:NSTableColumnUserResizingMask];
		[t addTableColumn:c];
	}
	[t setHeaderView:[[NSTableHeaderView alloc] init]];
	[t setColumnAutoresizingStyle:NSTableViewNoColumnAutoresizing];
	[[t enclosingScrollView] tile];
	[t reloadData];
}

void mffTableInsertRow(void *view, int index, const char *cells) {
	NSTableView *t = mffTable(view);
	if (!t) return;
	NSMutableArray *a = mffItems(t);
	NSArray *row = [mffStr(cells) componentsSeparatedByString:@"\t"];
	if (index < 0 || index > (int)[a count]) [a addObject:row]; else [a insertObject:row atIndex:index];
	mffSilent = YES;
	[t reloadData];
	mffSilent = NO;
}

void mffTableSetRow(void *view, int index, const char *cells) {
	NSTableView *t = mffTable(view);
	if (!t) return;
	NSMutableArray *a = mffItems(t);
	if (index < 0 || index >= (int)[a count]) return;
	a[index] = [mffStr(cells) componentsSeparatedByString:@"\t"];
	[t reloadData];
}

void mffTableCellRect(void *view, int row, int col, void *pRect) {
	NSTableView *t = mffTable(view);
	int *r = pRect;
	if (!t || !r) return;
	NSRect f = NSZeroRect;
	if (row >= 0 && row < [t numberOfRows] && col >= 0 && col < [t numberOfColumns]) f = [t frameOfCellAtColumn:col row:row];
	r[0] = (int)NSMinX(f); r[1] = (int)NSMinY(f); r[2] = (int)NSMaxX(f); r[3] = (int)NSMaxY(f);
}

int mffTableDblClick(void) {
	return mffDblClick;
}

/* ---- TabControl: the strip of the tabs in the view ---- */

void mffTabsSet(void *view, const char *titles) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffTabsView class]]) return;
	NSSegmentedControl *seg = ((MffTabsView *)o).segments;
	NSInteger selected = [seg selectedSegment];
	NSArray *lines = [mffStr(titles) length] ? [mffStr(titles) componentsSeparatedByString:@"\n"] : @[];
	[seg setSegmentCount:[lines count]];
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		[seg setLabel:mffNoMnemonic(f[0]) forSegment:i];
		NSImage *img = ([f count] > 2 && [f[2] length]) ? [[NSImage alloc] initWithContentsOfFile:f[2]] : nil;
		[seg setImage:img forSegment:i];
		[seg setWidth:0 forSegment:i];
	}
	if (selected >= 0 && selected < (NSInteger)[lines count]) [seg setSelectedSegment:selected];
	[seg sizeToFit];
	[(MffTabsView *)o layoutStrip];
}

void mffTabsSetPosition(void *view, int position) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffTabsView class]]) {
		((MffTabsView *)o).tabPosition = position;
		[(MffTabsView *)o layoutStrip];
	}
}

int mffTabsStripHeight(void) {
	return 28;
}

/* ---- ToolBar, ToolPalette: a row of buttons, which goes on in the next row ---- */

void mffButtonsSet(void *view, const char *items) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffButtonsView class]]) return;
	MffButtonsView *v = o;
	for (id b in v.buttons) if ([b isKindOfClass:[NSView class]]) [(NSView *)b removeFromSuperview];
	[v.buttons removeAllObjects];
	NSArray *lines = [mffStr(items) length] ? [mffStr(items) componentsSeparatedByString:@"\n"] : @[];
	CGFloat x = 0, y = 0, rowHeight = 0, width = [v bounds].size.width, right = 0;
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		NSString *first = f[0];
		unichar flag = [first length] ? [first characterAtIndex:0] : '0';
		if (flag == '4' || flag == '3') {
			[v.buttons addObject:[NSNull null]];
			if (flag == '3') x += 8;
			continue;
		}
		NSString *text = [first length] > 1 ? mffNoMnemonic([first substringFromIndex:1]) : @"";
		NSString *options = [f count] > 2 ? f[2] : @"";
		NSImage *img = ([f count] > 1 && [f[1] length]) ? [[NSImage alloc] initWithContentsOfFile:f[1]] : nil;
		NSButton *b = [[NSButton alloc] initWithFrame:NSZeroRect];
		[b setBordered:NO];
		[b setButtonType:flag == '2' ? NSButtonTypePushOnPushOff : NSButtonTypeMomentaryChange];
		if (flag == '2') [b setState:NSControlStateValueOn];
		[b setEnabled:flag != '1'];
		if (img) {
			[b setImage:img];
			[b setImagePosition:[options rangeOfString:@"S"].location != NSNotFound ? NSImageLeft : NSImageOnly];
		}
		[b setTitle:(!img || [options rangeOfString:@"S"].location != NSNotFound) ? text : @""];
		if ([f count] > 3 && [f[3] length]) [b setToolTip:f[3]];
		[b setTag:i];
		[b setTarget:mffTarget()];
		[b setAction:@selector(buttonsClick:)];
		[b sizeToFit];
		NSSize s = [b frame].size;
		s.width = MAX(s.width + 6, 24);
		s.height = MAX(s.height + 4, 24);
		if (x > 0 && width > 0 && x + s.width > width) { x = 0; y += rowHeight; rowHeight = 0; }
		[b setFrame:NSMakeRect(x, y, s.width, s.height)];
		[v addSubview:b];
		[v.buttons addObject:b];
		x += s.width;
		right = MAX(right, x);
		rowHeight = MAX(rowHeight, s.height);
	}
	v.contentWidth = right;
}

int mffButtonsItem(void *view, int index, int what) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffButtonsView class]]) return -1;
	MffButtonsView *v = o;
	if (index < 0) return (int)v.contentWidth;
	if (index >= (int)[v.buttons count] || ![v.buttons[index] isKindOfClass:[NSView class]]) return -1;
	NSRect f = [(NSView *)v.buttons[index] frame];
	return (int)(what ? f.size.width : f.origin.x);
}

int mffViewFittingWidth(void *view) {
	NSView *v = mffView(view);
	return v ? (int)[v fittingSize].width : 0;
}

/* ---- WebBrowser, pictures ---- */

void mffWebLoadURL(void *view, const char *url) {
	id o = mffObj(view);
	NSURL *u = [NSURL URLWithString:mffStr(url)];
	if ([o isKindOfClass:[WKWebView class]] && u) [(WKWebView *)o loadRequest:[NSURLRequest requestWithURL:u]];
}

void mffWebLoadHTML(void *view, const char *html) {
	id o = mffObj(view);
	if ([o isKindOfClass:[WKWebView class]]) [(WKWebView *)o loadHTMLString:mffStr(html) baseURL:nil];
}

void mffWebAction(void *view, int action) {
	id o = mffObj(view);
	if (![o isKindOfClass:[WKWebView class]]) return;
	WKWebView *w = o;
	switch (action) {
	case 0: [w goBack]; break;
	case 1: [w goForward]; break;
	case 2: [w reload]; break;
	case 3: [w stopLoading]; break;
	}
}

void mffViewLoadImage(void *view, const char *path, int center) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffView class]]) return;
	((MffView *)o).mffImage = [[NSImage alloc] initWithContentsOfFile:mffStr(path)];
	((MffView *)o).mffImageCenter = center != 0;
	[(NSView *)o setNeedsDisplay:YES];
}

/* ---- Menus ---- */

/* The lines "Level Tab Enabled Tab Checked Tab Caption" (the caption can begin with Chr(1) picture Chr(1) and end with
   Tab shortcut). The tag of an item is the index of its line */
static NSMenu *mffBuildMenu(const char *items, SEL action) {
	NSMenu *root = [[NSMenu alloc] init];
	[root setAutoenablesItems:NO];
	NSMutableArray<NSMenu *> *stack = [NSMutableArray arrayWithObject:root];
	NSMenuItem *last = nil;
	NSArray *lines = [mffStr(items) componentsSeparatedByString:@"\n"];
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		if ([f count] < 4) continue;
		int level = [f[0] intValue];
		while ((int)[stack count] - 1 > level) [stack removeLastObject];
		if ((int)[stack count] - 1 < level && last) {
			NSMenu *sub = [[NSMenu alloc] initWithTitle:[last title]];
			[sub setAutoenablesItems:NO];
			[last setSubmenu:sub];
			[stack addObject:sub];
		}
		NSString *caption = f[3];
		NSImage *img = nil;
		if ([caption hasPrefix:@"\x01"]) {
			NSRange end = [caption rangeOfString:@"\x01" options:0 range:NSMakeRange(1, [caption length] - 1)];
			if (end.location != NSNotFound) {
				img = [[NSImage alloc] initWithContentsOfFile:[caption substringWithRange:NSMakeRange(1, end.location - 1)]];
				caption = [caption substringFromIndex:end.location + 1];
			}
		}
		if ([caption isEqualToString:@"-"]) {
			[[stack lastObject] addItem:[NSMenuItem separatorItem]];
			last = nil;
			continue;
		}
		NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:mffNoMnemonic(caption) action:action keyEquivalent:@""];
		[mi setTarget:mffTarget()];
		[mi setTag:i];
		[mi setEnabled:[f[1] intValue] != 0];
		[mi setState:[f[2] intValue] ? NSControlStateValueOn : NSControlStateValueOff];
		if (img) { [img setSize:NSMakeSize(16, 16)]; [mi setImage:img]; }
		/* The shortcut after the caption: Ctrl is the Command key of the Mac */
		if ([f count] > 4) {
			NSString *keys = [f[4] uppercaseString];
			NSString *key = [[keys componentsSeparatedByString:@"+"] lastObject];
			if ([key length] == 1) {
				NSEventModifierFlags mask = 0;
				if ([keys rangeOfString:@"CTRL"].location != NSNotFound) mask |= NSEventModifierFlagCommand;
				if ([keys rangeOfString:@"SHIFT"].location != NSNotFound) mask |= NSEventModifierFlagShift;
				if ([keys rangeOfString:@"ALT"].location != NSNotFound) mask |= NSEventModifierFlagOption;
				if (mask) { [mi setKeyEquivalent:[key lowercaseString]]; [mi setKeyEquivalentModifierMask:mask]; }
			}
		}
		[[stack lastObject] addItem:mi];
		last = mi;
	}
	return root;
}

int mffPopupMenu(const char *items, int x, int y) {
	(void)x; (void)y;
	mffEnsureApp();
	NSMenu *m = mffBuildMenu(items, @selector(popupChosen:));
	mffPopupResult = -1;
	[m popUpMenuPositioningItem:nil atLocation:[NSEvent mouseLocation] inView:nil];
	return mffPopupResult;
}

void mffMenuBarSet(const char *items) {
	mffEnsureApp();
	NSMenu *bar = [NSApp mainMenu];
	while ([bar numberOfItems] > 1) [bar removeItemAtIndex:1];
	NSMenu *m = mffBuildMenu(items, @selector(menuBarChosen:));
	while ([m numberOfItems]) {
		NSMenuItem *mi = [m itemAtIndex:0];
		[m removeItemAtIndex:0];
		if ([mi isSeparatorItem]) continue;
		/* An item of the bar only opens a menu: an item without items is the only item of its menu */
		if (![mi submenu]) {
			NSMenu *sub = [[NSMenu alloc] initWithTitle:[mi title]];
			NSMenuItem *only = [[NSMenuItem alloc] initWithTitle:[mi title] action:@selector(menuBarChosen:) keyEquivalent:@""];
			[only setTarget:mffTarget()];
			[only setTag:[mi tag]];
			[sub addItem:only];
			[mi setAction:NULL];
			[mi setSubmenu:sub];
		}
		[bar addItem:mi];
	}
}

/* ---- Dialogs ---- */

/* "Text files|*.txt;*.log|All files|*.*": the extensions of the filter FilterIndex (from 1), nil - all the files */
static NSArray *mffFilterTypes(NSString *filter, int index) {
	NSArray *parts = [filter componentsSeparatedByString:@"|"];
	NSUInteger i = (index > 0 ? index - 1 : 0) * 2 + 1;
	if (i >= [parts count]) return nil;
	NSMutableArray *types = [NSMutableArray array];
	for (NSString *p in [parts[i] componentsSeparatedByString:@";"]) {
		NSString *e = [[p stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] pathExtension];
		if ([e isEqualToString:@"*"] || ![e length]) return nil;
		[types addObject:e];
	}
	return types;
}

char *mffFileDialog(int mode, const char *caption, const char *initialDir, const char *fileName, const char *filter, int filterIndex) {
	mffEnsureApp();
	NSSavePanel *panel;
	if (mode == 2) {
		panel = [NSSavePanel savePanel];
	} else {
		NSOpenPanel *open = [NSOpenPanel openPanel];
		[open setAllowsMultipleSelection:mode == 1];
		[open setCanChooseDirectories:mode == 3];
		[open setCanChooseFiles:mode != 3];
		panel = open;
	}
	if (caption && *caption) [panel setMessage:mffStr(caption)];
	if (initialDir && *initialDir) [panel setDirectoryURL:[NSURL fileURLWithPath:mffStr(initialDir)]];
	if (fileName && *fileName) [panel setNameFieldStringValue:[mffStr(fileName) lastPathComponent]];
	if (mode != 3) {
		NSArray *types = mffFilterTypes(mffStr(filter), filterIndex);
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		if (types) [panel setAllowedFileTypes:types];
		#pragma clang diagnostic pop
	}
	if ([panel runModal] != NSModalResponseOK) return NULL;
	if (mode == 2) return mffDup([[panel URL] path]);
	NSMutableArray *paths = [NSMutableArray array];
	for (NSURL *u in [(NSOpenPanel *)panel URLs]) [paths addObject:[u path]];
	return mffDup([paths componentsJoinedByString:@"\n"]);
}

/* A message box with the list of the font families and the size: NSFontPanel is not modal */
char *mffFontDialog(const char *fontName, int size, int style, int fontColor) {
	mffEnsureApp();
	NSAlert *a = [[NSAlert alloc] init];
	[a setMessageText:@"Font"];
	[a addButtonWithTitle:@"OK"];
	[a addButtonWithTitle:@"Cancel"];
	NSView *box = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 280, 28)];
	NSPopUpButton *names = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 210, 26) pullsDown:NO];
	[names addItemsWithTitles:[[NSFontManager sharedFontManager] availableFontFamilies]];
	if (fontName && *fontName) [names selectItemWithTitle:mffStr(fontName)];
	NSTextField *sizeField = [[NSTextField alloc] initWithFrame:NSMakeRect(220, 2, 60, 22)];
	[sizeField setIntValue:size > 0 ? size : 10];
	[box addSubview:names];
	[box addSubview:sizeField];
	[a setAccessoryView:box];
	if ([a runModal] != NSAlertFirstButtonReturn) return NULL;
	return mffDup([NSString stringWithFormat:@"%@\n%d\n%d\n%d", [names titleOfSelectedItem], [sizeField intValue], style, fontColor]);
}

/* NSColorPanel is not modal: the modal loop runs until the panel is closed */
int mffColorDialog(const char *caption, int colorValue) {
	mffEnsureApp();
	NSColorPanel *p = [NSColorPanel sharedColorPanel];
	if (caption && *caption) [p setTitle:mffStr(caption)];
	if (colorValue >= 0) [p setColor:mffColor(colorValue)];
	id token = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification object:p queue:nil usingBlock:^(NSNotification *n) {
		[NSApp stopModal];
	}];
	[p makeKeyAndOrderFront:nil];
	[NSApp runModalForWindow:p];
	[[NSNotificationCenter defaultCenter] removeObserver:token];
	NSColor *c = [[p color] colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
	if (!c) return -1;
	return ((int)lround([c redComponent] * 255)) | ((int)lround([c greenComponent] * 255) << 8) | ((int)lround([c blueComponent] * 255) << 16);
}

/* ---- Regular expressions ---- */

static NSMutableDictionary<NSNumber *, NSRegularExpression *> *mffRegexes;
static NSString *mffRegexLastError;
static int mffRegexNext;

int mffRegexCompile(const char *pattern, int flags) {
	NSRegularExpressionOptions o = 0;
	if (flags & 1) o |= NSRegularExpressionCaseInsensitive;
	if (flags & 2) o |= NSRegularExpressionAnchorsMatchLines;
	if (flags & 4) o |= NSRegularExpressionDotMatchesLineSeparators;
	if (flags & 8) o |= NSRegularExpressionAllowCommentsAndWhitespace;
	NSError *err = nil;
	NSRegularExpression *r = [NSRegularExpression regularExpressionWithPattern:mffStr(pattern) options:o error:&err];
	if (!r) {
		mffRegexLastError = [err localizedDescription];
		return 0;
	}
	if (!mffRegexes) mffRegexes = [NSMutableDictionary dictionary];
	mffRegexes[@(++mffRegexNext)] = r;
	return mffRegexNext;
}

char *mffRegexError(void) {
	return mffDup(mffRegexLastError ?: @"");
}

void mffRegexFree(int id_) {
	[mffRegexes removeObjectForKey:@(id_)];
}

/* The offsets are the ones of the bytes of UTF-8 like in the other versions */
int mffRegexExec(int id_, const char *subject, int startByte, int *offsets, int maxGroups) {
	NSRegularExpression *r = mffRegexes[@(id_)];
	if (!r || !subject) return 0;
	NSString *s = [NSString stringWithUTF8String:subject];
	if (!s) return 0;
	NSString *head = [[NSString alloc] initWithBytes:subject length:startByte encoding:NSUTF8StringEncoding];
	NSUInteger start = head ? [head length] : 0;
	NSTextCheckingResult *m = [r firstMatchInString:s options:0 range:NSMakeRange(start, [s length] - start)];
	if (!m) return 0;
	int count = (int)[m numberOfRanges];
	for (int i = 0; i < count && i < maxGroups; i++) {
		NSRange g = [m rangeAtIndex:i];
		if (g.location == NSNotFound) {
			offsets[i * 2] = -1;
			offsets[i * 2 + 1] = -1;
		} else {
			offsets[i * 2] = (int)[[s substringToIndex:g.location] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
			offsets[i * 2 + 1] = offsets[i * 2] + (int)[[s substringWithRange:g] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
		}
	}
	return count;
}

/* ---- Canvas: draws on the current graphics context, the path works like the one of cairo ---- */

static NSBezierPath *mffPath;
static NSView *mffLockedView;
static NSImage *mffLockedPage;

static NSBezierPath *mffCurrentPath(void) {
	if (!mffPath) mffPath = [NSBezierPath bezierPath];
	return mffPath;
}

static NSColor *mffColorAlpha(int color, int alpha) {
	return [mffColor(color < 0 ? 0 : color) colorWithAlphaComponent:alpha / 255.0];
}

void mffCanvasBegin(void *id_) {
	mffPath = nil;
	if (id_ && [mffObj(id_) isKindOfClass:[NSImage class]]) {
		/* A page of a PrintDocument */
		[(NSImage *)mffObj(id_) lockFocusFlipped:YES];
		mffLockedPage = mffObj(id_);
		return;
	}
	if ([NSGraphicsContext currentContext] || !id_) return;
	/* Out of the drawing of the view */
	NSView *v = (__bridge NSView *)mffViewLayout(id_);
	if ([v isKindOfClass:[NSView class]] && [v lockFocusIfCanDraw]) mffLockedView = v;
}

void mffCanvasEnd(void *id_) {
	(void)id_;
	if (mffLockedPage) {
		[mffLockedPage unlockFocus];
		mffLockedPage = nil;
		return;
	}
	if (mffLockedView) {
		[[NSGraphicsContext currentContext] flushGraphics];
		[mffLockedView unlockFocus];
		mffLockedView = nil;
	}
}

void mffCanvasNewPath(void) { mffPath = nil; }
void mffCanvasMoveTo(double x, double y) { [mffCurrentPath() moveToPoint:NSMakePoint(x, y)]; }
void mffCanvasLineTo(double x, double y) {
	NSBezierPath *p = mffCurrentPath();
	if ([p isEmpty]) [p moveToPoint:NSMakePoint(x, y)]; else [p lineToPoint:NSMakePoint(x, y)];
}
void mffCanvasCurveTo(double x1, double y1, double x2, double y2, double x3, double y3) {
	NSBezierPath *p = mffCurrentPath();
	if ([p isEmpty]) [p moveToPoint:NSMakePoint(x1, y1)];
	[p curveToPoint:NSMakePoint(x3, y3) controlPoint1:NSMakePoint(x1, y1) controlPoint2:NSMakePoint(x2, y2)];
}
void mffCanvasArc(double cx, double cy, double r, double a1, double a2, int negative) {
	[mffCurrentPath() appendBezierPathWithArcWithCenter:NSMakePoint(cx, cy) radius:r startAngle:a1 * 180.0 / M_PI endAngle:a2 * 180.0 / M_PI clockwise:negative != 0];
}
void mffCanvasRectPath(double x, double y, double w, double h) { [mffCurrentPath() appendBezierPathWithRect:NSMakeRect(x, y, w, h)]; }
void mffCanvasClosePath(void) { if (![mffCurrentPath() isEmpty]) [mffCurrentPath() closePath]; }
void mffCanvasClip(void) {
	if (![NSGraphicsContext currentContext]) return;
	[mffCurrentPath() addClip];
	mffPath = nil;
}
void mffCanvasFill(int color, int alpha) {
	if (![NSGraphicsContext currentContext]) return;
	[mffColorAlpha(color, alpha) setFill];
	[mffCurrentPath() fill];
}
void mffCanvasStroke(int color, int alpha, double lineWidth, const char *dash) {
	if (![NSGraphicsContext currentContext]) return;
	NSBezierPath *p = mffCurrentPath();
	[mffColorAlpha(color, alpha) setStroke];
	[p setLineWidth:lineWidth];
	NSArray *parts = (dash && *dash) ? [mffStr(dash) componentsSeparatedByString:@","] : @[];
	CGFloat pattern[8];
	NSInteger n = 0;
	for (NSString *s in parts) if (n < 8) pattern[n++] = [s doubleValue];
	[p setLineDash:n ? pattern : NULL count:n phase:0];
	[p stroke];
}
void mffCanvasFillRect(double x, double y, double w, double h, int color, int alpha) {
	if (![NSGraphicsContext currentContext]) return;
	[mffColorAlpha(color, alpha) setFill];
	[NSBezierPath fillRect:NSMakeRect(x, y, w, h)];
}
void mffCanvasInvertRect(double x, double y, double w, double h) {
	NSGraphicsContext *g = [NSGraphicsContext currentContext];
	if (!g) return;
	CGContextRef c = [g CGContext];
	CGContextSaveGState(c);
	CGContextSetBlendMode(c, kCGBlendModeDifference);
	CGContextSetRGBFillColor(c, 1, 1, 1, 1);
	CGContextFillRect(c, CGRectMake(x, y, w, h));
	CGContextRestoreGState(c);
}
void mffCanvasRotate(double x, double y, double angle) {
	if (![NSGraphicsContext currentContext]) return;
	NSAffineTransform *t = [NSAffineTransform transform];
	[t translateXBy:x yBy:y];
	/* The view is flipped: counterclockwise on the screen */
	[t rotateByDegrees:-angle];
	[t translateXBy:-x yBy:-y];
	[t concat];
}
void mffCanvasSave(void) { if ([NSGraphicsContext currentContext]) [NSGraphicsContext saveGraphicsState]; }
void mffCanvasRestore(void) { if ([NSGraphicsContext currentContext]) [NSGraphicsContext restoreGraphicsState]; }

/* FontSize is in the points of the view */
static NSFont *mffCanvasFont(const char *name, double size, int bold, int italic) {
	CGFloat sz = size > 0 ? size : [NSFont systemFontSize];
	NSFont *f = (name && *name && strcmp(name, "System")) ? [NSFont fontWithName:mffStr(name) size:sz] : nil;
	if (!f) f = [NSFont systemFontOfSize:sz];
	NSFontManager *m = [NSFontManager sharedFontManager];
	if (bold) f = [m convertFont:f toHaveTrait:NSBoldFontMask];
	if (italic) f = [m convertFont:f toHaveTrait:NSItalicFontMask];
	return f;
}

void mffCanvasText(double x, double y, const char *text, int color, int bkColor, const char *fontName, double fontSize, int bold, int italic) {
	if (![NSGraphicsContext currentContext]) return;
	NSMutableDictionary *a = [NSMutableDictionary dictionary];
	a[NSFontAttributeName] = mffCanvasFont(fontName, fontSize, bold, italic);
	a[NSForegroundColorAttributeName] = mffColor(color < 0 ? 0 : color);
	if (bkColor >= 0) a[NSBackgroundColorAttributeName] = mffColor(bkColor);
	[mffStr(text) drawAtPoint:NSMakePoint(x, y) withAttributes:a];
}

int mffCanvasTextWidth(const char *text, const char *fontName, double fontSize, int bold, int italic) {
	return (int)ceil([mffStr(text) sizeWithAttributes:@{NSFontAttributeName: mffCanvasFont(fontName, fontSize, bold, italic)}].width);
}

int mffCanvasTextHeight(const char *fontName, double fontSize, int bold, int italic) {
	return (int)ceil([@"Wg" sizeWithAttributes:@{NSFontAttributeName: mffCanvasFont(fontName, fontSize, bold, italic)}].height);
}

/* The pixels of the view can not be read while it draws */
int mffCanvasGetPixel(double x, double y) {
	(void)x; (void)y;
	return -1;
}

void mffCanvasImage(const char *path, double x, double y, double w, double h, int alpha) {
	if (![NSGraphicsContext currentContext] || !path || !*path) return;
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:mffStr(path)];
	if (!img) return;
	NSSize s = [img size];
	[img drawInRect:NSMakeRect(x, y, w > 0 ? w : s.width, h > 0 ? h : s.height) fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:alpha / 255.0 respectFlipped:YES hints:nil];
}

static id mffFileTable(void *view) { return mffTable(view); }

/* ---- OpenFileControl: the file list in a table ---- */

static NSMutableDictionary *mffFileState(id table) {
	return objc_getAssociatedObject(table, &kMffFileViewKey);
}

static void mffFileViewList(id table) {
	NSMutableDictionary *st = mffFileState(table);
	NSMutableArray *items = mffItems(table);
	[items removeAllObjects];
	NSArray *names = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:st[@"dir"] error:nil] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	NSMutableArray *dirs = [NSMutableArray array], *files = [NSMutableArray array];
	NSArray *patterns = [st[@"patterns"] componentsSeparatedByString:@";"];
	for (NSString *n in names) {
		if ([n hasPrefix:@"."]) continue;
		BOOL isDir = NO;
		[[NSFileManager defaultManager] fileExistsAtPath:[st[@"dir"] stringByAppendingPathComponent:n] isDirectory:&isDir];
		if (isDir) { [dirs addObject:n]; continue; }
		for (NSString *p in patterns) {
			NSString *t = [p stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			if (![t length] || [t isEqualToString:@"*"] || [t isEqualToString:@"*.*"] || [[NSPredicate predicateWithFormat:@"SELF LIKE[c] %@", t] evaluateWithObject:n]) { [files addObject:n]; break; }
		}
	}
	[items addObject:@".."];
	for (NSString *d in dirs) [items addObject:[d stringByAppendingString:@"/"]];
	[items addObjectsFromArray:files];
	[table reloadData];
}

/* A choice in the file list: "select" (the file), "activate" (Activate: a double click), "folder" (another folder) */
static void mffFileViewChoose(id table, id owner, NSInteger row, BOOL activate) {
	NSMutableDictionary *st = mffFileState(table);
	NSArray *items = mffItems(table);
	if (!st || row < 0 || row >= (NSInteger)[items count]) return;
	NSString *name = items[row];
	if ([name isEqualToString:@".."] || [name hasSuffix:@"/"]) {
		if (!activate) return;
		st[@"dir"] = [name isEqualToString:@".."] ? [st[@"dir"] stringByDeletingLastPathComponent] : [st[@"dir"] stringByAppendingPathComponent:[name substringToIndex:[name length] - 1]];
		st[@"event"] = @"folder";
		st[@"files"] = @"";
		mffFileViewList(table);
	} else {
		st[@"event"] = activate ? @"activate" : @"select";
		st[@"files"] = [st[@"dir"] stringByAppendingPathComponent:name];
	}
	void *ctrl = mffGetCtrl(owner);
	if (ctrl) mffOnChange(ctrl, (int)row);
}

char *mffFileViewAttr(void *view, const char *name) {
	id t = mffFileTable(view);
	NSMutableDictionary *st = t ? mffFileState(t) : nil;
	NSString *n = mffStr(name);
	if (!st) return NULL;
	if ([n isEqualToString:@"data-event"]) return mffDup(st[@"event"]);
	if ([n isEqualToString:@"data-dir"]) return mffDup(st[@"dir"]);
	if ([n isEqualToString:@"data-files"]) return mffDup(st[@"files"]);
	return NULL;
}

void mffFileViewFill(void *view, const char *dir, const char *patterns, int multiple) {
	(void)multiple;
	id t = mffFileTable(view);
	if (!t) return;
	NSMutableDictionary *st = mffFileState(t);
	if (!st) {
		st = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(t, &kMffFileViewKey, st, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	st[@"dir"] = mffStr(dir);
	st[@"patterns"] = mffStr(patterns);
	st[@"event"] = @"";
	st[@"files"] = @"";
	mffFileViewList(t);
}

/* ---- The pages of a PrintDocument: pictures, the Canvas draws in them between mffCanvasBegin and mffCanvasEnd ---- */

void *mffPageCreate(int width, int height) {
	NSImage *img = [[NSImage alloc] initWithSize:NSMakeSize(width > 0 ? width : 1, height > 0 ? height : 1)];
	return (__bridge_retained void *)img;
}

void mffPageFree(void *page) {
	if (page) (void)(__bridge_transfer id)page;
}

void mffPageDraw(void *page, int x, int y, int w, int h) {
	if (!page || ![NSGraphicsContext currentContext]) return;
	NSImage *img = (__bridge NSImage *)page;
	[[NSColor whiteColor] setFill];
	NSRectFill(NSMakeRect(x, y, w, h));
	[img drawInRect:NSMakeRect(x, y, w, h) fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1 respectFlipped:YES hints:nil];
}

/* The view of the print operation: one page of the paper for each picture */
@interface MffPagesView : NSView
@property (nonatomic, strong) NSArray<NSImage *> *pages;
@end

@implementation MffPagesView
- (BOOL)isFlipped { return YES; }
- (BOOL)knowsPageRange:(NSRangePointer)r {
	*r = NSMakeRange(1, [self.pages count]);
	return YES;
}
- (NSRect)rectForPage:(NSInteger)n {
	NSSize s = [self bounds].size;
	CGFloat h = s.height / MAX([self.pages count], 1);
	return NSMakeRect(0, (n - 1) * h, s.width, h);
}
- (void)drawRect:(NSRect)r {
	NSSize s = [self bounds].size;
	CGFloat h = s.height / MAX([self.pages count], 1);
	for (NSUInteger i = 0; i < [self.pages count]; i++) {
		NSRect to = NSMakeRect(0, i * h, s.width, h);
		if (NSIntersectsRect(to, r)) [self.pages[i] drawInRect:to fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1 respectFlipped:YES hints:nil];
	}
}
@end

void mffPagesPrint(void **pages, int count, const char *name) {
	mffEnsureApp();
	if (count <= 0) return;
	NSMutableArray *a = [NSMutableArray array];
	for (int i = 0; i < count; i++) [a addObject:(__bridge NSImage *)pages[i]];
	NSSize s = [(NSImage *)a[0] size];
	MffPagesView *v = [[MffPagesView alloc] initWithFrame:NSMakeRect(0, 0, s.width, s.height * count)];
	v.pages = a;
	NSPrintInfo *info = [[NSPrintInfo sharedPrintInfo] copy];
	[info setHorizontalPagination:NSPrintingPaginationModeFit];
	[info setVerticalPagination:NSPrintingPaginationModeAutomatic];
	NSPrintOperation *op = [NSPrintOperation printOperationWithView:v printInfo:info];
	[op setJobTitle:mffStr(name)];
	[op runOperation];
}
