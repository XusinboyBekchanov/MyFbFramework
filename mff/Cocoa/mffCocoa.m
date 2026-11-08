/*
 * mffCocoa.m - MyFbFramework: the AppKit host of macOS (-d __USE_COCOA__).
 * The program (the C code of fbc -gen gcc) is linked with it:
 *   clang -fobjc-arc -framework Cocoa mffCocoa.m Program.c libfb.a -o Program
 * The functions are described in Apple/mffApple.h.
 */
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Apple/mffMainThread.h"
#include "../Apple/mffApple.h"

// The frameworks of the host are in this object (LC_LINKER_OPTION): ld links them with every program and library which
// has it (libmffCocoa.a of mff/Apple/mffApple.bi), fbc does not need to know them
__asm__(".linker_option \"-framework\", \"Cocoa\"\n"
	".linker_option \"-framework\", \"WebKit\"\n"
	".linker_option \"-framework\", \"ApplicationServices\"");

static char kMffCtrlKey;
/* The host sets the frame of a window (no mffOnResize then) / the user moved or resized it (mffOnResize, mffOnMove:
   the bounds which the control sets meanwhile are the ones of the window already) */
static BOOL mffSettingFrame, mffInWindowEvent;
/* The program changes the selection (the events are for the changes of the user); a double click on a row of a table */
static BOOL mffSilent;
static int mffDblClick, mffPopupResult = -1;
static char kMffTableKey, kMffChecksKey, kMffFileViewKey, kMffGridTableKey, kMffGapKey, kMffLeastKey;
static void mffStartSnapshotTest(void);
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
		/* charactersIgnoringModifiers keeps Shift: the characters of the keys above with Shift */
		case '"': return 222; case ':': return 186; case '<': return 188; case '>': return 190; case '?': return 191;
		case '~': return 192; case '{': return 219; case '|': return 220; case '}': return 221; case '_': return 189;
		case '!': return '1'; case '@': return '2'; case '#': return '3'; case '$': return '4'; case '%': return '5';
		case '^': return '6'; case '&': return '7'; case '*': return '8'; case '(': return '9'; case ')': return '0';
		}
	}
	/* Another keyboard layout (Cyrillic letters...): the key of its place on the keyboard of the US layout, so Ctrl+C and
	   the other shortcuts still work. 0 would be a key without a character, whose character is not given then */
	static const int ansi[] = {
		'A', 'S', 'D', 'F', 'H', 'G', 'Z', 'X', 'C', 'V', 0, 'B', 'Q', 'W', 'E', 'R', 'Y', 'T', '1', '2', '3', '4', '6', '5',
		187, '9', '7', 189, '8', '0', 221, 'O', 'U', 219, 'I', 'P', 0, 'L', 'J', 222, 'K', 186, 220, 188, 191, 'N', 'M', 190,
		0, 0, 192
	};
	if ([e keyCode] < sizeof(ansi) / sizeof(ansi[0]) && ansi[[e keyCode]]) return ansi[[e keyCode]];
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
	/* A program without a bundle, with forms before [NSApp run] (a splash, a modal form): without this the program does not
	   become the active one and the bar of its menu is not on the screen */
	[NSApp finishLaunching];
	/* Started from a terminal or another program macOS does not let it become active with the methods of NSApp alone */
	ProcessSerialNumber psn = {0, kCurrentProcess};
	TransformProcessType(&psn, kProcessTransformToForegroundApplication);
	SetFrontProcess(&psn);
	[[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateAllWindows];
	[NSApp activateIgnoringOtherApps:YES];
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
	/* Ctrl of the shortcuts of the menus is the Command key: Control+C... (as on Windows, and of another keyboard layout)
	   chooses the item of Command+C too */
	NSEventModifierFlags mods = [e modifierFlags];
	if ((mods & NSEventModifierFlagControl) && !(mods & NSEventModifierFlagCommand)) {
		int vk = mffVirtualKey(e);
		NSString *key = ((vk >= 'A' && vk <= 'Z') || (vk >= '0' && vk <= '9')) ? [[NSString stringWithFormat:@"%C", (unichar)vk] lowercaseString] : [e charactersIgnoringModifiers];
		NSEvent *c = [NSEvent keyEventWithType:[e type] location:[e locationInWindow] modifierFlags:(mods & ~NSEventModifierFlagControl) | NSEventModifierFlagCommand timestamp:[e timestamp] windowNumber:[e windowNumber] context:nil characters:key charactersIgnoringModifiers:key isARepeat:[e isARepeat] keyCode:[e keyCode]];
		if ([[NSApp mainMenu] performKeyEquivalent:c]) return;
	}
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
- (void)tableDoubleClick:(NSTableView *)t;
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

/* The text of a cell with the picture of Chr(1) path Chr(1) in its place */
static id mffCellValue(NSString *s) {
	NSRange start = [s rangeOfString:@"\x01"];
	if (start.location == NSNotFound) return s;
	NSRange end = [s rangeOfString:@"\x01" options:0 range:NSMakeRange(start.location + 1, [s length] - start.location - 1)];
	if (end.location == NSNotFound) return s;
	static NSCache *images;
	if (!images) images = [[NSCache alloc] init];
	NSString *path = [s substringWithRange:NSMakeRange(start.location + 1, end.location - start.location - 1)];
	NSDictionary *attrs = @{NSFontAttributeName: [NSFont systemFontOfSize:[NSFont systemFontSize]], NSForegroundColorAttributeName: [NSColor controlTextColor]};
	/* The indent and the sign are in the columns of a tab stop: they are spaces and a sign of a font with different widths, the pictures were not one under the other */
	NSString *prefix = [s substringToIndex:start.location];
	NSString *sign = [prefix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSUInteger spaces = 0;
	while (spaces < [prefix length] && [prefix characterAtIndex:spaces] == ' ') spaces++;
	if ([prefix length]) {
		CGFloat stop = (spaces / 4 + 1) * 14;
		NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
		[ps setTabStops:@[[[NSTextTab alloc] initWithType:NSLeftTabStopType location:stop]]];
		[ps setFirstLineHeadIndent:[sign length] ? stop - 14 : 0];
		NSMutableDictionary *m = [attrs mutableCopy];
		m[NSParagraphStyleAttributeName] = ps;
		attrs = m;
		prefix = [sign stringByAppendingString:@"\t"];
	}
	NSMutableAttributedString *r = [[NSMutableAttributedString alloc] initWithString:prefix attributes:attrs];
	NSImage *img = [path length] ? [images objectForKey:path] : nil;
	if (!img && [path length]) {
		img = [[NSImage alloc] initWithContentsOfFile:path];
		if (img) [images setObject:img forKey:path];
	}
	if (img) {
		NSTextAttachment *a = [[NSTextAttachment alloc] init];
		[a setImage:img];
		[a setBounds:NSMakeRect(0, -3, 16, 16)];
		[r appendAttributedString:[NSAttributedString attributedStringWithAttachment:a]];
		[r appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrs]];
	}
	[r appendAttributedString:[[NSAttributedString alloc] initWithString:[s substringFromIndex:end.location + 1] attributes:attrs]];
	return r;
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

/* The views of a ListView other than the rows: the grid shows the items of its table, which stays the model of the list
   (its selection, its events) without being in the scroll view */
static char kMffTableScrollKey;
static NSScrollView *mffTableScroll(NSTableView *t) {
	return [t enclosingScrollView] ?: objc_getAssociatedObject(t, &kMffTableScrollKey);
}

@interface MffIconGrid : NSView
@property (nonatomic, weak) NSTableView *table;
@property (nonatomic) BOOL small;
@property (nonatomic) NSInteger clickedRow;
- (void)refresh;
@end

@interface MffTableView : NSTableView
@property (nonatomic, weak) MffIconGrid *grid;
@end

@implementation MffTableView
- (void)reloadData { [super reloadData]; [self.grid refresh]; }
- (void)selectRowIndexes:(NSIndexSet *)i byExtendingSelection:(BOOL)e { [super selectRowIndexes:i byExtendingSelection:e]; [self.grid setNeedsDisplay:YES]; }
- (void)deselectAll:(id)sender { [super deselectAll:sender]; [self.grid setNeedsDisplay:YES]; }
@end

static NSInteger mffClickedRow(NSTableView *t) {
	MffIconGrid *g = [t isKindOfClass:[MffTableView class]] ? ((MffTableView *)t).grid : nil;
	return g ? g.clickedRow : [t clickedRow];
}

@implementation MffIconGrid
- (BOOL)isFlipped { return YES; }
- (BOOL)acceptsFirstResponder { return YES; }
- (NSSize)cell { return self.small ? NSMakeSize(190, 24) : NSMakeSize(112, 92); }
- (NSInteger)columns { return MAX(1, (NSInteger)(NSWidth([self bounds]) / [self cell].width)); }
- (NSRect)rectOfItem:(NSInteger)i {
	NSSize c = [self cell];
	NSInteger n = [self columns];
	return NSMakeRect((i % n) * c.width, (i / n) * c.height, c.width, c.height);
}
- (void)refresh {
	NSScrollView *s = [self enclosingScrollView];
	if (!s) return;
	CGFloat w = [s contentSize].width;
	NSSize c = [self cell];
	NSInteger n = MAX(1, (NSInteger)(w / c.width)), count = [mffItems(self.table) count];
	CGFloat h = MAX([s contentSize].height, ((count + n - 1) / n) * c.height);
	[self setFrameSize:NSMakeSize(w, h)];
	[self setNeedsDisplay:YES];
}
- (void)resizeWithOldSuperviewSize:(NSSize)old { [self refresh]; }
- (void)drawRect:(NSRect)dirty {
	NSArray *items = mffItems(self.table);
	NSInteger selected = [self.table selectedRow];
	[[NSColor controlBackgroundColor] setFill];
	NSRectFill(dirty);
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	[ps setAlignment:self.small ? NSTextAlignmentLeft : NSTextAlignmentCenter];
	[ps setLineBreakMode:self.small ? NSLineBreakByTruncatingTail : NSLineBreakByWordWrapping];
	for (NSInteger i = 0; i < (NSInteger)[items count]; i++) {
		NSRect r = [self rectOfItem:i];
		if (!NSIntersectsRect(r, dirty)) continue;
		id item = items[i];
		NSString *cell = [item isKindOfClass:[NSArray class]] ? ([item count] ? item[0] : @"") : item;
		NSImage *img = nil;
		if ([cell hasPrefix:@"\x01"]) {
			NSRange end = [cell rangeOfString:@"\x01" options:0 range:NSMakeRange(1, [cell length] - 1)];
			if (end.location != NSNotFound) img = [[NSImage alloc] initWithContentsOfFile:[cell substringWithRange:NSMakeRange(1, end.location - 1)]];
		}
		if (!img) img = [NSImage imageNamed:NSImageNameMultipleDocuments];
		BOOL sel = i == selected;
		NSRect pic = self.small ? NSMakeRect(NSMinX(r) + 4, NSMinY(r) + 4, 16, 16) : NSMakeRect(NSMidX(r) - 24, NSMinY(r) + 6, 48, 48);
		NSRect txt = self.small ? NSMakeRect(NSMinX(r) + 24, NSMinY(r) + 4, NSWidth(r) - 28, 18) : NSMakeRect(NSMinX(r) + 4, NSMinY(r) + 56, NSWidth(r) - 8, 34);
		if (sel) {
			[[NSColor selectedContentBackgroundColor] setFill];
			[[NSBezierPath bezierPathWithRoundedRect:self.small ? NSInsetRect(r, 1, 1) : txt xRadius:4 yRadius:4] fill];
		}
		[img drawInRect:pic fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1 respectFlipped:YES hints:nil];
		[mffCellText(cell) drawWithRect:txt options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:12], NSForegroundColorAttributeName: sel ? [NSColor alternateSelectedControlTextColor] : [NSColor controlTextColor], NSParagraphStyleAttributeName: ps} context:nil];
	}
}
- (void)mouseDown:(NSEvent *)e {
	[[self window] makeFirstResponder:self];
	NSPoint p = [self convertPoint:[e locationInWindow] fromView:nil];
	NSInteger hit = -1, count = [mffItems(self.table) count];
	for (NSInteger i = 0; i < count; i++) if (NSPointInRect(p, [self rectOfItem:i])) { hit = i; break; }
	self.clickedRow = hit;
	if (hit < 0) [self.table deselectAll:nil];
	else if (hit != [self.table selectedRow]) [self.table selectRowIndexes:[NSIndexSet indexSetWithIndex:hit] byExtendingSelection:NO];
	if ([e clickCount] == 2 && hit >= 0) [mffTarget() tableDoubleClick:self.table];
}
@end

