/*
 * mffCocoa.m - MyFbFramework: the AppKit host of macOS (-d __USE_COCOA__).
 * The program (the C code of fbc -gen gcc) is linked with it:
 *   clang -fobjc-arc -framework Cocoa mffCocoa.m Program.c libfb.a -o Program
 * The functions are described in Apple/mffApple.h.
 */
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Apple/mffApple.h"

static char kMffCtrlKey;
/* The host sets the frame of a window (no mffOnResize then) / the user moved or resized it (mffOnResize, mffOnMove:
   the bounds which the control sets meanwhile are the ones of the window already) */
static BOOL mffSettingFrame, mffInWindowEvent;

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
	return row < (NSInteger)[a count] ? a[row] : @"";
}
- (void)tableViewSelectionDidChange:(NSNotification *)n {
	NSTableView *t = [n object];
	NSView *v = [t enclosingScrollView];
	void *ctrl = v ? mffGetCtrl(v) : NULL;
	if (ctrl) mffOnChange(ctrl, (int)[t selectedRow]);
}
- (void)tableDoubleClick:(NSTableView *)t {
	NSView *v = [t enclosingScrollView];
	void *ctrl = v ? mffGetCtrl(v) : NULL;
	if (ctrl) mffOnDblClick(ctrl);
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
		NSBox *b = [[NSBox alloc] initWithFrame:r];
		[b setTitle:@""];
		MffView *content = [[MffView alloc] initWithFrame:NSZeroRect];
		mffSetCtrl(content, ctrl);
		[b setContentView:content];
		obj = b;
	} else if ([k isEqualToString:@"ListControl"] || [k isEqualToString:@"CheckedListBox"]) {
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
	else if ([o isKindOfClass:[NSBox class]]) [(NSBox *)o setTitle:mffNoMnemonic(s)];
	else if ([o isKindOfClass:[NSTextField class]]) [(NSTextField *)o setStringValue:[(NSTextField *)o isEditable] ? s : mffNoMnemonic(s)];
	else if (mffTextView(view)) [mffTextView(view) setString:s];
}

char *mffViewGetText(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[NSWindow class]]) return mffDup([(NSWindow *)o title]);
	if ([o isKindOfClass:[NSPopUpButton class]]) return mffDup([(NSPopUpButton *)o titleOfSelectedItem]);
	if ([o isKindOfClass:[NSButton class]]) return mffDup([(NSButton *)o title]);
	if ([o isKindOfClass:[NSBox class]]) return mffDup([(NSBox *)o title]);
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
		if (index < 0) [t deselectAll:nil];
		else { [t selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO]; [t scrollRowToVisible:index]; }
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
	if ([o isKindOfClass:[NSProgressIndicator class]]) [(NSProgressIndicator *)o setDoubleValue:value];
	else if ([o isKindOfClass:[NSSlider class]]) [(NSSlider *)o setIntValue:value];
}

int mffPositionGet(void *view) {
	id o = mffObj(view);
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
   two seconds after the start; MFF_CLICK=Caption clicks the button with that caption then, and the windows (a
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
	NSTimer *tm = [NSTimer timerWithTimeInterval:2.0 repeats:YES block:^(NSTimer *t) {
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
	[a setMessageText:mffStr(caption)];
	[a setInformativeText:mffStr(msg)];
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