@implementation MffTarget
- (void)action:(id)sender {
	void *ctrl = mffGetCtrl(sender);
	if (!ctrl) return;
	if ([sender isKindOfClass:[NSPopUpButton class]] || [sender isKindOfClass:[NSSlider class]] || [sender isKindOfClass:[NSStepper class]]) {
		mffOnChange(ctrl, [sender isKindOfClass:[NSPopUpButton class]] ? (int)[sender indexOfSelectedItem] : [sender intValue]);
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
		return i < [item count] ? mffCellValue(item[i]) : @"";
	}
	if (objc_getAssociatedObject(t, &kMffChecksKey)) return [([mffChecks(t) containsIndex:row] ? @"\u2611 " : @"\u2610 ") stringByAppendingString:item];
	return mffCellValue(item);
}
- (void)tableViewSelectionDidChange:(NSNotification *)n {
	if (mffSilent) return;
	NSTableView *t = [n object];
	NSView *v = mffTableScroll(t);
	void *ctrl = v ? mffGetCtrl(v) : NULL;
	if (objc_getAssociatedObject(t, &kMffFileViewKey)) { mffFileViewChoose(t, v, [t selectedRow], NO); return; }
	if (ctrl) mffOnChange(ctrl, (int)[t selectedRow]);
}
/* A click on a row of a CheckedListBox changes its check box */
- (void)tableClick:(NSTableView *)t {
	NSInteger row = mffClickedRow(t);
	if (row < 0 || !objc_getAssociatedObject(t, &kMffChecksKey)) return;
	if ([mffChecks(t) containsIndex:row]) [mffChecks(t) removeIndex:row]; else [mffChecks(t) addIndex:row];
	[t reloadData];
	void *ctrl = mffGetCtrl([t enclosingScrollView]);
	if (ctrl) mffOnChange(ctrl, (int)row);
}
/* The close button of a tab: a change with -1 - Index (TabControl.ProcessMessage) */
- (void)tabsClose:(NSButton *)b {
	void *ctrl = mffGetCtrl([b superview]);
	int index = (int)[b tag];
	if (ctrl) dispatch_async(dispatch_get_main_queue(), ^{ mffOnChange(ctrl, -1 - index); });
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
- (BOOL)validateMenuItem:(NSMenuItem *)m {
	if ([m action] != @selector(menuBarChosen:)) return [m isEnabled];
	int state = mffMenuState((int)[m tag]);
	if (state < 0) return [m isEnabled];
	[m setState:(state & 2) ? NSControlStateValueOn : NSControlStateValueOff];
	return (state & 1) != 0;
}
- (void)tableDoubleClick:(NSTableView *)t {
	NSView *v = mffTableScroll(t);
	void *ctrl = v ? mffGetCtrl(v) : NULL;
	if (!ctrl) return;
	if (objc_getAssociatedObject(t, &kMffFileViewKey)) { mffFileViewChoose(t, v, [t clickedRow], YES); return; }
	/* ListView, TreeView: the double click is a change with TableDblClick */
	if (objc_getAssociatedObject(t, &kMffTableKey)) {
		mffDblClick = 1;
		mffOnChange(ctrl, (int)mffClickedRow(t));
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
	if ([v isKindOfClass:[NSScrollView class]] && [[(NSScrollView *)v documentView] isKindOfClass:[MffIconGrid class]]) return ((MffIconGrid *)[(NSScrollView *)v documentView]).table;
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
/* A scroll bar with the thumb of the size of the page (NSSlider has no page, NSScroller of the system hides itself) */
@interface MffScrollBar : NSView
@property (nonatomic) int mffMin, mffMax, mffPage, mffPos;
@property (nonatomic) CGFloat mffGrab;
@property (nonatomic) BOOL mffDragging;
@end

@implementation MffScrollBar
- (BOOL)isFlipped { return YES; }
- (BOOL)mffVertical { return self.bounds.size.height >= self.bounds.size.width; }
- (CGFloat)mffLength { return [self mffVertical] ? self.bounds.size.height : self.bounds.size.width; }
- (CGFloat)mffThumbLength {
	CGFloat l = [self mffLength];
	int range = self.mffMax - self.mffMin;
	if (range <= 0) return l;
	return MIN(l, MAX(24, self.mffPage > 0 ? l * self.mffPage / (range + self.mffPage) : 24));
}
- (CGFloat)mffThumbOffset {
	int range = self.mffMax - self.mffMin;
	return range > 0 ? ([self mffLength] - [self mffThumbLength]) * (self.mffPos - self.mffMin) / range : 0;
}
- (void)mffUserPosition:(int)value {
	value = MAX(self.mffMin, MIN(value, self.mffMax));
	if (value == self.mffPos) return;
	self.mffPos = value;
	[self setNeedsDisplay:YES];
	void *ctrl = mffGetCtrl(self);
	if (ctrl) mffOnChange(ctrl, value);
}
- (void)mffPress:(CGFloat)a {
	CGFloat off = [self mffThumbOffset];
	if (a >= off && a <= off + [self mffThumbLength]) { self.mffGrab = a - off; self.mffDragging = YES; return; }
	self.mffDragging = NO;
	int step = self.mffPage > 0 ? self.mffPage : 1;
	[self mffUserPosition:self.mffPos + (a < off ? -step : step)];
}
- (void)mffDrag:(CGFloat)a {
	CGFloat free = [self mffLength] - [self mffThumbLength];
	if (self.mffDragging && free > 0) [self mffUserPosition:self.mffMin + (int)lround((a - self.mffGrab) / free * (self.mffMax - self.mffMin))];
}
- (CGFloat)mffAxis:(NSEvent *)e {
	NSPoint p = [self convertPoint:[e locationInWindow] fromView:nil];
	return [self mffVertical] ? p.y : p.x;
}
- (void)mouseDown:(NSEvent *)e { [self mffPress:[self mffAxis:e]]; }
- (void)mouseDragged:(NSEvent *)e { [self mffDrag:[self mffAxis:e]]; }
- (void)drawRect:(NSRect)r {
	[[NSColor controlBackgroundColor] setFill];
	NSRectFill(self.bounds);
	if (self.mffMax <= self.mffMin) return;
	NSRect t = [self mffVertical] ? NSMakeRect(0, [self mffThumbOffset], self.bounds.size.width, [self mffThumbLength]) : NSMakeRect([self mffThumbOffset], 0, [self mffThumbLength], self.bounds.size.height);
	t = NSInsetRect(t, 3, 3);
	CGFloat radius = MIN(t.size.width, t.size.height) / 2;
	[[[NSColor labelColor] colorWithAlphaComponent:0.35] setFill];
	[[NSBezierPath bezierPathWithRoundedRect:t xRadius:radius yRadius:radius] fill];
}
@end

/* A LinkLabel: a text with links (the markup of a SysLink) */
@interface MffLinkField : NSTextField
@end

static NSString *mffLastLink = @"";

@implementation MffLinkField
- (void)mouseDown:(NSEvent *)e {
	NSAttributedString *text = [self attributedStringValue];
	NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:text];
	NSLayoutManager *layout = [[NSLayoutManager alloc] init];
	NSTextContainer *box = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(NSWidth([self bounds]) - 4, CGFLOAT_MAX)];
	[box setLineFragmentPadding:0];
	[layout addTextContainer:box];
	[storage addLayoutManager:layout];
	NSPoint p = [self convertPoint:[e locationInWindow] fromView:nil];
	p.x -= 2;
	CGFloat part = 1;
	NSUInteger i = [layout characterIndexForPoint:p inTextContainer:box fractionOfDistanceBetweenInsertionPoints:&part];
	id link = i < [text length] ? [text attribute:NSLinkAttributeName atIndex:i effectiveRange:NULL] : nil;
	void *ctrl = mffGetCtrl(self);
	if (!link || !ctrl) { [super mouseDown:e]; return; }
	mffLastLink = [link isKindOfClass:[NSURL class]] ? ([[(NSURL *)link relativeString] stringByRemovingPercentEncoding] ?: [(NSURL *)link relativeString]) : [link description];
	mffOnChange(ctrl, 0);
}
@end

/* A designed form: a view in the panel of the designer, its title bar is a view above it (the place of the frame of a window) */
@interface MffDesignBar : NSView
@property (nonatomic, copy) NSString *mffTitle;
@end

@implementation MffDesignBar
- (BOOL)isFlipped { return YES; }
- (NSView *)hitTest:(NSPoint)p { return nil; }
- (void)drawRect:(NSRect)r {
	NSRect b = [self bounds];
	[[NSColor windowBackgroundColor] setFill];
	NSRectFill(b);
	[[NSColor separatorColor] setFill];
	NSRectFill(NSMakeRect(0, NSHeight(b) - 1, NSWidth(b), 1));
	NSArray *lights = @[[NSColor systemRedColor], [NSColor systemYellowColor], [NSColor systemGreenColor]];
	for (NSUInteger i = 0; i < 3; i++) {
		[(NSColor *)lights[i] setFill];
		[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(8 + i * 20, (NSHeight(b) - 12) / 2, 12, 12)] fill];
	}
	NSDictionary *a = @{NSFontAttributeName: [NSFont titleBarFontOfSize:13], NSForegroundColorAttributeName: [NSColor labelColor]};
	NSSize s = self.mffTitle ? [self.mffTitle sizeWithAttributes:a] : NSZeroSize;
	[self.mffTitle drawAtPoint:NSMakePoint(MAX(72, (NSWidth(b) - s.width) / 2), (NSHeight(b) - s.height) / 2) withAttributes:a];
}
@end

@interface MffDesignedForm : MffView
@property (nonatomic, strong) MffDesignBar *bar;
/* The native control (NSButton, NSTextField...) under the mouse and the one which got the press */
@property (nonatomic, weak) NSView *mffHitView, *mffMouseView;
- (void)placeBar;
@end

@implementation MffDesignedForm
/* The native controls of the designed form do not take the mouse (a button would be pressed): the form gets the events
   and gives them to the designer as the ones of the control, like the views of MyFbFramework (its clicks and double
   clicks select the control and open its event) */
- (NSView *)hitTest:(NSPoint)p {
	NSView *hit = [super hitTest:p];
	self.mffHitView = nil;
	if (hit && hit != self && ![hit isKindOfClass:[MffView class]]) {
		NSView *v = hit;
		while (v && v != self && !mffGetCtrl(v)) v = [v superview];
		if (v && v != self) { self.mffHitView = v; return self; }
	}
	return hit;
}
- (void)mouse:(NSEvent *)e action:(int)action button:(int)button {
	NSView *v = self.mffMouseView;
	if (!v || !mffGetCtrl(v)) { [super mouse:e action:action button:button]; return; }
	NSPoint p = [v convertPoint:[e locationInWindow] fromView:nil];
	mffOnMouse(mffGetCtrl(v), action, button, (int)p.x, (int)p.y, mffShift([e modifierFlags]));
}
- (void)mouseDown:(NSEvent *)e {
	self.mffMouseView = self.mffHitView;
	if (!self.mffMouseView) { [super mouseDown:e]; return; }
	[self mouse:e action:0 button:0];
}
- (void)mouseUp:(NSEvent *)e {
	if (!self.mffMouseView) { [super mouseUp:e]; return; }
	[self mouse:e action:1 button:0];
	self.mffMouseView = nil;
}
- (void)rightMouseDown:(NSEvent *)e { self.mffMouseView = self.mffHitView; [self mouse:e action:0 button:1]; }
- (void)rightMouseUp:(NSEvent *)e { [self mouse:e action:1 button:1]; self.mffMouseView = nil; }
- (void)placeBar {
	NSView *p = [self superview];
	if (!p) { [self.bar removeFromSuperview]; return; }
	if (!self.bar) self.bar = [[MffDesignBar alloc] initWithFrame:NSZeroRect];
	if ([self.bar superview] != p) [p addSubview:self.bar positioned:NSWindowAbove relativeTo:self];
	NSRect f = [self frame];
	[self.bar setFrame:NSMakeRect(NSMinX(f), NSMinY(f) - 28, NSWidth(f), 28)];
	[self.bar setHidden:[self isHidden]];
}
- (void)viewDidMoveToSuperview { [super viewDidMoveToSuperview]; [self placeBar]; }
- (void)setFrame:(NSRect)f { [super setFrame:f]; [self placeBar]; }
- (void)setHidden:(BOOL)h { [super setHidden:h]; [self placeBar]; }
@end

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
@property (nonatomic, strong) NSMutableArray<NSButton *> *closeButtons;
@property (nonatomic, strong) NSSegmentedControl *segments;
@property (nonatomic) int tabPosition;
- (void)layoutStrip;
@end

@implementation MffTabsView
- (void)layoutStrip {
	/* 3 - at the bottom; 0 - on the left, 1 - on the right: NSSegmentedControl has no vertical form, the strip is turned
	   clockwise (the first tab is at the top) */
	NSRect b = [self bounds];
	CGFloat h = mffTabsStripHeight(), y = self.tabPosition == 3 ? b.size.height - h : 0;
	BOOL vertical = self.tabPosition == 0 || self.tabPosition == 1;
	[self.segments setFrameCenterRotation:0];
	if (vertical) {
		CGFloat cx = self.tabPosition == 0 ? h / 2 : b.size.width - h / 2, cy = b.size.height / 2;
		[self.segments setFrame:NSMakeRect(cx - b.size.height / 2, cy - h / 2, b.size.height, h)];
		/* The view is flipped: a positive angle turns it clockwise on the screen */
		[self.segments setFrameCenterRotation:90];
	} else {
		[self.segments setFrame:NSMakeRect(0, y, b.size.width, h)];
	}
	NSInteger count = [self.segments segmentCount];
	for (NSButton *c in self.closeButtons) {
		[c setHidden:vertical];
		[c setFrame:NSMakeRect(([c tag] + 1) * b.size.width / MAX(count, 1) - 20, y + (h - 16) / 2, 16, 16)];
	}
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
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) BOOL column;
@property (nonatomic, strong) NSMutableSet *expandGaps;
- (void)layoutExpand;
@end

@implementation MffButtonsView
/* The gaps of Expand (flag 7) share the free width of the bar, what is after them moves */
- (void)layoutExpand {
	if (self.column || ![self.expandGaps count]) return;
	CGFloat free = [self bounds].size.width - self.contentWidth, x, end = 0;
	CGFloat more = MAX(0, free) / [self.expandGaps count];
	for (id b in self.buttons) {
		if (![b isKindOfClass:[NSView class]]) continue;
		NSView *view = b;
		BOOL expand = [self.expandGaps containsObject:view];
		NSRect f = [view frame];
		/* The gap of a separator before the view stays */
		CGFloat gap = [objc_getAssociatedObject(view, &kMffGapKey) doubleValue];
		x = end + gap;
		f.origin.x = x;
		if (expand) f.size.width = [objc_getAssociatedObject(view, &kMffLeastKey) doubleValue] + more;
		[view setFrame:f];
		end = x + f.size.width;
	}
}
- (void)setFrameSize:(NSSize)s {
	[super setFrameSize:s];
	[self layoutExpand];
}
/* A palette (a column of items) scrolls with the wheel */
- (void)scrollWheel:(NSEvent *)e {
	if (!self.column) { [super scrollWheel:e]; return; }
	CGFloat most = MAX(0, self.contentHeight - [self bounds].size.height);
	[self setBoundsOrigin:NSMakePoint(0, MIN(most, MAX(0, [self bounds].origin.y - [e scrollingDeltaY])))];
	[self setNeedsDisplay:YES];
}
@end

void *mffViewCreate(const char *kind, void *ctrl) {
	mffEnsureApp();
	NSString *k = mffStr(kind);
	NSRect r = NSMakeRect(0, 0, 100, 30);
	id obj = nil;
	MffTarget *t = mffTarget();
	if ([k isEqualToString:@"DesignedForm"]) {
		obj = [[MffDesignedForm alloc] initWithFrame:r];
	} else if ([k isEqualToString:@"Form"]) {
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
	} else if ([k isEqualToString:@"UpDown"]) {
		NSStepper *s = [[NSStepper alloc] initWithFrame:r];
		[s setMinValue:0];
		[s setMaxValue:100];
		[s setTarget:t];
		[s setAction:@selector(action:)];
		obj = s;
	} else if ([k isEqualToString:@"Label"] || [k isEqualToString:@"LinkLabel"] || [k isEqualToString:@"StatusBar"]) {
		NSTextField *f = [k isEqualToString:@"LinkLabel"] ? [MffLinkField labelWithString:@""] : [NSTextField labelWithString:@""];
		[f setFrame:r];
		[[f cell] setWraps:YES];
		[f setLineBreakMode:NSLineBreakByWordWrapping];
		obj = f;
	} else if ([k isEqualToString:@"SearchBox"]) {
		/* A text field with the search glass and the clear button: the functions of the text of NSTextField */
		NSSearchField *f = [[NSSearchField alloc] initWithFrame:r];
		[f setDelegate:t];
		[[f cell] setScrollable:YES];
		obj = f;
	} else if ([k isEqualToString:@"TextBox"] || [k isEqualToString:@"DateTimePicker"] || [k isEqualToString:@"IPAddress"] || [k isEqualToString:@"HotKey"]) {
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
		NSTableView *tv = [[MffTableView alloc] initWithFrame:[[s contentView] bounds]];
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
	} else if ([k isEqualToString:@"HScrollBar"] || [k isEqualToString:@"VScrollBar"] || [k isEqualToString:@"ScrollBarControl"]) {
		MffScrollBar *s = [[MffScrollBar alloc] initWithFrame:r];
		s.mffMax = 10;
		obj = s;
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
	/* A table: the child (an editor of a cell) is in the table, it scrolls with its rows */
	NSView *p = mffTable(parent) ?: (__bridge NSView *)mffViewLayout(parent);
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
	if ([o isKindOfClass:[MffDesignedForm class]]) {
		((MffDesignedForm *)o).bar.mffTitle = s;
		[((MffDesignedForm *)o).bar setNeedsDisplay:YES];
	}
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

void mffTextScrollTo(void *view, int toEnd) {
	NSTextView *t = mffTextView(view);
	if (t) [t scrollRangeToVisible:toEnd ? NSMakeRange([[t string] length], 0) : [t selectedRange]];
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

const char *mffLinkClicked(void) {
	return [mffLastLink UTF8String];
}

/* The text with its formatting: {\\rtf or {\\urtf (the text is not in code pages) */
void mffTextSetRTF(void *view, const char *rtf) {
	NSTextView *tv = mffTextView(view);
	if (!tv) return;
	NSString *s = mffStr(rtf);
	s = [s stringByReplacingOccurrencesOfString:@"\\urtf1" withString:@"\\rtf1\\ansi "];
	/* Lines of a comment and the letters which are not ASCII */
	s = [[s stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\par "] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\par "];
	NSMutableString *out = [NSMutableString string];
	for (NSUInteger i = 0; i < [s length]; i++) {
		unichar c = [s characterAtIndex:i];
		if (c > 126) [out appendFormat:@"\\u%d?", (int)(short)c]; else [out appendFormat:@"%C", c];
	}
	NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithRTF:[out dataUsingEncoding:NSASCIIStringEncoding] documentAttributes:nil];
	if (!a) { [tv setString:mffStr(rtf)]; return; }
	[a addAttribute:NSForegroundColorAttributeName value:[NSColor labelColor] range:NSMakeRange(0, [a length])];
	[tv setRichText:YES];
	[[tv textStorage] setAttributedString:a];
	[tv setNeedsDisplay:YES];
}

void mffLinkSetMarkup(void *view, const char *markup) {
	id o = mffObj(view);
	if (![o isKindOfClass:[NSTextField class]]) return;
	NSTextField *f = o;
	NSString *html = [NSString stringWithFormat:@"<meta charset=\"utf-8\"><span style=\"font-family:-apple-system;font-size:12px\">%@</span>", mffStr(markup)];
	NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithHTML:[html dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
	if (!a) { [f setStringValue:mffStr(markup)]; return; }
	NSRange all = NSMakeRange(0, [a length]);
	NSColor *color = [f textColor] ?: [NSColor labelColor];
	[a addAttribute:NSForegroundColorAttributeName value:color range:all];
	[a enumerateAttribute:NSLinkAttributeName inRange:all options:0 usingBlock:^(id link, NSRange r, BOOL *stop) {
		if (link) [a addAttribute:NSForegroundColorAttributeName value:[NSColor linkColor] range:r];
	}];
	[f setAttributedStringValue:a];
}

void mffSelectItemImage(void *view, int index, const char *path, int indent) {
	id o = mffObj(view);
	NSTableView *t = mffTable(view);
	/* A ComboBoxEx with UseListView: the picture in the text of its row */
	if (t) {
		NSMutableArray *rows = mffItems(t);
		if (index < 0 || index >= (int)[rows count] || !path || !*path || ![rows[index] isKindOfClass:[NSString class]]) return;
		rows[index] = [NSString stringWithFormat:@"\x01%@\x01%@", mffStr(path), rows[index]];
		[t reloadData];
		return;
	}
	if (![o isKindOfClass:[NSPopUpButton class]] || index < 0 || index >= [(NSPopUpButton *)o numberOfItems]) return;
	NSMenuItem *m = [(NSPopUpButton *)o itemAtIndex:index];
	NSImage *img = (path && *path) ? [[NSImage alloc] initWithContentsOfFile:mffStr(path)] : nil;
	[img setSize:NSMakeSize(16, 16)];
	[m setImage:img];
	[m setIndentationLevel:MAX(0, MIN(indent, 15))];
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
	else if ([o isKindOfClass:[NSStepper class]]) { [(NSStepper *)o setMinValue:minValue]; [(NSStepper *)o setMaxValue:maxValue]; }
	else if ([o isKindOfClass:[MffScrollBar class]]) { MffScrollBar *b = o; b.mffMin = minValue; b.mffMax = maxValue; b.mffPos = MAX(minValue, MIN(b.mffPos, maxValue)); [b setNeedsDisplay:YES]; }
}

void mffScrollPageSet(void *view, int page) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffScrollBar class]]) { ((MffScrollBar *)o).mffPage = page; [(NSView *)o setNeedsDisplay:YES]; }
}

void mffPositionSet(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffTabsView class]]) {
		/* -1: no tab is selected (a closed panel of the IDE) */
		NSSegmentedControl *seg = ((MffTabsView *)o).segments;
		if (value >= 0 && value < [seg segmentCount]) [seg setSelectedSegment:value];
		else if (value < 0 && [seg selectedSegment] >= 0) [seg setSelected:NO forSegment:[seg selectedSegment]];
	}
	else if ([o isKindOfClass:[NSProgressIndicator class]]) [(NSProgressIndicator *)o setDoubleValue:value];
	else if ([o isKindOfClass:[NSSlider class]]) [(NSSlider *)o setIntValue:value];
	else if ([o isKindOfClass:[NSStepper class]]) [(NSStepper *)o setIntValue:value];
	else if ([o isKindOfClass:[MffScrollBar class]]) { ((MffScrollBar *)o).mffPos = value; [(NSView *)o setNeedsDisplay:YES]; }
}

void mffMarqueeSet(void *view, int marqueeOn) {
	id o = mffObj(view);
	if (![o isKindOfClass:[NSProgressIndicator class]]) return;
	NSProgressIndicator *p = o;
	[p setIndeterminate:marqueeOn != 0];
	if (marqueeOn) [p startAnimation:nil]; else [p stopAnimation:nil];
}

int mffPositionGet(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffTabsView class]]) return (int)[((MffTabsView *)o).segments selectedSegment];
	if ([o isKindOfClass:[NSProgressIndicator class]]) return (int)[(NSProgressIndicator *)o doubleValue];
	if ([o isKindOfClass:[NSSlider class]]) return [(NSSlider *)o intValue];
	if ([o isKindOfClass:[NSStepper class]]) return [(NSStepper *)o intValue];
	if ([o isKindOfClass:[MffScrollBar class]]) return ((MffScrollBar *)o).mffPos;
	return 0;
}

void mffFormShow(void *view, int modal) {
	NSWindow *w = mffWindow(view);
	if (!w) return;
	/* The test starts with the first window: a program can show a modal form before App.Run */
	mffStartSnapshotTest();
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
	/* The bar of the menu is not in the windows: its items in a text */
	NSMutableString *menu = [NSMutableString string];
	__block __weak void (^weakDump)(NSMenu *, int);
	void (^dump)(NSMenu *, int) = ^(NSMenu *m, int level) {
		for (NSMenuItem *mi in [m itemArray]) {
			[menu appendFormat:@"%*s%@%@\n", level * 2, "", [mi isSeparatorItem] ? @"-" : [mi title], [mi isEnabled] ? @"" : @" (disabled)"];
			if ([mi submenu]) weakDump([mi submenu], level + 1);
		}
	};
	weakDump = dump;
	dump([NSApp mainMenu], 0);
	[menu writeToFile:[NSString stringWithFormat:@"%@_%d_menu.txt", base, step] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

static NSButton *mffFindButton(NSView *v, NSString *title) {
	if ([v isKindOfClass:[NSButton class]] && [mffNoMnemonic([(NSButton *)v title]) isEqualToString:title]) return (NSButton *)v;
	for (NSView *s in [v subviews]) {
		NSButton *b = mffFindButton(s, title);
		if (b) return b;
	}
	return nil;
}

static MffIconGrid *mffFindGrid(NSView *v) {
	if ([v isKindOfClass:[MffIconGrid class]] && ![v isHiddenOrHasHiddenAncestor]) return (MffIconGrid *)v;
	for (NSView *s in [v subviews]) {
		MffIconGrid *g = mffFindGrid(s);
		if (g) return g;
	}
	return nil;
}

/* The events of a double click on the item of an icon view with that text */
static BOOL mffDoubleClickItem(NSString *text) {
	for (NSWindow *w in [NSApp windows]) {
		if (![w isVisible]) continue;
		MffIconGrid *g = mffFindGrid([w contentView]);
		NSArray *items = g ? mffItems(g.table) : nil;
		for (NSInteger i = 0; i < (NSInteger)[items count]; i++) {
			id item = items[i];
			if (![mffCellText([item isKindOfClass:[NSArray class]] ? item[0] : item) isEqualToString:text]) continue;
			NSRect r = [g rectOfItem:i];
			NSPoint p = [g convertPoint:NSMakePoint(NSMidX(r), NSMidY(r)) toView:nil];
			for (int n = 1; n <= 2; n++) {
				for (int up = 0; up <= 1; up++) {
					[w sendEvent:[NSEvent mouseEventWithType:up ? NSEventTypeLeftMouseUp : NSEventTypeLeftMouseDown location:p modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil eventNumber:n clickCount:n pressure:up ? 0 : 1]];
				}
			}
			return YES;
		}
	}
	return NO;
}

/* The mouse events of a click on the button (not performClick) */
static BOOL mffRealClick(NSString *title) {
	for (NSWindow *w in [NSApp windows]) {
		if (![w isVisible]) continue;
		NSButton *b = mffFindButton([w contentView], title);
		if (!b) continue;
		NSPoint p = [b convertPoint:NSMakePoint(NSMidX([b bounds]), NSMidY([b bounds])) toView:nil];
		fprintf(stderr, "MFF_WINDOW %ld\n", (long)[w windowNumber]);
		[NSApp postEvent:[NSEvent mouseEventWithType:NSEventTypeLeftMouseUp location:p modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil eventNumber:2 clickCount:1 pressure:0] atStart:NO];
		[w sendEvent:[NSEvent mouseEventWithType:NSEventTypeLeftMouseDown location:p modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil eventNumber:1 clickCount:1 pressure:1]];
		return YES;
	}
	return NO;
}

/* MFF_SCRIPT=btn:Caption;dbl:Item;pt:x,y;drag:x1,y1,x2,y2;key:Text;ctrl:Key the events one after the other (x, y: the points of a
   window picture of mffSnapshot in the key window); a picture as Name_10+i_*.png after each one, then the program ends */
static void mffSendMouse(NSWindow *w, NSEventType type, NSPoint p, int count) {
	[w sendEvent:[NSEvent mouseEventWithType:type location:p modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil eventNumber:0 clickCount:count pressure:type == NSEventTypeLeftMouseUp ? 0 : 1]];
}

static void mffRunScript(NSString *base, NSArray *steps, NSUInteger i) {
	if (i >= [steps count]) exit(0);
	NSString *step = steps[i];
	NSRange colon = [step rangeOfString:@":"];
	NSString *cmd = colon.location == NSNotFound ? step : [step substringToIndex:colon.location];
	NSString *arg = colon.location == NSNotFound ? @"" : [step substringFromIndex:colon.location + 1];
	/* The biggest window: the program may not be the active one */
	NSWindow *w = nil;
	for (NSWindow *o in [NSApp windows]) if ([o isVisible] && (!w || NSWidth([o frame]) * NSHeight([o frame]) > NSWidth([w frame]) * NSHeight([w frame]))) w = o;
	[NSApp activateIgnoringOtherApps:YES];
	[w makeKeyAndOrderFront:nil];
	NSArray *n = [arg componentsSeparatedByString:@","];
	CGFloat h = NSHeight([w frame]);
	if ([cmd isEqualToString:@"btn"]) { if (!mffRealClick(arg)) fprintf(stderr, "MFF_SCRIPT: no button \"%s\"\n", [arg UTF8String]); }
	else if ([cmd isEqualToString:@"dbl"]) { if (!mffDoubleClickItem(arg)) fprintf(stderr, "MFF_SCRIPT: no item \"%s\"\n", [arg UTF8String]); }
	else if ([cmd isEqualToString:@"pt"] && [n count] == 2) {
		NSPoint p = NSMakePoint([n[0] doubleValue], h - [n[1] doubleValue]);
		/* A window of a program which is not the active one takes the first click of a table for itself: its row is selected here */
		NSView *hit = [[[w contentView] superview] hitTest:p];
		if ([hit isKindOfClass:[NSTableView class]]) {
			NSInteger row = [(NSTableView *)hit rowAtPoint:[hit convertPoint:p fromView:nil]];
			if (row >= 0) [(NSTableView *)hit selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
		} else {
				/* The up event is waiting: a table or a button follows the mouse in a loop of its own */
		[NSApp postEvent:[NSEvent mouseEventWithType:NSEventTypeLeftMouseUp location:p modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil eventNumber:0 clickCount:1 pressure:0] atStart:NO];
		mffSendMouse(w, NSEventTypeLeftMouseDown, p, 1);
		}
	} else if ([cmd isEqualToString:@"drag"] && [n count] == 4) {
		NSPoint a = NSMakePoint([n[0] doubleValue], h - [n[1] doubleValue]), b = NSMakePoint([n[2] doubleValue], h - [n[3] doubleValue]);
		mffSendMouse(w, NSEventTypeLeftMouseDown, a, 1);
		mffSendMouse(w, NSEventTypeLeftMouseDragged, NSMakePoint((a.x + b.x) / 2, (a.y + b.y) / 2), 1);
		mffSendMouse(w, NSEventTypeLeftMouseDragged, b, 1);
		mffSendMouse(w, NSEventTypeLeftMouseUp, b, 1);
	} else if ([cmd isEqualToString:@"ctrl"] && [arg length] == 1) {
		/* ctrl:C - the key with the Control key (the shortcuts of the menus) */
		NSString *ch = [arg lowercaseString];
		static const unsigned short codes[26] = {0, 11, 8, 2, 14, 3, 5, 4, 34, 38, 40, 37, 46, 45, 31, 35, 12, 15, 1, 17, 32, 9, 13, 7, 16, 6};
		unichar u = [ch characterAtIndex:0];
		unsigned short code = (u >= 'a' && u <= 'z') ? codes[u - 'a'] : 0;
		[w sendEvent:[NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:NSEventModifierFlagControl timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil characters:ch charactersIgnoringModifiers:ch isARepeat:NO keyCode:code]];
		[w sendEvent:[NSEvent keyEventWithType:NSEventTypeKeyUp location:NSZeroPoint modifierFlags:NSEventModifierFlagControl timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil characters:ch charactersIgnoringModifiers:ch isARepeat:NO keyCode:code]];
	} else if ([cmd isEqualToString:@"key"]) {
		for (NSUInteger c = 0; c < [arg length]; c++) {
			NSString *ch = [arg substringWithRange:NSMakeRange(c, 1)];
			[w sendEvent:[NSEvent keyEventWithType:NSEventTypeKeyDown location:NSZeroPoint modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil characters:ch charactersIgnoringModifiers:ch isARepeat:NO keyCode:[ch isEqualToString:@" "] ? 49 : 0]];
			[w sendEvent:[NSEvent keyEventWithType:NSEventTypeKeyUp location:NSZeroPoint modifierFlags:0 timestamp:[NSProcessInfo processInfo].systemUptime windowNumber:[w windowNumber] context:nil characters:ch charactersIgnoringModifiers:ch isARepeat:NO keyCode:[ch isEqualToString:@" "] ? 49 : 0]];
		}
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1500 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
		mffSnapshot(base, (int)(10 + i));
		mffRunScript(base, steps, i + 1);
	});
}

static void mffStartSnapshotTest(void) {
	static BOOL started;
	const char *snap = getenv("MFF_SNAPSHOT");
	if (started || !snap || !*snap) return;
	started = YES;
	NSString *base = mffStr(snap);
	NSString *click = mffStr(getenv("MFF_CLICK"));
	__block int step = 0;
	const char *delay = getenv("MFF_SNAPSHOT_DELAY");
	NSTimer *tm = [NSTimer timerWithTimeInterval:(delay && atof(delay) > 0) ? atof(delay) : 2.0 repeats:YES block:^(NSTimer *t) {
		step++;
		mffSnapshot(base, step);
		if (step == 1 && getenv("MFF_SCRIPT")) {
			[t invalidate];
			mffRunScript(base, [mffStr(getenv("MFF_SCRIPT")) componentsSeparatedByString:@";"], 0);
			return;
		}
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

/* InputBox: an NSAlert with a text field, OK and Cancel */
char *mffInputBox(const char *caption, const char *msg, const char *defaultText, int password) {
	mffEnsureApp();
	NSAlert *a = [[NSAlert alloc] init];
	[a setMessageText:(caption && *caption) ? mffStr(caption) : [[NSProcessInfo processInfo] processName]];
	[a setInformativeText:mffStr(msg)];
	[a setIcon:[NSImage imageNamed:NSImageNameInfo]];
	[a addButtonWithTitle:@"OK"];
	[a addButtonWithTitle:@"Cancel"];
	NSTextField *f = password ? [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)] : [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)];
	[f setStringValue:mffStr(defaultText)];
	[a setAccessoryView:f];
	[[a window] setInitialFirstResponder:f];
	[NSApp activateIgnoringOtherApps:YES];
	if ([a runModal] != NSAlertFirstButtonReturn) return NULL;
	return mffDup([f stringValue]);
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
	NSTableView *t = mffTable(view);
	NSScrollView *s = (NSScrollView *)mffView(view);
	if (![t isKindOfClass:[MffTableView class]]) return;
	NSString *name = mffStr(viewName);
	MffIconGrid *g = ((MffTableView *)t).grid;
	if ([name isEqualToString:@"report"] || ![name length]) {
		if (g) { objc_setAssociatedObject(t, &kMffTableScrollKey, nil, OBJC_ASSOCIATION_ASSIGN); ((MffTableView *)t).grid = nil; [s setDocumentView:t]; }
		return;
	}
	if (!g) {
		g = [[MffIconGrid alloc] initWithFrame:[[s contentView] bounds]];
		g.table = t;
		g.clickedRow = -1;
		((MffTableView *)t).grid = g;
		objc_setAssociatedObject(t, &kMffTableScrollKey, s, OBJC_ASSOCIATION_ASSIGN);
		/* The scroll view keeps the table, the document view is now the grid */
		objc_setAssociatedObject(s, &kMffGridTableKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[s setDocumentView:g];
	}
	g.small = ![name isEqualToString:@"icon"];
	[g refresh];
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
	MffTabsView *tabs = o;
	for (NSButton *c in tabs.closeButtons) [c removeFromSuperview];
	tabs.closeButtons = [NSMutableArray array];
	[seg setSegmentDistribution:NSSegmentDistributionFillEqually];
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		if ([f count] < 2 || ![f[1] length]) continue;
		NSButton *c = [NSButton buttonWithTitle:@"\u00D7" target:mffTarget() action:@selector(tabsClose:)];
		[c setBordered:NO];
		[c setTag:i];
		[tabs addSubview:c];
		[tabs.closeButtons addObject:c];
	}
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
	CGFloat x = 0, y = 0, rowHeight = 0, width = [v bounds].size.width, right = 0, rowEnd = 0;
	v.expandGaps = [NSMutableSet set];
	/* The first item 5: the items are in a column (ToolPalette), it is not an item of the control */
	v.column = [lines count] > 0 && [lines[0] isEqualToString:@"5"];
	NSUInteger firstLine = v.column ? 1 : 0;
	for (NSUInteger i = firstLine; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		NSString *first = f[0];
		unichar flag = [first length] ? [first characterAtIndex:0] : '0';
		if (flag == '4' || flag == '3') {
			[v.buttons addObject:[NSNull null]];
			if (flag == '3') x += 8;
			continue;
		}
		/* A custom button: the gap of its control (ToolBar puts the control over it) */
		if (flag == '6' || flag == '7') {
			CGFloat gap = [[first substringFromIndex:1] doubleValue];
			NSView *g = [[NSView alloc] initWithFrame:NSMakeRect(x, y, gap, 24)];
			[v addSubview:g];
			[v.buttons addObject:g];
			objc_setAssociatedObject(g, &kMffGapKey, @(x - rowEnd), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			if (flag == '7') {
				objc_setAssociatedObject(g, &kMffLeastKey, @(gap), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
				[v.expandGaps addObject:g];
			}
			x += gap;
			rowEnd = x;
			right = MAX(right, x);
			rowHeight = MAX(rowHeight, 24);
			continue;
		}
		NSString *text = [first length] > 1 ? mffNoMnemonic([first substringFromIndex:1]) : @"";
		NSString *options = [f count] > 2 ? f[2] : @"";
		NSImage *img = ([f count] > 1 && [f[1] length]) ? [[NSImage alloc] initWithContentsOfFile:f[1]] : nil;
		NSButton *b = [[NSButton alloc] initWithFrame:NSZeroRect];
		[b setBordered:NO];
		[b setButtonType:flag == '2' ? NSButtonTypePushOnPushOff : NSButtonTypeMomentaryChange];
		/* The cell shows no alternate image (it is empty): without this the picture goes away while pressed and when checked */
		[[b cell] setHighlightsBy:NSNoCellMask];
		[[b cell] setShowsStateBy:NSNoCellMask];
		if (flag == '2') {
			[b setState:NSControlStateValueOn];
			[b setWantsLayer:YES];
			[[b layer] setBackgroundColor:[[[NSColor controlAccentColor] colorWithAlphaComponent:0.3] CGColor]];
			[[b layer] setCornerRadius:4];
		}
		[b setEnabled:flag != '1'];
		if (img) {
			[b setImage:img];
			[b setImagePosition:[options rangeOfString:@"S"].location != NSNotFound ? NSImageLeft : NSImageOnly];
		}
		[b setTitle:(!img || [options rangeOfString:@"S"].location != NSNotFound) ? text : @""];
		/* The arrow of a button with a drop-down menu */
		if ([options rangeOfString:@"D"].location != NSNotFound || [options rangeOfString:@"W"].location != NSNotFound) {
			[b setTitle:[[b title] stringByAppendingString:@"\u25BE"]];
			if (img) [b setImagePosition:NSImageLeft];
		}
		if ([f count] > 3 && [f[3] length]) [b setToolTip:f[3]];
		[b setTag:i - firstLine];
		[b setTarget:mffTarget()];
		[b setAction:@selector(buttonsClick:)];
		[b sizeToFit];
		NSSize s = [b frame].size;
		s.width = MAX(s.width + 6, 24);
		s.height = MAX(s.height + 4, 24);
		/* Only a tall view (ToolPalette) has more rows: a ToolBar gets its width after its buttons (ReBar) */
		if (x > 0 && width > 0 && x + s.width > width && [v bounds].size.height >= s.height * 2) { x = 0; y += rowHeight; rowHeight = 0; }
		[b setFrame:NSMakeRect(x, y, s.width, s.height)];
		[v addSubview:b];
		[v.buttons addObject:b];
		objc_setAssociatedObject(b, &kMffGapKey, @(x - rowEnd), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		rowEnd = x + s.width;
		if (v.column) {
			y += s.height;
			right = MAX(right, s.width);
			continue;
		}
		x += s.width;
		right = MAX(right, x);
		rowHeight = MAX(rowHeight, s.height);
	}
	v.contentWidth = right;
	v.contentHeight = y + rowHeight;
	/* A palette is set again on each selection: it stays where it was scrolled */
	[v setBoundsOrigin:NSMakePoint(0, v.column ? MIN([v bounds].origin.y, MAX(0, v.contentHeight - [v bounds].size.height)) : 0)];
	[v layoutExpand];
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
			NSEventModifierFlags mask = 0;
			if ([keys rangeOfString:@"CTRL"].location != NSNotFound) mask |= NSEventModifierFlagCommand;
			if ([keys rangeOfString:@"SHIFT"].location != NSNotFound) mask |= NSEventModifierFlagShift;
			if ([keys rangeOfString:@"ALT"].location != NSNotFound) mask |= NSEventModifierFlagOption;
			/* F1 - F12 also without the modifiers, the other keys without them stay with the editor */
			int fn = ([key length] > 1 && [key hasPrefix:@"F"]) ? [[key substringFromIndex:1] intValue] : 0;
			NSString *equivalent = nil;
			if ([key length] == 1) equivalent = [key lowercaseString];
			else if (fn >= 1 && fn <= 35) equivalent = [NSString stringWithFormat:@"%C", (unichar)(NSF1FunctionKey + fn - 1)];
			else if (mask) {
				unichar c = 0;
				if ([key isEqualToString:@"DEL"] || [key isEqualToString:@"DELETE"]) c = NSDeleteFunctionKey;
				else if ([key isEqualToString:@"INS"] || [key isEqualToString:@"INSERT"]) c = NSInsertFunctionKey;
				else if ([key isEqualToString:@"HOME"]) c = NSHomeFunctionKey;
				else if ([key isEqualToString:@"END"]) c = NSEndFunctionKey;
				else if ([key isEqualToString:@"PGUP"] || [key isEqualToString:@"PAGEUP"]) c = NSPageUpFunctionKey;
				else if ([key isEqualToString:@"PGDN"] || [key isEqualToString:@"PAGEDOWN"]) c = NSPageDownFunctionKey;
				else if ([key isEqualToString:@"UP"]) c = NSUpArrowFunctionKey;
				else if ([key isEqualToString:@"DOWN"]) c = NSDownArrowFunctionKey;
				else if ([key isEqualToString:@"LEFT"]) c = NSLeftArrowFunctionKey;
				else if ([key isEqualToString:@"RIGHT"]) c = NSRightArrowFunctionKey;
				else if ([key isEqualToString:@"BREAK"] || [key isEqualToString:@"PAUSE"]) c = NSPauseFunctionKey;
				else if ([key isEqualToString:@"TAB"]) c = '\t';
				else if ([key isEqualToString:@"ENTER"]) c = '\r';
				else if ([key isEqualToString:@"SPACE"]) c = ' ';
				else if ([key isEqualToString:@"BACKSPACE"]) c = 8;
				if (c) equivalent = [NSString stringWithFormat:@"%C", c];
			}
			if (equivalent && (mask || fn)) { [mi setKeyEquivalent:equivalent]; [mi setKeyEquivalentModifierMask:mask]; }
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

static void mffMenuAutoenable(NSMenu *m) {
	[m setAutoenablesItems:YES];
	for (NSMenuItem *mi in [m itemArray]) if ([mi submenu]) mffMenuAutoenable([mi submenu]);
}

void mffMenuBarSet(const char *items) {
	mffEnsureApp();
	/* A new menu with setMainMenu: the items added to the menu of an active program are not shown in the bar */
	NSMenu *old = [NSApp mainMenu];
	NSMenuItem *appItem = [old itemAtIndex:0];
	[old removeItemAtIndex:0];
	NSMenu *bar = [[NSMenu alloc] init];
	[bar addItem:appItem];
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
		/* Enabled and Checked of the items change after it: they are asked before the menu opens and before a shortcut (validateMenuItem:) */
		mffMenuAutoenable([mi submenu]);
	}
	[NSApp setMainMenu:bar];
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

#define MFF_MAIN_THREAD_WRAPPERS
#include "../Apple/mffMainThread.h"
