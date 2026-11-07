/*
 * mffUIKit.m - MyFbFramework: the UIKit host of iOS (-d __USE_UIKIT__).
 * The functions are described in Apple/mffApple.h and Apple/mffApple.bi; build.sh links a program with it.
 * The main form fills the screen of the iPhone, the other forms are shown over it.
 */
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../Apple/mffMainThread.h"
#include "../Apple/mffApple.h"

static char kMffCtrlKey, kMffItemsKey, kMffChecksKey, kMffFileViewKey;
static void mffFileViewChoose(id table, id owner, NSInteger row, BOOL activate);
static BOOL mffSilent, mffRunning, mffFormResizing;
static int mffDblClick;
static UIWindow *mffMainWindow;
static UIView *mffMainFormView;
/* The bar of the menu (mffMenuBarSet) and its lines */
static UIView *mffMenuBar;
static NSString *mffMenuBarItems;
static void mffMenuBarOpen(NSUInteger start, int level, UIView *source);
/* The dark mode set before the window was made (the settings of a program are read before App.Run) */
static UIUserInterfaceStyle mffStyle = UIUserInterfaceStyleUnspecified;
static NSMutableArray<UIView *> *mffFormsToShow;

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
static UIColor *mffColor(int c) {
	return [UIColor colorWithRed:(c & 255) / 255.0 green:((c >> 8) & 255) / 255.0 blue:((c >> 16) & 255) / 255.0 alpha:1.0];
}

static UIViewController *mffTopController(void) {
	UIViewController *c = mffMainWindow.rootViewController;
	while (c.presentedViewController) c = c.presentedViewController;
	return c;
}

/* The events of the program after the one of UIKit: UIKit gives no other touches while it handles one, a MsgBox of the
   event (mffMessageBox waits in the run loop) could not be closed and would not be seen. A block of the run loop and not
   of the main queue of GCD: the actions of a UIAlertController come by the main queue, which gives no other block while
   one runs (the MsgBox or the pop-up menu of the event would wait for ever) */
static void mffAfterEvent(void (^block)(void)) {
	CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, block);
	CFRunLoopWakeUp(CFRunLoopGetMain());
}

/* The views made before UIApplicationMain (MyFbFramework makes the forms before App.Run): their gesture recognizers
   (of a scroll view, a table, a text view) are in no gesture environment, there is none yet. The first touch of one of
   them ended the program (UIGestureGraphEdge: the system gesture gate got no targetNode): when the program runs they
   are added again (mffRegisterGestures) */
static NSHashTable *mffEarlyViews;

static void mffRegisterGestures(UIView *v) {
	for (UIGestureRecognizer *g in [v.gestureRecognizers copy]) {
		[v removeGestureRecognizer:g];
		[v addGestureRecognizer:g];
	}
	for (UIView *sub in v.subviews) mffRegisterGestures(sub);
}

/* A view taken away (a closed form, the buttons and tabs made again): it is freed a second later. UIKit keeps its
   gesture recognizers for the next event, a freed one ends the program (UIGestureGraphEdge: no targetNode) */
static void mffRemoveView(UIView *v) {
	static NSMutableArray *dying;
	if (!v) return;
	[v removeFromSuperview];
	if (!dying) dying = [NSMutableArray array];
	[dying addObject:v];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{ [dying removeObject:v]; });
}

/* The modifiers of a key like mffShift of macOS: 1 - Shift, 2 - Ctrl (Command), 4 - Alt */
static int mffKeyShift(UIKeyModifierFlags f) {
	return ((f & UIKeyModifierShift) ? 1 : 0) | ((f & (UIKeyModifierCommand | UIKeyModifierControl)) ? 2 : 0) | ((f & UIKeyModifierAlternate) ? 4 : 0);
}

/* The key code of Windows (VK_*) of a key of a keyboard which gives no character (UIKeyboardHIDUsage), 0 - another key */
static int mffKeyVirtual(UIKey *k) API_AVAILABLE(ios(13.4)) {
	switch ((long)k.keyCode) {
	case 0x4F: return 0x27; case 0x50: return 0x25; case 0x51: return 0x28; case 0x52: return 0x26; /* arrows */
	case 0x4A: return 0x24; case 0x4D: return 0x23; case 0x4B: return 0x21; case 0x4E: return 0x22; /* Home End PgUp PgDn */
	case 0x4C: return 0x2E; case 0x29: return 0x1B; /* Delete, Esc */
	}
	if (k.keyCode >= 0x3A && k.keyCode <= 0x45) return 0x70 + (int)(k.keyCode - 0x3A); /* F1 - F12 */
	return 0;
}

/* A long press is the right button (the context menu of the control): a timer of the touch, not a gesture recognizer
   (the recognizers of the views of MyFbFramework ended the program in UIGestureGraphEdge). Fired: the press was the
   right button, the end of the touch is no click */
static char kMffPressTimerKey, kMffPressFiredKey, kMffPressPointKey;

static void mffPressCancel(UIView *v) {
	[(NSTimer *)objc_getAssociatedObject(v, &kMffPressTimerKey) invalidate];
	objc_setAssociatedObject(v, &kMffPressTimerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void mffPressStart(UIView *v, UITouch *touch, BOOL leftWasDown) {
	mffPressCancel(v);
	objc_setAssociatedObject(v, &kMffPressFiredKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	CGPoint p = [touch locationInView:v];
	objc_setAssociatedObject(v, &kMffPressPointKey, [NSValue valueWithCGPoint:p], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	__weak UIView *wv = v;
	NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:NO block:^(NSTimer *timer) {
		UIView *sv = wv;
		void *ctrl = sv ? mffGetCtrl(sv) : NULL;
		if (!ctrl) return;
		objc_setAssociatedObject(sv, &kMffPressFiredKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		int x = (int)p.x, y = (int)p.y;
		mffAfterEvent(^{
			if (leftWasDown) mffOnMouse(ctrl, 1, 0, x, y, 0);
			mffOnMouse(ctrl, 0, 1, x, y, 0);
			mffOnMouse(ctrl, 1, 1, x, y, 0);
		});
	}];
	objc_setAssociatedObject(v, &kMffPressTimerKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/* The touch moved: no long press */
static void mffPressMoved(UIView *v, UITouch *touch) {
	CGPoint a = [objc_getAssociatedObject(v, &kMffPressPointKey) CGPointValue], b = [touch locationInView:v];
	if (fabs(a.x - b.x) > 10 || fabs(a.y - b.y) > 10) mffPressCancel(v);
}

/* The end of the touch: YES if the long press was fired */
static BOOL mffPressEnd(UIView *v) {
	mffPressCancel(v);
	BOOL fired = objc_getAssociatedObject(v, &kMffPressFiredKey) != nil;
	objc_setAssociatedObject(v, &kMffPressFiredKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return fired;
}

/* The view of a control without a view of its own kind, the view of a form. With mffKeyboard (EditControl) it takes the
   focus (the active control of the form) and the keys of the keyboard of the screen and of a keyboard of the Mac or of
   an iPad (insertText, pressesBegan) */
@interface MffView : UIView <UIKeyInput>
@property (nonatomic, strong) UIImage *mffImage;
@property (nonatomic) BOOL mffImageCenter, mffModal, mffModalDone, mffIsForm, mffKeyboard;
@property (nonatomic) CGSize mffDesignSize;
@end

@implementation MffView
/* Only the editor of the text takes the focus and the keyboard (an empty inputView of the other views, which the
   system of the keyboard moved between them, left a gesture without its view: UIGestureGraphEdge) */
- (BOOL)canBecomeFirstResponder { return mffGetCtrl(self) != NULL && !self.mffIsForm && self.mffKeyboard; }
- (BOOL)becomeFirstResponder {
	BOOL r = [super becomeFirstResponder];
	void *ctrl = mffGetCtrl(self);
	if (r && ctrl) mffOnKey(ctrl, 3, 0, 0);
	return r;
}
- (BOOL)resignFirstResponder {
	BOOL r = [super resignFirstResponder];
	void *ctrl = mffGetCtrl(self);
	if (r && ctrl) mffOnKey(ctrl, 4, 0, 0);
	return r;
}
- (BOOL)hasText { return YES; }
- (void)mffKey:(int)vk {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl) return;
	mffOnKey(ctrl, 0, vk, 0);
	mffOnKey(ctrl, 1, vk, 0);
}
- (void)insertText:(NSString *)text {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl) return;
	for (NSUInteger i = 0; i < [text length]; i++) {
		unichar c = [text characterAtIndex:i];
		/* Enter and Tab are keys (Win32Compat gives their characters with the key like Windows) */
		if (c == '\n' || c == '\r') [self mffKey:13];
		else if (c == '\t') [self mffKey:9];
		else mffOnKey(ctrl, 2, c, 0);
	}
}
- (void)deleteBackward { [self mffKey:8]; }
/* The keys without a character and the shortcuts with Ctrl or Command; the other keys come as insertText */
- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)e {
	void *ctrl = mffGetCtrl(self);
	BOOL handled = NO;
	if (@available(iOS 13.4, *)) {
		for (UIPress *p in presses) {
			UIKey *k = p.key;
			if (!k || !ctrl) continue;
			int vk = mffKeyVirtual(k), shift = mffKeyShift(k.modifierFlags);
			if (!vk && (shift & 2) && [k.charactersIgnoringModifiers length] == 1) {
				unichar c = [[k.charactersIgnoringModifiers uppercaseString] characterAtIndex:0];
				if ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) vk = c;
			}
			if (vk) { mffOnKey(ctrl, 0, vk, shift); handled = YES; }
		}
	}
	if (!handled) [super pressesBegan:presses withEvent:e];
}
- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)e {
	void *ctrl = mffGetCtrl(self);
	BOOL handled = NO;
	if (@available(iOS 13.4, *)) {
		for (UIPress *p in presses) {
			UIKey *k = p.key;
			if (!k || !ctrl) continue;
			int vk = mffKeyVirtual(k), shift = mffKeyShift(k.modifierFlags);
			if (!vk && (shift & 2) && [k.charactersIgnoringModifiers length] == 1) {
				unichar c = [[k.charactersIgnoringModifiers uppercaseString] characterAtIndex:0];
				if ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) vk = c;
			}
			if (vk) { mffOnKey(ctrl, 1, vk, shift); handled = YES; }
		}
	}
	if (!handled) [super pressesEnded:presses withEvent:e];
}
- (instancetype)initWithFrame:(CGRect)f {
	self = [super initWithFrame:f];
	if (self) {
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		self.contentMode = UIViewContentModeRedraw;
	}
	return self;
}
- (void)drawRect:(CGRect)r {
	if (self.mffImage) {
		CGSize s = self.mffImage.size;
		CGRect b = self.bounds;
		[self.mffImage drawInRect:self.mffImageCenter ? CGRectMake((b.size.width - s.width) / 2, (b.size.height - s.height) / 2, s.width, s.height) : b];
	}
	void *ctrl = mffGetCtrl(self);
	if (ctrl) mffOnPaint(ctrl);
}
- (void)layoutSubviews {
	[super layoutSubviews];
	void *ctrl = mffGetCtrl(self);
	/* The view of a form follows the size of the screen */
	if (ctrl && self.mffIsForm) {
		/* The bounds which the form gets back are not the ones of its design */
		mffFormResizing = YES;
		mffOnResize(ctrl, (int)self.bounds.size.width, (int)self.bounds.size.height);
		mffFormResizing = NO;
	}
}
- (void)touch:(NSSet *)t action:(int)action event:(UIEvent *)e {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl) return;
	CGPoint p = [[t anyObject] locationInView:self];
	/* The right button of a mouse of an iPad (iOS 13.4) */
	int button = 0;
	if (@available(iOS 13.4, *)) if (e.buttonMask & UIEventButtonMaskSecondary) button = 1;
	/* After the touch, in their order (mffAfterEvent): a double click in the designer opens the code of the event */
	int x = (int)p.x, y = (int)p.y;
	mffAfterEvent(^{ mffOnMouse(ctrl, action, button, x, y, 0); });
}
- (void)touchesBegan:(NSSet *)t withEvent:(UIEvent *)e {
	[self touch:t action:0 event:e];
	if (!self.mffIsForm) mffPressStart(self, [t anyObject], YES);
}
- (void)touchesMoved:(NSSet *)t withEvent:(UIEvent *)e {
	mffPressMoved(self, [t anyObject]);
	[self touch:t action:2 event:e];
}
- (void)touchesCancelled:(NSSet *)t withEvent:(UIEvent *)e {
	if (!mffPressEnd(self)) [self touch:t action:1 event:e];
}
- (void)touchesEnded:(NSSet *)t withEvent:(UIEvent *)e {
	/* After a long press (the context menu) the button is up already, there is no click */
	if (mffPressEnd(self)) return;
	[self touch:t action:1 event:e];
	void *ctrl = mffGetCtrl(self);
	if (ctrl && self != mffMainFormView) {
		BOOL dbl = [[t anyObject] tapCount] == 2;
		/* After the touch (mffAfterEvent): the event can open a MsgBox */
		mffAfterEvent(^{ if (dbl) mffOnDblClick(ctrl); else mffOnClick(ctrl); });
	}
}
@end

/* A scroll bar with the thumb of the size of the page (UISlider has no page) */
@interface MffScrollBar : UIView
@property (nonatomic) int mffMin, mffMax, mffPage, mffPos;
@property (nonatomic) CGFloat mffGrab;
@property (nonatomic) BOOL mffDragging;
@end

@implementation MffScrollBar
- (instancetype)initWithFrame:(CGRect)f {
	self = [super initWithFrame:f];
	self.contentMode = UIViewContentModeRedraw;
	self.backgroundColor = [UIColor secondarySystemBackgroundColor];
	return self;
}
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
	[self setNeedsDisplay];
	void *ctrl = mffGetCtrl(self);
	if (ctrl) mffAfterEvent(^{ mffOnChange(ctrl, value); });
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
- (CGFloat)mffAxis:(NSSet *)t {
	CGPoint p = [[t anyObject] locationInView:self];
	return [self mffVertical] ? p.y : p.x;
}
- (void)touchesBegan:(NSSet *)t withEvent:(UIEvent *)e { [self mffPress:[self mffAxis:t]]; }
- (void)touchesMoved:(NSSet *)t withEvent:(UIEvent *)e { [self mffDrag:[self mffAxis:t]]; }
- (void)drawRect:(CGRect)r {
	if (self.mffMax <= self.mffMin) return;
	CGRect t = [self mffVertical] ? CGRectMake(0, [self mffThumbOffset], self.bounds.size.width, [self mffThumbLength]) : CGRectMake([self mffThumbOffset], 0, [self mffThumbLength], self.bounds.size.height);
	t = CGRectInset(t, 3, 3);
	[[[UIColor labelColor] colorWithAlphaComponent:0.35] setFill];
	[[UIBezierPath bezierPathWithRoundedRect:t cornerRadius:MIN(t.size.width, t.size.height) / 2] fill];
}
@end

@interface MffGroupView : MffView
@property (nonatomic, copy) NSString *mffTitle;
@end

@implementation MffGroupView
- (void)drawRect:(CGRect)r {
	NSDictionary *a = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor labelColor]};
	CGSize s = self.mffTitle ? [self.mffTitle sizeWithAttributes:a] : CGSizeZero;
	CGRect box = CGRectInset(CGRectMake(0, s.height / 2, self.bounds.size.width, self.bounds.size.height - s.height / 2), 0.5, 0.5);
	[[UIColor separatorColor] setStroke];
	[[UIBezierPath bezierPathWithRoundedRect:box cornerRadius:5] stroke];
	if ([self.mffTitle length]) {
		[(self.backgroundColor && self.backgroundColor != [UIColor clearColor] ? self.backgroundColor : [UIColor systemBackgroundColor]) setFill];
		UIRectFill(CGRectMake(8, 0, s.width + 6, s.height));
		[self.mffTitle drawAtPoint:CGPointMake(11, 0) withAttributes:a];
	}
	[super drawRect:r];
}
@end

/* A TabControl: the tabs are the segments of a strip which scrolls when they are wider than it; the close buttons are
   on the strip at the right of their tabs */
@interface MffTabsView : MffView
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UISegmentedControl *segments;
@property (nonatomic, strong) NSMutableArray *closeButtons;
/* The width of the text (and of the picture) of each tab */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *tabWidths;
@property (nonatomic) int tabPosition;
@end

static MffTabsView *mffTabsOf(UIView *v) {
	while (v && ![v isKindOfClass:[MffTabsView class]]) v = v.superview;
	return (MffTabsView *)v;
}

/* The strip of the tabs: a second tap is a double click (the IDE pins its panel), without a gesture recognizer */
@interface MffSegments : UISegmentedControl
@end

@implementation MffSegments
- (void)touchesEnded:(NSSet<UITouch *> *)t withEvent:(UIEvent *)e {
	[super touchesEnded:t withEvent:e];
	if ([[t anyObject] tapCount] != 2) return;
	void *ctrl = mffGetCtrl(mffTabsOf(self));
	if (ctrl) mffAfterEvent(^{ mffOnDblClick(ctrl); });
}
@end

@implementation MffTabsView
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect b = self.bounds;
	/* 0 - on the left, 1 - on the right: the strip is turned clockwise, the first tab is at the top */
	BOOL vertical = self.tabPosition == 0 || self.tabPosition == 1;
	NSUInteger n = self.segments.numberOfSegments;
	self.segments.transform = CGAffineTransformIdentity;
	if (vertical) {
		self.scroller.frame = b;
		self.scroller.contentSize = b.size;
		for (NSUInteger i = 0; i < n; i++) [self.segments setWidth:0 forSegmentAtIndex:i];
		self.segments.bounds = CGRectMake(0, 0, b.size.height, 28);
		self.segments.center = CGPointMake(self.tabPosition == 0 ? 14 : b.size.width - 14, b.size.height / 2);
		self.segments.transform = CGAffineTransformMakeRotation(M_PI_2);
		for (UIButton *c in self.closeButtons) c.hidden = YES;
		return;
	}
	/* Each tab as wide as its text, the free width of the strip is shared */
	CGRect strip = CGRectMake(0, self.tabPosition == 3 ? b.size.height - 28 : 0, b.size.width, 28);
	CGFloat total = 0;
	for (NSUInteger i = 0; i < n; i++) total += i < [self.tabWidths count] ? [self.tabWidths[i] doubleValue] : 60;
	CGFloat more = n ? MAX(0, strip.size.width - total) / n : 0;
	CGFloat x = 0;
	NSMutableArray *ends = [NSMutableArray array];
	for (NSUInteger i = 0; i < n; i++) {
		CGFloat w = (i < [self.tabWidths count] ? [self.tabWidths[i] doubleValue] : 60) + more;
		[self.segments setWidth:w forSegmentAtIndex:i];
		x += w;
		[ends addObject:@(x)];
	}
	self.scroller.frame = strip;
	self.segments.frame = CGRectMake(0, 0, MAX(x, strip.size.width), 28);
	self.scroller.contentSize = self.segments.frame.size;
	for (UIButton *c in self.closeButtons) {
		if (c.tag >= (NSInteger)n) { c.hidden = YES; continue; }
		c.hidden = NO;
		c.frame = CGRectMake([ends[c.tag] doubleValue] - 24, 2, 22, 24);
		[self.scroller bringSubviewToFront:c];
	}
}
@end

@interface MffButtonsView : MffView
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) CGFloat contentWidth;
@property (nonatomic) BOOL rows;
@property (nonatomic, strong) NSMutableSet *expandGaps;
- (void)layoutExpand;
@end

/* The place before an item (a separator) and the least width of a gap of Expand */
static char kMffGapBeforeKey, kMffLeastWidthKey;

@implementation MffButtonsView
/* The gaps of Expand (flag 7) share the free width of the bar, what is after them moves (one row only) */
- (void)layoutExpand {
	if (self.rows || ![self.expandGaps count]) return;
	CGFloat free = self.bounds.size.width - self.contentWidth, end = 0;
	CGFloat more = MAX(0, free) / [self.expandGaps count];
	for (id b in self.buttons) {
		if (![b isKindOfClass:[UIView class]]) continue;
		UIView *view = b;
		CGRect f = view.frame;
		f.origin.x = end + [objc_getAssociatedObject(view, &kMffGapBeforeKey) doubleValue];
		if ([self.expandGaps containsObject:view]) f.size.width = [objc_getAssociatedObject(view, &kMffLeastWidthKey) doubleValue] + more;
		view.frame = f;
		end = CGRectGetMaxX(f);
	}
}
- (void)layoutSubviews {
	[super layoutSubviews];
	[self layoutExpand];
}
@end

/* A CheckBox, a RadioButton: a button with its mark before the text */
@interface MffCheckButton : UIButton
@property (nonatomic) int mffChecked;
@property (nonatomic) BOOL mffRadio;
@property (nonatomic, copy) NSString *mffTitle;
- (void)mffUpdate;
@end

@implementation MffCheckButton
- (void)mffUpdate {
	NSString *mark = self.mffRadio ? (self.mffChecked ? @"◉" : @"○") : (self.mffChecked == 1 ? @"☑" : (self.mffChecked == 2 ? @"☒" : @"☐"));
	[self setTitle:[NSString stringWithFormat:@"%@ %@", mark, self.mffTitle ?: @""] forState:UIControlStateNormal];
}
@end

/* A ComboBoxEdit: a button, its items are chosen in a sheet */
@interface MffComboButton : UIButton
@property (nonatomic, strong) NSMutableArray<NSString *> *items;
/* The pictures (UIImage or NSNull) and the indents (NSNumber) of the items (mffSelectItemImage of ComboBoxEx) */
@property (nonatomic, strong) NSMutableArray *pictures, *indents;
@property (nonatomic) int index;
- (void)mffUpdate;
- (void)mffInsertAt:(int)index;
- (void)mffRemoveAt:(int)index;
@end

@implementation MffComboButton
- (void)mffUpdate {
	BOOL has = self.index >= 0 && self.index < (int)[self.items count];
	NSString *t = has ? self.items[self.index] : @"";
	[self setTitle:[t stringByAppendingString:@" ▾"] forState:UIControlStateNormal];
	id img = (has && self.index < (int)[self.pictures count]) ? self.pictures[self.index] : nil;
	[self setImage:[img isKindOfClass:[UIImage class]] ? img : nil forState:UIControlStateNormal];
}
- (void)mffInsertAt:(int)index {
	if (!self.pictures) { self.pictures = [NSMutableArray array]; self.indents = [NSMutableArray array]; }
	while ([self.pictures count] < [self.items count] - 1) { [self.pictures addObject:[NSNull null]]; [self.indents addObject:@0]; }
	if (index < 0 || index > (int)[self.pictures count]) index = (int)[self.pictures count];
	[self.pictures insertObject:[NSNull null] atIndex:index];
	[self.indents insertObject:@0 atIndex:index];
}
- (void)mffRemoveAt:(int)index {
	if (index >= 0 && index < (int)[self.pictures count]) { [self.pictures removeObjectAtIndex:index]; [self.indents removeObjectAtIndex:index]; }
}
@end

@interface MffTarget : NSObject <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
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

static NSMutableArray *mffItems(id table) {
	NSMutableArray *a = objc_getAssociatedObject(table, &kMffItemsKey);
	if (!a) {
		a = [NSMutableArray array];
		objc_setAssociatedObject(table, &kMffItemsKey, a, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return a;
}

static NSMutableIndexSet *mffChecks(id table) {
	NSMutableIndexSet *s = objc_getAssociatedObject(table, &kMffChecksKey);
	if (!s) {
		s = [NSMutableIndexSet indexSet];
		objc_setAssociatedObject(table, &kMffChecksKey, s, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return s;
}

/* The text of a row without its picture "Chr(1) File Chr(1)" (a TreeView has the indent and the sign before it) */
static NSString *mffCellText(NSString *s) {
	NSRange start = [s rangeOfString:@"\x01"];
	if (start.location == NSNotFound) return s;
	NSRange end = [s rangeOfString:@"\x01" options:0 range:NSMakeRange(start.location + 1, [s length] - start.location - 1)];
	if (end.location == NSNotFound) return s;
	return [[s substringToIndex:start.location] stringByAppendingString:[s substringFromIndex:end.location + 1]];
}

/* The picture of a row (between Chr(1) and Chr(1)), 16 points high */
static UIImage *mffCellPicture(NSString *s) {
	NSRange start = [s rangeOfString:@"\x01"];
	if (start.location == NSNotFound) return nil;
	NSRange end = [s rangeOfString:@"\x01" options:0 range:NSMakeRange(start.location + 1, [s length] - start.location - 1)];
	if (end.location == NSNotFound) return nil;
	UIImage *img = [UIImage imageWithContentsOfFile:[s substringWithRange:NSMakeRange(start.location + 1, end.location - start.location - 1)]];
	if (!img) return nil;
	return [[[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(16, 16)] imageWithActions:^(UIGraphicsImageRendererContext *c) {
		[img drawInRect:CGRectMake(0, 0, 16, 16)];
	}];
}

/* The event of a tap on a row of a table; a second tap on the same row in time is a double click (mffTableDblClick) */
static void mffTableTapped(UITableView *t, NSInteger row) {
	static __weak UITableView *lastTable;
	static NSInteger lastRow = -1;
	static NSTimeInterval lastTime;
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	BOOL twice = lastTable == t && lastRow == row && now - lastTime < 0.4;
	lastTable = twice ? nil : t;
	lastRow = row;
	lastTime = now;
	void *ctrl = mffGetCtrl(t);
	if (!ctrl || mffSilent) return;
	if (![t isFirstResponder]) [t becomeFirstResponder];
	/* After the touch (mffAfterEvent): a double click can close the form of the table (New Project of the IDE) */
	int index = (int)row;
	mffAfterEvent(^{
		mffDblClick = twice;
		mffOnChange(ctrl, index);
		mffDblClick = 0;
	});
}

@implementation MffTarget
- (void)buttonTap:(UIButton *)b {
	void *ctrl = mffGetCtrl(b);
	if ([b isKindOfClass:[MffCheckButton class]]) {
		MffCheckButton *c = (MffCheckButton *)b;
		c.mffChecked = c.mffRadio ? 1 : !c.mffChecked;
		[c mffUpdate];
	}
	if (ctrl) mffAfterEvent(^{ mffOnClick(ctrl); });
}
- (void)comboTap:(MffComboButton *)b {
	UIAlertController *a = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	for (NSUInteger i = 0; i < [b.items count]; i++) {
		int indent = i < [b.indents count] ? [b.indents[i] intValue] : 0;
		NSString *title = [[@"" stringByPaddingToLength:indent * 3 withString:@" " startingAtIndex:0] stringByAppendingString:b.items[i]];
		UIAlertAction *act = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *x) {
			b.index = (int)i;
			[b mffUpdate];
			void *ctrl = mffGetCtrl(b);
			if (ctrl) mffOnChange(ctrl, (int)i);
		}];
		/* The picture of the item (the image of an action of UIAlertController) */
		id img = i < [b.pictures count] ? b.pictures[i] : nil;
		if ([img isKindOfClass:[UIImage class]] && [act respondsToSelector:NSSelectorFromString(@"setImage:")]) [act setValue:img forKey:@"image"];
		[a addAction:act];
	}
	[a addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	a.popoverPresentationController.sourceView = b;
	[mffTopController() presentViewController:a animated:YES completion:nil];
}
- (void)sliderChanged:(UISlider *)s {
	void *ctrl = mffGetCtrl(s);
	if (ctrl) mffOnChange(ctrl, (int)lround(s.value));
}
- (void)stepperChanged:(UIStepper *)s {
	void *ctrl = mffGetCtrl(s);
	if (ctrl) mffOnChange(ctrl, (int)lround(s.value));
}
- (void)textChanged:(UITextField *)f {
	void *ctrl = mffGetCtrl(f);
	if (ctrl) mffOnChange(ctrl, 0);
}
- (void)textViewDidChange:(UITextView *)t {
	void *ctrl = mffGetCtrl(t);
	if (ctrl) mffOnChange(ctrl, 0);
}
- (BOOL)textFieldShouldReturn:(UITextField *)f {
	void *ctrl = mffGetCtrl(f);
	if (ctrl) mffOnKey(ctrl, 0, 13, 0);
	[f resignFirstResponder];
	return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)f { void *c = mffGetCtrl(f); if (c) mffOnKey(c, 3, 0, 0); }
- (void)textFieldDidEndEditing:(UITextField *)f { void *c = mffGetCtrl(f); if (c) mffOnKey(c, 4, 0, 0); }
/* The close button of a tab: a change with -1 - Index (TabControl.ProcessMessage), after the touch (mffAfterEvent) */
- (void)tabsClose:(UIButton *)b {
	void *ctrl = mffGetCtrl(mffTabsOf(b));
	int index = (int)b.tag;
	if (ctrl) mffAfterEvent(^{ mffOnChange(ctrl, -1 - index); });
}
/* After the touch (mffAfterEvent): the event makes the tabs and the buttons again, a view of the touch which is taken
   away while UIKit handles it ends the program (UIGestureGraphEdge) */
- (void)tabsTap:(UISegmentedControl *)s {
	void *ctrl = mffGetCtrl(mffTabsOf(s));
	int index = (int)s.selectedSegmentIndex;
	if (ctrl) mffAfterEvent(^{ mffOnChange(ctrl, index); });
}
- (void)buttonsTap:(UIButton *)b {
	void *ctrl = mffGetCtrl(b.superview);
	int index = (int)b.tag;
	if (ctrl) mffAfterEvent(^{ mffOnChange(ctrl, index); });
}
/* A menu of the bar: its tag is the index of its line; its items in a sheet, without items it is an item itself */
- (void)menuBarTap:(UIButton *)b {
	int index = (int)b.tag;
	mffAfterEvent(^{
		NSArray *lines = [mffMenuBarItems length] ? [mffMenuBarItems componentsSeparatedByString:@"\n"] : @[];
		NSArray *n = index + 1 < (int)[lines count] ? [lines[index + 1] componentsSeparatedByString:@"\t"] : nil;
		if ([n count] >= 4 && [n[0] intValue] > 0) mffMenuBarOpen((NSUInteger)index + 1, 1, b);
		else mffOnMenu(index);
	});
}
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return [mffItems(t) count]; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
	UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"mff"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mff"];
	NSArray *a = mffItems(t);
	id item = p.row < (NSInteger)[a count] ? a[p.row] : @"";
	NSString *text = [item isKindOfClass:[NSArray class]] ? [(NSArray *)item componentsJoinedByString:@"   "] : item;
	c.textLabel.text = mffCellText(text);
	c.imageView.image = mffCellPicture(text);
	c.accessoryType = (objc_getAssociatedObject(t, &kMffChecksKey) && [mffChecks(t) containsIndex:p.row]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	return c;
}
- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)p {
	if (objc_getAssociatedObject(t, &kMffChecksKey)) {
		if ([mffChecks(t) containsIndex:p.row]) [mffChecks(t) removeIndex:p.row]; else [mffChecks(t) addIndex:p.row];
		[t reloadData];
	}
	/* A tap in a file list opens a folder, or chooses a file */
	if (objc_getAssociatedObject(t, &kMffFileViewKey)) { mffFileViewChoose(t, t, p.row, [mffItems(t)[p.row] hasSuffix:@"/"] || [mffItems(t)[p.row] isEqualToString:@".."]); return; }
	mffTableTapped(t, p.row);
}
- (void)timerFired:(NSTimer *)t {
	mffOnTimer([[t userInfo] pointerValue]);
}
@end

static id mffObj(void *view) {
	return (__bridge id)view;
}

static UIView *mffView(void *view) {
	id o = mffObj(view);
	return [o isKindOfClass:[UIView class]] ? o : nil;
}

static UITableView *mffTable(void *view) {
	id o = mffObj(view);
	return [o isKindOfClass:[UITableView class]] ? o : nil;
}

/* vsIcon, vsSmallIcon, vsList, vsTile of a ListView: a grid over the table. The table keeps the items and the selection */
@interface MffIconCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) BOOL small;
@end

@implementation MffIconCell
- (instancetype)initWithFrame:(CGRect)f {
	self = [super initWithFrame:f];
	if (self) {
		_picture = [[UIImageView alloc] init];
		_picture.contentMode = UIViewContentModeScaleAspectFit;
		_label = [[UILabel alloc] init];
		_label.layer.cornerRadius = 4;
		_label.layer.masksToBounds = YES;
		[self.contentView addSubview:_picture];
		[self.contentView addSubview:_label];
	}
	return self;
}
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect b = self.contentView.bounds;
	if (self.small) {
		self.picture.frame = CGRectMake(4, (b.size.height - 24) / 2, 24, 24);
		self.label.frame = CGRectMake(32, 2, b.size.width - 34, b.size.height - 4);
	} else {
		self.picture.frame = CGRectMake((b.size.width - 48) / 2, 6, 48, 48);
		self.label.frame = CGRectMake(2, 56, b.size.width - 4, b.size.height - 58);
	}
}
- (void)mffUpdateSelection {
	self.label.backgroundColor = self.selected ? [UIColor systemBlueColor] : [UIColor clearColor];
	self.label.textColor = self.selected ? [UIColor whiteColor] : [UIColor labelColor];
}
- (void)setSelected:(BOOL)value { [super setSelected:value]; [self mffUpdateSelection]; }
@end

@class MffTableView;
@interface MffIconGrid : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) MffTableView *table;
@property (nonatomic) BOOL small;
- (void)refresh;
- (void)showSelection;
@end

@interface MffTableView : UITableView
@property (nonatomic, strong) MffIconGrid *grid;
@end

@implementation MffTableView
/* The context menu of a list or a tree with a long press (mffPressStart) */
- (void)touchesBegan:(NSSet *)t withEvent:(UIEvent *)e { [super touchesBegan:t withEvent:e]; mffPressStart(self, [t anyObject], NO); }
- (void)touchesMoved:(NSSet *)t withEvent:(UIEvent *)e { [super touchesMoved:t withEvent:e]; mffPressMoved(self, [t anyObject]); }
- (void)touchesEnded:(NSSet *)t withEvent:(UIEvent *)e { mffPressEnd(self); [super touchesEnded:t withEvent:e]; }
- (void)touchesCancelled:(NSSet *)t withEvent:(UIEvent *)e { mffPressEnd(self); [super touchesCancelled:t withEvent:e]; }
/* The focus of a list or a tree: the active control of the form (a tap, mffTableTapped) */
- (BOOL)canBecomeFirstResponder { return mffGetCtrl(self) != NULL; }
- (BOOL)becomeFirstResponder {
	BOOL r = [super becomeFirstResponder];
	if (r && mffGetCtrl(self)) mffOnKey(mffGetCtrl(self), 3, 0, 0);
	return r;
}
- (BOOL)resignFirstResponder {
	BOOL r = [super resignFirstResponder];
	if (r && mffGetCtrl(self)) mffOnKey(mffGetCtrl(self), 4, 0, 0);
	return r;
}
- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.grid) {
		self.grid.frame = self.bounds;
		[self bringSubviewToFront:self.grid];
	}
}
- (void)reloadData { [super reloadData]; [self.grid refresh]; }
- (void)selectRowAtIndexPath:(NSIndexPath *)p animated:(BOOL)a scrollPosition:(UITableViewScrollPosition)sp { [super selectRowAtIndexPath:p animated:a scrollPosition:sp]; [self.grid showSelection]; }
- (void)deselectRowAtIndexPath:(NSIndexPath *)p animated:(BOOL)a { [super deselectRowAtIndexPath:p animated:a]; [self.grid showSelection]; }
@end

@implementation MffIconGrid
- (void)refresh { [self reloadData]; [self showSelection]; }
- (void)showSelection {
	for (NSIndexPath *p in self.indexPathsForSelectedItems) [self deselectItemAtIndexPath:p animated:NO];
	NSIndexPath *p = self.table.indexPathForSelectedRow;
	if (p && p.row < [self numberOfItemsInSection:0]) [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:p.row inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}
- (NSInteger)collectionView:(UICollectionView *)c numberOfItemsInSection:(NSInteger)s { return [mffItems(self.table) count]; }
- (UICollectionViewCell *)collectionView:(UICollectionView *)c cellForItemAtIndexPath:(NSIndexPath *)p {
	MffIconCell *cell = [c dequeueReusableCellWithReuseIdentifier:@"mff" forIndexPath:p];
	NSArray *a = mffItems(self.table);
	id item = p.item < (NSInteger)[a count] ? a[p.item] : @"";
	NSString *text = [item isKindOfClass:[NSArray class]] ? ([item count] ? item[0] : @"") : item;
	UIImage *img = nil;
	if ([text hasPrefix:@"\x01"]) {
		NSRange end = [text rangeOfString:@"\x01" options:0 range:NSMakeRange(1, [text length] - 1)];
		if (end.location != NSNotFound) img = [UIImage imageWithContentsOfFile:[text substringWithRange:NSMakeRange(1, end.location - 1)]];
	}
	cell.picture.image = img ?: [UIImage systemImageNamed:@"doc"];
	cell.label.text = mffCellText(text);
	cell.small = self.small;
	cell.label.numberOfLines = self.small ? 1 : 2;
	cell.label.textAlignment = self.small ? NSTextAlignmentLeft : NSTextAlignmentCenter;
	cell.label.font = [UIFont systemFontOfSize:self.small ? 15 : 13];
	[cell mffUpdateSelection];
	[cell setNeedsLayout];
	return cell;
}
- (CGSize)collectionView:(UICollectionView *)c layout:(UICollectionViewLayout *)l sizeForItemAtIndexPath:(NSIndexPath *)p {
	return self.small ? CGSizeMake(190, 34) : CGSizeMake(104, 100);
}
- (void)collectionView:(UICollectionView *)c didSelectItemAtIndexPath:(NSIndexPath *)p {
	[self tapped:p];
}
- (BOOL)collectionView:(UICollectionView *)c shouldSelectItemAtIndexPath:(NSIndexPath *)p {
	/* The tap on the selected item does not reach didSelectItem: it can be the second one of a double click */
	if ([[c indexPathsForSelectedItems] containsObject:p]) { [self tapped:p]; return NO; }
	return YES;
}
- (void)tapped:(NSIndexPath *)p {
	NSIndexPath *row = [NSIndexPath indexPathForRow:p.item inSection:0];
	if (![self.table.indexPathForSelectedRow isEqual:row]) [(UITableView *)self.table selectRowAtIndexPath:row animated:NO scrollPosition:UITableViewScrollPositionNone];
	mffTableTapped(self.table, p.item);
}
@end

void *mffViewCreate(const char *kind, void *ctrl) {
	NSString *k = mffStr(kind);
	CGRect r = CGRectMake(0, 0, 100, 30);
	id obj = nil;
	MffTarget *t = mffTarget();
	if ([k isEqualToString:@"Form"]) {
		MffView *v = [[MffView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		v.backgroundColor = [UIColor systemBackgroundColor];
		v.mffIsForm = YES;
		obj = v;
	} else if ([k isEqualToString:@"CommandButton"]) {
		UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
		b.frame = r;
		b.layer.borderWidth = 0.5;
		b.layer.borderColor = [UIColor separatorColor].CGColor;
		b.layer.cornerRadius = 6;
		[b addTarget:t action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
		obj = b;
	} else if ([k isEqualToString:@"CheckBox"] || [k isEqualToString:@"RadioButton"]) {
		MffCheckButton *b = [MffCheckButton buttonWithType:UIButtonTypeCustom];
		b.frame = r;
		b.mffRadio = [k isEqualToString:@"RadioButton"];
		[b setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
		b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[b mffUpdate];
		[b addTarget:t action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
		obj = b;
	} else if ([k isEqualToString:@"UpDown"]) {
		UIStepper *s = [[UIStepper alloc] initWithFrame:r];
		[s addTarget:t action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
		obj = s;
	} else if ([k isEqualToString:@"Label"] || [k isEqualToString:@"LinkLabel"] || [k isEqualToString:@"StatusBar"]) {
		UILabel *l = [[UILabel alloc] initWithFrame:r];
		l.numberOfLines = 0;
		obj = l;
	} else if ([k isEqualToString:@"SearchBox"] || [k isEqualToString:@"TextBox"] || [k isEqualToString:@"ComboBox"] || [k isEqualToString:@"DateTimePicker"] || [k isEqualToString:@"IPAddress"] || [k isEqualToString:@"HotKey"]) {
		/* SearchBox: the text field with the search glass (UISearchTextField is a UITextField) */
		UITextField *f = [k isEqualToString:@"SearchBox"] ? [[UISearchTextField alloc] initWithFrame:r] : [[UITextField alloc] initWithFrame:r];
		f.borderStyle = UITextBorderStyleRoundedRect;
		f.delegate = t;
		[f addTarget:t action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
		obj = f;
	} else if ([k isEqualToString:@"TextArea"] || [k isEqualToString:@"RichTextBox"]) {
		UITextView *v = [[UITextView alloc] initWithFrame:r];
		v.delegate = t;
		v.layer.borderWidth = 0.5;
		v.layer.borderColor = [UIColor separatorColor].CGColor;
		obj = v;
	} else if ([k isEqualToString:@"GroupBox"]) {
		obj = [[MffGroupView alloc] initWithFrame:r];
	} else if ([k isEqualToString:@"TabControl"]) {
		MffTabsView *v = [[MffTabsView alloc] initWithFrame:r];
		v.scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
		v.scroller.showsHorizontalScrollIndicator = NO;
		v.scroller.clipsToBounds = NO;
		[v addSubview:v.scroller];
		v.segments = [[MffSegments alloc] initWithFrame:CGRectZero];
		[v.segments addTarget:t action:@selector(tabsTap:) forControlEvents:UIControlEventValueChanged];
		[v.scroller addSubview:v.segments];
		obj = v;
	} else if ([k isEqualToString:@"ToolBar"] || [k isEqualToString:@"ToolPalette"]) {
		MffButtonsView *v = [[MffButtonsView alloc] initWithFrame:r];
		v.buttons = [NSMutableArray array];
		obj = v;
	} else if ([k isEqualToString:@"WebBrowser"]) {
		obj = [[WKWebView alloc] initWithFrame:r configuration:[[WKWebViewConfiguration alloc] init]];
	} else if ([k isEqualToString:@"ListControl"] || [k isEqualToString:@"CheckedListBox"] || [k isEqualToString:@"ListView"] || [k isEqualToString:@"TreeView"] || [k isEqualToString:@"TreeListView"] || [k isEqualToString:@"GridData"] || [k isEqualToString:@"Grid"] || [k isEqualToString:@"OpenFileControl"]) {
		UITableView *v = [[MffTableView alloc] initWithFrame:r style:UITableViewStylePlain];
		v.dataSource = t;
		v.delegate = t;
		if ([k isEqualToString:@"CheckedListBox"]) (void)mffChecks(v);
		obj = v;
	} else if ([k isEqualToString:@"ComboBoxEdit"] || [k isEqualToString:@"ComboBoxEx"]) {
		/* Only the custom type gives an object of the subclass */
		MffComboButton *b = [MffComboButton buttonWithType:UIButtonTypeCustom];
		b.frame = r;
		[b setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
		b.items = [NSMutableArray array];
		b.index = -1;
		b.layer.borderWidth = 0.5;
		b.layer.borderColor = [UIColor separatorColor].CGColor;
		b.layer.cornerRadius = 6;
		[b addTarget:t action:@selector(comboTap:) forControlEvents:UIControlEventTouchUpInside];
		obj = b;
	} else if ([k isEqualToString:@"ProgressBar"]) {
		UIProgressView *p = [[UIProgressView alloc] initWithFrame:r];
		obj = p;
	} else if ([k isEqualToString:@"HScrollBar"] || [k isEqualToString:@"VScrollBar"] || [k isEqualToString:@"ScrollBarControl"]) {
		MffScrollBar *s = [[MffScrollBar alloc] initWithFrame:r];
		s.mffMax = 10;
		obj = s;
	} else if ([k isEqualToString:@"TrackBar"]) {
		UISlider *s = [[UISlider alloc] initWithFrame:r];
		s.minimumValue = 0;
		s.maximumValue = 10;
		[s addTarget:t action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
		obj = s;
	} else {
		MffView *v = [[MffView alloc] initWithFrame:r];
		/* The editor of the text (the IDE) types with the keyboard of the screen */
		v.mffKeyboard = [k isEqualToString:@"EditControl"];
		obj = v;
	}
	mffSetCtrl(obj, ctrl);
	if (!mffRunning && [obj isKindOfClass:[UIView class]]) {
		if (!mffEarlyViews) mffEarlyViews = [NSHashTable weakObjectsHashTable];
		[mffEarlyViews addObject:obj];
	}
	return (__bridge_retained void *)obj;
}

void mffViewFree(void *view) {
	if (!view) return;
	id o = (__bridge_transfer id)view;
	mffSetCtrl(o, NULL);
	if ([o isKindOfClass:[UIView class]]) mffRemoveView((UIView *)o);
}

void *mffViewControl(void *view) { return view ? mffGetCtrl(mffObj(view)) : NULL; }

void *mffViewLayout(void *view) { return view; }

void mffViewAddChild(void *parent, void *child) {
	UIView *p = mffView(parent), *c = mffView(child);
	/* A form goes on the screen only with mffFormShow: the owner is not its container */
	if ([c isKindOfClass:[MffView class]] && ((MffView *)c).mffIsForm) return;
	if (p && c && c.superview != p) [p addSubview:c];
}

void mffViewSetBounds(void *view, int x, int y, int w, int h) {
	UIView *v = mffView(view);
	/* A form has the size of the screen */
	if (v && [v isKindOfClass:[MffView class]] && ((MffView *)v).mffIsForm) {
		if (!mffFormResizing) ((MffView *)v).mffDesignSize = CGSizeMake(w, h);
		return;
	}
	if (!v) return;
	CGRect f = CGRectMake(x, y, w, h);
	if (!CGRectEqualToRect(f, v.frame)) v.frame = f;
}

int mffViewClientSize(void *view, int vertical) {
	UIView *v = mffView(view);
	if (!v) return -1;
	return (int)(vertical ? v.bounds.size.height : v.bounds.size.width);
}

void mffViewSetText(void *view, const char *text) {
	id o = mffObj(view);
	NSString *s = mffStr(text);
	if ([o isKindOfClass:[MffCheckButton class]]) { ((MffCheckButton *)o).mffTitle = mffNoMnemonic(s); [(MffCheckButton *)o mffUpdate]; }
	else if ([o isKindOfClass:[MffComboButton class]]) { }
	else if ([o isKindOfClass:[UIButton class]]) [(UIButton *)o setTitle:mffNoMnemonic(s) forState:UIControlStateNormal];
	else if ([o isKindOfClass:[UILabel class]]) [(UILabel *)o setText:mffNoMnemonic(s)];
	else if ([o isKindOfClass:[UITextField class]]) [(UITextField *)o setText:s];
	else if ([o isKindOfClass:[UITextView class]]) [(UITextView *)o setText:s];
	else if ([o isKindOfClass:[MffGroupView class]]) { ((MffGroupView *)o).mffTitle = mffNoMnemonic(s); [(UIView *)o setNeedsDisplay]; }
}

char *mffViewGetText(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffCheckButton class]]) return mffDup(((MffCheckButton *)o).mffTitle);
	if ([o isKindOfClass:[UIButton class]]) return mffDup([(UIButton *)o titleForState:UIControlStateNormal]);
	if ([o isKindOfClass:[UILabel class]]) return mffDup([(UILabel *)o text]);
	if ([o isKindOfClass:[UITextField class]]) return mffDup([(UITextField *)o text]);
	if ([o isKindOfClass:[UITextView class]]) return mffDup([(UITextView *)o text]);
	if ([o isKindOfClass:[MffGroupView class]]) return mffDup(((MffGroupView *)o).mffTitle);
	return mffDup(@"");
}

void mffViewSetHint(void *view, const char *text) { (void)view; (void)text; }
void mffViewSetVisible(void *view, int value) { mffView(view).hidden = !value; }
void mffViewSetEnabled(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UIControl class]]) [(UIControl *)o setEnabled:value != 0];
	else mffView(view).userInteractionEnabled = value != 0;
}
void mffViewSetFocus(void *view) { [mffView(view) becomeFirstResponder]; }
int mffViewHasFocus(void *view) { return [mffView(view) isFirstResponder]; }
void mffViewSetBackColor(void *view, int color) {
	UIView *v = mffView(view);
	if (v == mffMainFormView || (color < 0 && [v isKindOfClass:[MffView class]] && !v.superview)) v.backgroundColor = color < 0 ? [UIColor systemBackgroundColor] : mffColor(color);
	else v.backgroundColor = color < 0 ? nil : mffColor(color);
}
void mffViewSetForeColor(void *view, int color) {
	id o = mffObj(view);
	UIColor *c = color < 0 ? [UIColor labelColor] : mffColor(color);
	if ([o isKindOfClass:[UILabel class]]) [(UILabel *)o setTextColor:c];
	else if ([o isKindOfClass:[UITextField class]]) [(UITextField *)o setTextColor:c];
	else if ([o isKindOfClass:[UITextView class]]) [(UITextView *)o setTextColor:c];
	else if ([o isKindOfClass:[UIButton class]]) [(UIButton *)o setTitleColor:c forState:UIControlStateNormal];
}

static UIFont *mffFontOf(const char *name, double size, int bold, int italic) {
	CGFloat sz = size > 0 ? size : [UIFont systemFontSize];
	UIFont *f = (name && *name && strcmp(name, "System")) ? [UIFont fontWithName:mffStr(name) size:sz] : nil;
	if (!f) f = [UIFont systemFontOfSize:sz];
	UIFontDescriptorSymbolicTraits traits = (bold ? UIFontDescriptorTraitBold : 0) | (italic ? UIFontDescriptorTraitItalic : 0);
	if (traits) {
		UIFontDescriptor *d = [f.fontDescriptor fontDescriptorWithSymbolicTraits:traits];
		if (d) f = [UIFont fontWithDescriptor:d size:sz];
	}
	return f;
}

void mffViewSetFont(void *view, const char *name, float size, int style) {
	id o = mffObj(view);
	UIFont *f = mffFontOf(name, size > 0 ? size * 96.0 / 72.0 : 0, style & 1, style & 2);
	if ([o isKindOfClass:[UIButton class]]) ((UIButton *)o).titleLabel.font = f;
	else if ([o respondsToSelector:@selector(setFont:)]) [o setFont:f];
}
void mffViewZOrder(void *view, int toFront) {
	UIView *v = mffView(view);
	if (toFront) [v.superview bringSubviewToFront:v]; else [v.superview sendSubviewToBack:v];
	/* The strip of the tabs stays under its pages only in its own place: nothing to keep */
}
void mffViewRepaint(void *view) { [mffView(view) setNeedsDisplay]; }
void mffViewSetChecked(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffCheckButton class]]) { ((MffCheckButton *)o).mffChecked = value; [(MffCheckButton *)o mffUpdate]; }
}
int mffViewGetChecked(void *view) {
	id o = mffObj(view);
	return [o isKindOfClass:[MffCheckButton class]] ? ((MffCheckButton *)o).mffChecked : 0;
}
void mffViewSetReadOnly(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UITextField class]]) [(UITextField *)o setEnabled:!value];
	else if ([o isKindOfClass:[UITextView class]]) [(UITextView *)o setEditable:!value];
}
void mffViewSetAlignment(void *view, int value) {
	id o = mffObj(view);
	NSTextAlignment a = value == 1 ? NSTextAlignmentCenter : (value == 2 ? NSTextAlignmentRight : NSTextAlignmentLeft);
	if ([o respondsToSelector:@selector(setTextAlignment:)]) [o setTextAlignment:a];
}
void mffTextScrollTo(void *view, int toEnd) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UITextView class]]) [(UITextView *)o scrollRangeToVisible:toEnd ? NSMakeRange([[(UITextView *)o text] length], 0) : [(UITextView *)o selectedRange]];
}

void mffTextSetSelection(void *view, int start, int length) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UITextView class]]) [(UITextView *)o setSelectedRange:NSMakeRange(start, length)];
	else if ([o isKindOfClass:[UITextField class]]) {
		UITextField *f = o;
		UITextPosition *a = [f positionFromPosition:f.beginningOfDocument offset:start];
		UITextPosition *b = a ? [f positionFromPosition:a offset:length] : nil;
		if (a && b) f.selectedTextRange = [f textRangeFromPosition:a toPosition:b];
	}
}
int mffTextGetSelection(void *view, int getLength) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UITextView class]]) { NSRange r = [(UITextView *)o selectedRange]; return (int)(getLength ? r.length : r.location); }
	if ([o isKindOfClass:[UITextField class]]) {
		UITextField *f = o;
		UITextRange *r = f.selectedTextRange;
		if (!r) return 0;
		return (int)(getLength ? [f offsetFromPosition:r.start toPosition:r.end] : [f offsetFromPosition:f.beginningOfDocument toPosition:r.start]);
	}
	return 0;
}
void mffTextSetPassword(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UITextField class]]) [(UITextField *)o setSecureTextEntry:value != 0];
}

void mffSelectItemImage(void *view, int index, const char *path, int indent) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffComboButton class]]) return;
	MffComboButton *b = o;
	if (index < 0 || index >= (int)[b.pictures count]) return;
	UIImage *img = (path && *path) ? [UIImage imageWithContentsOfFile:mffStr(path)] : nil;
	if (img) img = [[[[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(16, 16)] imageWithActions:^(UIGraphicsImageRendererContext *c) {
		[img drawInRect:CGRectMake(0, 0, 16, 16)];
	}] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	b.pictures[index] = img ?: (id)[NSNull null];
	b.indents[index] = @(indent);
	if (index == b.index) [b mffUpdate];
}

/* The text with its formatting: {\\rtf or {\\urtf (the text is not in code pages) */
void mffTextSetRTF(void *view, const char *rtf) {
	id o = mffObj(view);
	if (![o isKindOfClass:[UITextView class]]) return;
	UITextView *tv = o;
	NSString *s = mffStr(rtf);
	s = [s stringByReplacingOccurrencesOfString:@"\\urtf1" withString:@"\\rtf1\\ansi "];
	/* Lines of a comment and the letters which are not ASCII */
	s = [[s stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\par "] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\par "];
	NSMutableString *out = [NSMutableString string];
	for (NSUInteger i = 0; i < [s length]; i++) {
		unichar c = [s characterAtIndex:i];
		if (c > 126) [out appendFormat:@"\\u%d?", (int)(short)c]; else [out appendFormat:@"%C", c];
	}
	NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithData:[out dataUsingEncoding:NSASCIIStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType} documentAttributes:nil error:NULL];
	if (!a) { [tv setText:mffStr(rtf)]; return; }
	[a addAttribute:NSForegroundColorAttributeName value:[tv textColor] ?: [UIColor labelColor] range:NSMakeRange(0, [a length])];
	[tv setAttributedText:a];
}

void mffLinkSetMarkup(void *view, const char *markup) {
	mffViewSetText(view, markup);
}

const char *mffLinkClicked(void) {
	return "";
}

void mffListInsert(void *view, int index, const char *text) {
	id o = mffObj(view);
	NSString *s = mffStr(text);
	UITableView *t = mffTable(view);
	if (t) {
		NSMutableArray *a = mffItems(t);
		if (index < 0 || index > (int)[a count]) [a addObject:s]; else [a insertObject:s atIndex:index];
		[t reloadData];
	} else if ([o isKindOfClass:[MffComboButton class]]) {
		MffComboButton *b = o;
		int at = (index < 0 || index > (int)[b.items count]) ? (int)[b.items count] : index;
		[b.items insertObject:s atIndex:at];
		[b mffInsertAt:at];
		[b mffUpdate];
	}
}
void mffListRemove(void *view, int index) {
	id o = mffObj(view);
	UITableView *t = mffTable(view);
	if (t) {
		NSMutableArray *a = mffItems(t);
		if (index >= 0 && index < (int)[a count]) [a removeObjectAtIndex:index];
		[t reloadData];
	} else if ([o isKindOfClass:[MffComboButton class]]) {
		MffComboButton *b = o;
		if (index >= 0 && index < (int)[b.items count]) { [b.items removeObjectAtIndex:index]; [b mffRemoveAt:index]; }
		[b mffUpdate];
	}
}
void mffListClear(void *view) {
	id o = mffObj(view);
	UITableView *t = mffTable(view);
	if (t) { [mffItems(t) removeAllObjects]; [t reloadData]; }
	else if ([o isKindOfClass:[MffComboButton class]]) { MffComboButton *b = o; [b.items removeAllObjects]; [b.pictures removeAllObjects]; [b.indents removeAllObjects]; b.index = -1; [b mffUpdate]; }
}
int mffListGetIndex(void *view) {
	id o = mffObj(view);
	UITableView *t = mffTable(view);
	if (t) { NSIndexPath *p = t.indexPathForSelectedRow; return p ? (int)p.row : -1; }
	if ([o isKindOfClass:[MffComboButton class]]) return ((MffComboButton *)o).index;
	return -1;
}
void mffListSetIndex(void *view, int index) {
	id o = mffObj(view);
	UITableView *t = mffTable(view);
	if (t) {
		NSIndexPath *p = t.indexPathForSelectedRow;
		if (index < 0) { if (p) [t deselectRowAtIndexPath:p animated:NO]; }
		else if (index < (int)[mffItems(t) count]) [t selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	} else if ([o isKindOfClass:[MffComboButton class]]) { ((MffComboButton *)o).index = index; [(MffComboButton *)o mffUpdate]; }
}
void mffListSetChecked(void *view, int index, int value) {
	UITableView *t = mffTable(view);
	if (!t || index < 0) return;
	if (value) [mffChecks(t) addIndex:index]; else [mffChecks(t) removeIndex:index];
	[t reloadData];
}
int mffListGetChecked(void *view, int index) {
	UITableView *t = mffTable(view);
	return (t && index >= 0 && [mffChecks(t) containsIndex:index]) ? 1 : 0;
}

/* The range of a UIProgressView is 0..1 */
static char kMffMinKey, kMffMaxKey;
void mffRangeSet(void *view, int minValue, int maxValue) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UISlider class]]) { [(UISlider *)o setMinimumValue:minValue]; [(UISlider *)o setMaximumValue:maxValue]; }
	else if ([o isKindOfClass:[UIStepper class]]) { [(UIStepper *)o setMinimumValue:minValue]; [(UIStepper *)o setMaximumValue:maxValue]; }
	else if ([o isKindOfClass:[MffScrollBar class]]) { MffScrollBar *b = o; b.mffMin = minValue; b.mffMax = maxValue; b.mffPos = MAX(minValue, MIN(b.mffPos, maxValue)); [b setNeedsDisplay]; }
	else if ([o isKindOfClass:[UIProgressView class]]) {
		objc_setAssociatedObject(o, &kMffMinKey, @(minValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		objc_setAssociatedObject(o, &kMffMaxKey, @(maxValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}
void mffScrollPageSet(void *view, int page) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffScrollBar class]]) { ((MffScrollBar *)o).mffPage = page; [(UIView *)o setNeedsDisplay]; }
}
void mffPositionSet(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffScrollBar class]]) { ((MffScrollBar *)o).mffPos = value; [(UIView *)o setNeedsDisplay]; return; }
	if ([o isKindOfClass:[UISlider class]]) [(UISlider *)o setValue:value];
	else if ([o isKindOfClass:[UIStepper class]]) [(UIStepper *)o setValue:value];
	else if ([o isKindOfClass:[MffTabsView class]]) ((MffTabsView *)o).segments.selectedSegmentIndex = value;
	else if ([o isKindOfClass:[UIProgressView class]]) {
		int lo = [objc_getAssociatedObject(o, &kMffMinKey) intValue];
		NSNumber *m = objc_getAssociatedObject(o, &kMffMaxKey);
		int hi = m ? [m intValue] : 100;
		[(UIProgressView *)o setProgress:hi > lo ? (float)(value - lo) / (hi - lo) : 0];
	}
}
static char kMffMarqueeKey;

/* UIProgressView has no indeterminate style: a timer moves its bar again and again */
void mffMarqueeSet(void *view, int marqueeOn) {
	id o = mffObj(view);
	if (![o isKindOfClass:[UIProgressView class]]) return;
	UIProgressView *p = o;
	NSTimer *t = objc_getAssociatedObject(p, &kMffMarqueeKey);
	[t invalidate];
	objc_setAssociatedObject(p, &kMffMarqueeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if (!marqueeOn) { [p setProgress:0 animated:NO]; return; }
	__weak UIProgressView *wp = p;
	t = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *timer) {
		UIProgressView *sp = wp;
		if (!sp) { [timer invalidate]; return; }
		float v = sp.progress + 0.02f;
		[sp setProgress:(v > 1.0f ? 0.0f : v) animated:NO];
	}];
	objc_setAssociatedObject(p, &kMffMarqueeKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

int mffPositionGet(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UISlider class]]) return (int)lround([(UISlider *)o value]);
	if ([o isKindOfClass:[UIStepper class]]) return (int)lround([(UIStepper *)o value]);
	if ([o isKindOfClass:[MffScrollBar class]]) return ((MffScrollBar *)o).mffPos;
	if ([o isKindOfClass:[MffTabsView class]]) return (int)((MffTabsView *)o).segments.selectedSegmentIndex;
	if ([o isKindOfClass:[UIProgressView class]]) {
		int lo = [objc_getAssociatedObject(o, &kMffMinKey) intValue];
		NSNumber *m = objc_getAssociatedObject(o, &kMffMaxKey);
		int hi = m ? [m intValue] : 100;
		return lo + (int)lround([(UIProgressView *)o progress] * (hi - lo));
	}
	return 0;
}

/* The main form is the view of the root controller; a form shown before the application runs waits for it */
void mffFormShow(void *view, int modal) {
	UIView *v = mffView(view);
	if (!v) return;
	if (!mffRunning) {
		if (!mffFormsToShow) mffFormsToShow = [NSMutableArray array];
		if (![mffFormsToShow containsObject:v]) [mffFormsToShow addObject:v];
		return;
	}
	if (!v.superview) {
		UIView *root = mffMainWindow.rootViewController.view;
		[root addSubview:v];
		if (!mffMainFormView) mffMainFormView = v;
		[root setNeedsLayout];
		[root layoutIfNeeded];
		void *ctrl = mffGetCtrl(v);
		if (ctrl) mffOnResize(ctrl, (int)v.bounds.size.width, (int)v.bounds.size.height);
	}
	v.hidden = NO;
	if (modal && [v isKindOfClass:[MffView class]]) {
		MffView *m = (MffView *)v;
		m.mffModal = YES;
		m.mffModalDone = NO;
		while (!m.mffModalDone) {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
		}
		m.mffModal = NO;
	}
}
void mffFormHide(void *view) {
	UIView *v = mffView(view);
	if (!v) return;
	if ([v isKindOfClass:[MffView class]]) ((MffView *)v).mffModalDone = YES;
	[mffFormsToShow removeObject:v];
	[v removeFromSuperview];
	/* The form on the top goes on (a splash form is hidden, the main form stays) */
	if (v == mffMainFormView) mffMainFormView = [mffMainWindow.rootViewController.view.subviews lastObject];
}
void mffFormSetState(void *view, int state) { (void)view; (void)state; }
void mffFormSetBorder(void *view, int style) { (void)view; (void)style; }
void mffFormSetMainMenu(void *view, const char *items) { (void)view; (void)items; }
/* The bar of the menu: a row of buttons above the forms, each opens the menu of its items (mffMenuBarOpen). The lines are the
   ones of mffPopupMenu: "Level Tab Enabled Tab Checked Tab Caption" (Chr(1) picture Chr(1) before the caption, Tab
   shortcut after it), the index of a line is the one of mffOnMenu */

/* The buttons of the bar in rows of the width (all the menus are seen); the height of the bar is returned */
static CGFloat mffMenuBarLayout(CGFloat width) {
	CGFloat x = 4, y = 0, h = 26;
	UIFont *font = [UIFont systemFontOfSize:13];
	for (UIView *v in mffMenuBar.subviews) {
		if (![v isKindOfClass:[UIButton class]] || v.hidden) continue;
		UIButton *b = (UIButton *)v;
		b.titleLabel.font = font;
		CGFloat w = ceil([[b titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName: font}].width + 16);
		if (x > 4 && x + w > width) { x = 4; y += h; }
		b.frame = CGRectMake(x, y, w, h);
		x += w;
	}
	return y + h;
}

/* The items of a menu of the bar (the lines after Start of the Level of Start) in an action sheet: an item with items
   (▸) opens their sheet, the other ones raise mffOnMenu. Not UIMenu of a button: its interaction set again by the
   bar, which the IDE sets often, left a gesture without its view (UIGestureGraphEdge: no targetNode) */
static void mffMenuBarOpen(NSUInteger start, int level, UIView *source) {
	NSArray *lines = [mffMenuBarItems length] ? [mffMenuBarItems componentsSeparatedByString:@"\n"] : @[];
	UIAlertController *a = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	for (NSUInteger i = start; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		if ([f count] < 4) continue;
		int lv = [f[0] intValue];
		if (lv < level) break;
		if (lv > level) continue;
		NSString *caption = f[3];
		UIImage *img = nil;
		if ([caption hasPrefix:@"\x01"]) {
			NSRange end = [caption rangeOfString:@"\x01" options:0 range:NSMakeRange(1, [caption length] - 1)];
			if (end.location != NSNotFound) {
				img = [UIImage imageWithContentsOfFile:[caption substringWithRange:NSMakeRange(1, end.location - 1)]];
				caption = [caption substringFromIndex:end.location + 1];
			}
		}
		if ([caption isEqualToString:@"-"]) continue;
		BOOL hasItems = NO;
		if (i + 1 < [lines count]) {
			NSArray *n = [lines[i + 1] componentsSeparatedByString:@"\t"];
			hasItems = [n count] >= 4 && [n[0] intValue] > lv;
		}
		NSString *title = mffNoMnemonic(caption);
		if ([f[2] intValue] != 0) title = [@"\u2713 " stringByAppendingString:title];
		if (hasItems) title = [title stringByAppendingString:@"  \u25b8"];
		int index = (int)i;
		UIAlertAction *act = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *x) {
			if (hasItems) mffAfterEvent(^{ mffMenuBarOpen((NSUInteger)index + 1, lv + 1, source); });
			else mffAfterEvent(^{ mffOnMenu(index); });
		}];
		act.enabled = [f[1] intValue] != 0;
		if (img) {
			img = [[[[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(20, 20)] imageWithActions:^(UIGraphicsImageRendererContext *c) {
				[img drawInRect:CGRectMake(0, 0, 20, 20)];
			}] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
			if ([act respondsToSelector:NSSelectorFromString(@"setImage:")]) [act setValue:img forKey:@"image"];
		}
		[a addAction:act];
	}
	[a addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	a.popoverPresentationController.sourceView = source ?: mffMainWindow;
	a.popoverPresentationController.sourceRect = source ? source.bounds : CGRectZero;
	[mffTopController() presentViewController:a animated:YES completion:nil];
}

static void mffMenuBarApply(void) {
	UIView *root = mffMainWindow.rootViewController.view;
	if (!root || !mffMenuBarItems) return;
	if (!mffMenuBar) {
		mffMenuBar = [[UIView alloc] initWithFrame:CGRectZero];
		mffMenuBar.backgroundColor = [UIColor secondarySystemBackgroundColor];
		[root addSubview:mffMenuBar];
	}
	/* The buttons stay and get the new items (their menu is made when it is opened, from the last items) */
	NSMutableArray<UIButton *> *buttons = [NSMutableArray array];
	for (UIView *v in mffMenuBar.subviews) if ([v isKindOfClass:[UIButton class]]) [buttons addObject:(UIButton *)v];
	NSArray *lines = [mffMenuBarItems length] ? [mffMenuBarItems componentsSeparatedByString:@"\n"] : @[];
	NSUInteger i = 0, n = 0;
	while (i < [lines count]) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		if ([f count] < 4 || [f[0] intValue] != 0) { i++; continue; }
		int index = (int)i;
		NSString *title = mffNoMnemonic(f[3]);
		BOOL enabled = [f[1] intValue] != 0;
		i++;
		while (i < [lines count]) {
			NSArray *n = [lines[i] componentsSeparatedByString:@"\t"];
			if ([n count] >= 4 && [n[0] intValue] == 0) break;
			i++;
		}
		UIButton *b = n < [buttons count] ? buttons[n] : nil;
		if (!b) {
			b = [UIButton buttonWithType:UIButtonTypeSystem];
			b.titleLabel.font = [UIFont systemFontOfSize:15];
			[b addTarget:mffTarget() action:@selector(menuBarTap:) forControlEvents:UIControlEventTouchUpInside];
			[mffMenuBar addSubview:b];
		}
		n++;
		b.hidden = NO;
		b.tag = index;
		if (![[b titleForState:UIControlStateNormal] isEqualToString:title]) [b setTitle:title forState:UIControlStateNormal];
		b.enabled = enabled;
	}
	/* The buttons which are not needed now are hidden, not taken away */
	for (NSUInteger k = n; k < [buttons count]; k++) buttons[k].hidden = YES;
	/* The rows of the bar: mffLayoutForms */
	[root setNeedsLayout];
}

void mffMenuBarSet(const char *items) {
	mffMenuBarItems = mffStr(items);
	mffMenuBarApply();
}
int mffScreenSize(int vertical) {
	CGRect b = [UIScreen mainScreen].bounds;
	return (int)(vertical ? b.size.height : b.size.width);
}

@interface MffAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@interface MffRootController : UIViewController
@end

@implementation MffRootController
/* The bar of the menu and the forms in the safe area */
- (void)mffLayoutForms {
	CGRect a = self.view.safeAreaLayoutGuide.layoutFrame;
	/* The bar of the menu is above the forms */
	if (mffMenuBar && [mffMenuBar superview] == self.view) {
		CGFloat h = mffMenuBarLayout(a.size.width);
		mffMenuBar.frame = CGRectMake(a.origin.x, a.origin.y, a.size.width, h);
		[self.view bringSubviewToFront:mffMenuBar];
		a.origin.y += h;
		a.size.height -= h;
	}
	/* A form fills the safe area in its own size, not scaled (the text stays readable): the controls which are docked
	   follow the size of the screen */
	for (UIView *v in self.view.subviews) {
		if (v == mffMenuBar) continue;
		v.transform = CGAffineTransformIdentity;
		v.frame = a;
	}
}
- (void)viewSafeAreaInsetsDidChange {
	[super viewSafeAreaInsetsDidChange];
	[self mffLayoutForms];
}
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self mffLayoutForms];
}
@end

static UIButton *mffFindButton(UIView *v, NSString *title) {
	if ([v isKindOfClass:[UIButton class]] && [[(UIButton *)v titleForState:UIControlStateNormal] isEqualToString:title]) return (UIButton *)v;
	for (UIView *s in v.subviews) {
		UIButton *b = mffFindButton(s, title);
		if (b) return b;
	}
	return nil;
}

@implementation MffAppDelegate
- (BOOL)application:(UIApplication *)a didFinishLaunchingWithOptions:(NSDictionary *)o {
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mffMainWindow = self.window;
	self.window.overrideUserInterfaceStyle = mffStyle;
	MffRootController *root = [[MffRootController alloc] init];
	root.view.backgroundColor = [UIColor systemBackgroundColor];
	self.window.rootViewController = root;
	mffRunning = YES;
	/* The forms shown before UIApplicationMain: the first one is the main form */
	for (UIView *v in mffFormsToShow) {
		mffFormShow((__bridge void *)v, 0);
	}
	[self.window makeKeyAndVisible];
	/* The gesture recognizers of the views made before App.Run in the gesture environment of the program */
	for (UIView *v in mffEarlyViews) mffRegisterGestures(v);
	mffEarlyViews = nil;
	/* The bar of the menu set before the window was made */
	mffMenuBarApply();
	[root.view setNeedsLayout];
	/* The test of CI: MFF_CLICK=Caption taps the button with that caption two seconds after the start */
	const char *click = getenv("MFF_CLICK");
	if (click && *click) {
		NSString *title = mffStr(click);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			UIButton *b = mffFindButton(mffMainWindow, title);
			if (b) [b sendActionsForControlEvents:UIControlEventTouchUpInside];
			else fprintf(stderr, "MFF_CLICK: no button \"%s\"\n", [title UTF8String]);
		});
	}
	return YES;
}
@end

void mffAppRun(void) {
	char *argv[] = {(char *)"mff", NULL};
	UIApplicationMain(1, argv, nil, NSStringFromClass([MffAppDelegate class]));
}
void mffAppTerminate(void) {
	/* A program of iOS is not ended by itself: when the program did not run yet it only returns */
	if (mffRunning) exit(0);
}
void mffAppDoEvents(void) {
	[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
}
void mffAppSetDarkMode(int value) {
	mffStyle = value < 0 ? UIUserInterfaceStyleUnspecified : (value ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight);
	mffMainWindow.overrideUserInterfaceStyle = mffStyle;
}
int mffAppDarkMode(void) {
	return [UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark;
}

int mffMessageBox(const char *msg, const char *caption, int messageType, int buttonsType) {
	(void)messageType;
	if (!mffRunning) return 4;
	UIAlertController *a = [UIAlertController alertControllerWithTitle:(caption && *caption) ? mffStr(caption) : [[NSProcessInfo processInfo] processName] message:mffStr(msg) preferredStyle:UIAlertControllerStyleAlert];
	__block int result = -1;
	void (^add)(NSString *, int) = ^(NSString *title, int r) {
		[a addAction:[UIAlertAction actionWithTitle:title style:r == 1 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault handler:^(UIAlertAction *x) { result = r; }]];
	};
	switch (buttonsType) {
	case 2: add(@"Yes", 6); add(@"No", 3); break;
	case 3: add(@"Yes", 6); add(@"No", 3); add(@"Cancel", 1); break;
	case 4: add(@"OK", 4); add(@"Cancel", 1); break;
	default: add(@"OK", 4); break;
	}
	[mffTopController() presentViewController:a animated:YES completion:nil];
	while (result < 0) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
	return result;
}

void mffTimerStop(void *id_) {
	MffTarget *t = mffTarget();
	NSValue *key = [NSValue valueWithPointer:id_];
	[t.timers[key] invalidate];
	[t.timers removeObjectForKey:key];
}
void mffTimerStart(void *id_, int interval) {
	mffTimerStop(id_);
	MffTarget *t = mffTarget();
	NSValue *key = [NSValue valueWithPointer:id_];
	NSTimer *tm = [NSTimer timerWithTimeInterval:interval / 1000.0 target:t selector:@selector(timerFired:) userInfo:key repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:tm forMode:NSRunLoopCommonModes];
	t.timers[key] = tm;
}
void mffClipboardSetText(const char *text) { [UIPasteboard generalPasteboard].string = mffStr(text); }
char *mffClipboardGetText(void) {
	NSString *s = [UIPasteboard generalPasteboard].string;
	return s ? mffDup(s) : NULL;
}
void mffOpenURL(const char *url) {
	NSURL *u = [NSURL URLWithString:mffStr(url)];
	if (u) [[UIApplication sharedApplication] openURL:u options:@{} completionHandler:nil];
}

/* Tabs, buttons */
void mffTabsSet(void *view, const char *titles) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffTabsView class]]) return;
	MffTabsView *tabs = o;
	UISegmentedControl *seg = tabs.segments;
	NSInteger selected = seg.selectedSegmentIndex;
	[seg removeAllSegments];
	for (UIButton *c in tabs.closeButtons) mffRemoveView(c);
	tabs.closeButtons = [NSMutableArray array];
	tabs.tabWidths = [NSMutableArray array];
	NSArray *lines = [mffStr(titles) length] ? [mffStr(titles) componentsSeparatedByString:@"\n"] : @[];
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		NSString *title = mffNoMnemonic(f[0]);
		UIImage *img = ([f count] > 2 && [f[2] length]) ? [UIImage imageWithContentsOfFile:f[2]] : nil;
		BOOL closable = [f count] > 1 && [f[1] length];
		CGFloat textWidth = ceil([title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}].width);
		[tabs.tabWidths addObject:@(textWidth + (img ? 20 : 0) + (closable ? 22 : 0) + 20)];
		if (img || closable) {
			/* A segment has a picture or a title: the picture of the tab with its title (and the place of the close button) */
			UIFont *font = [UIFont systemFontOfSize:13];
			NSDictionary *a = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor labelColor]};
			CGSize ts = [title sizeWithAttributes:a];
			CGFloat iw = img ? 16 : 0, gap = img ? 4 : 0, cw = closable ? 22 : 0;
			CGSize size = CGSizeMake(ceil(iw + gap + ts.width + cw), 20);
			UIImage *composed = [[[UIGraphicsImageRenderer alloc] initWithSize:size] imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
				if (img) [img drawInRect:CGRectMake(0, 2, 16, 16)];
				[title drawAtPoint:CGPointMake(iw + gap, (20 - ts.height) / 2) withAttributes:a];
			}];
			[seg insertSegmentWithImage:[composed imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] atIndex:i animated:NO];
		} else {
			[seg insertSegmentWithTitle:title atIndex:i animated:NO];
		}
		if (closable) {
			UIButton *c = [UIButton buttonWithType:UIButtonTypeSystem];
			[c setTitle:@"\u00D7" forState:UIControlStateNormal];
			c.titleLabel.font = [UIFont systemFontOfSize:17];
			[c setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
			c.tag = i;
			[c addTarget:mffTarget() action:@selector(tabsClose:) forControlEvents:UIControlEventTouchUpInside];
			[tabs.scroller addSubview:c];
			[tabs.closeButtons addObject:c];
		}
	}
	if (selected >= 0 && selected < (NSInteger)[lines count]) seg.selectedSegmentIndex = selected;
	[tabs setNeedsLayout];
}
void mffTabsSetPosition(void *view, int position) {
	id o = mffObj(view);
	if ([o isKindOfClass:[MffTabsView class]]) { ((MffTabsView *)o).tabPosition = position; [(UIView *)o setNeedsLayout]; }
}
int mffTabsStripHeight(void) { return 28; }

void mffButtonsSet(void *view, const char *items) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffButtonsView class]]) return;
	MffButtonsView *v = o;
	for (id b in v.buttons) if ([b isKindOfClass:[UIView class]]) mffRemoveView((UIView *)b);
	[v.buttons removeAllObjects];
	NSArray *lines = [mffStr(items) length] ? [mffStr(items) componentsSeparatedByString:@"\n"] : @[];
	CGFloat x = 0, y = 0, rowHeight = 0, width = v.bounds.size.width, right = 0, rowEnd = 0;
	v.expandGaps = [NSMutableSet set];
	v.rows = NO;
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		NSString *first = f[0];
		unichar flag = [first length] ? [first characterAtIndex:0] : '0';
		if (flag == '4' || flag == '3') {
			[v.buttons addObject:[NSNull null]];
			if (flag == '3') x += 8;
			continue;
		}
		/* A custom button: the gap of its control (ToolBar puts the control over it); 7 - its least width (Expand) */
		if (flag == '6' || flag == '7') {
			CGFloat gap = [[first substringFromIndex:1] doubleValue];
			UIView *g = [[UIView alloc] initWithFrame:CGRectMake(x, y, gap, 24)];
			/* Behind the control and without the touches: they are the ones of the control */
			g.userInteractionEnabled = NO;
			[v insertSubview:g atIndex:0];
			[v.buttons addObject:g];
			objc_setAssociatedObject(g, &kMffGapBeforeKey, @(x - rowEnd), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			if (flag == '7') {
				objc_setAssociatedObject(g, &kMffLeastWidthKey, @(gap), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
				[v.expandGaps addObject:g];
			}
			x += gap;
			rowEnd = x;
			right = MAX(right, x);
			rowHeight = MAX(rowHeight, 24);
			continue;
		}
		UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
		UIImage *img = ([f count] > 1 && [f[1] length]) ? [UIImage imageWithContentsOfFile:f[1]] : nil;
		NSString *options = [f count] > 2 ? f[2] : @"";
		/* The colors of the picture: a system button would draw it in the color of its tint */
		if (img) [b setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
		if (!img || [options rangeOfString:@"S"].location != NSNotFound) [b setTitle:[first length] > 1 ? mffNoMnemonic([first substringFromIndex:1]) : @"" forState:UIControlStateNormal];
		b.enabled = flag != '1';
		b.selected = flag == '2';
		b.tag = i;
		[b addTarget:mffTarget() action:@selector(buttonsTap:) forControlEvents:UIControlEventTouchUpInside];
		[b sizeToFit];
		CGSize s = b.frame.size;
		s.width = MAX(s.width + 8, 32);
		s.height = MAX(s.height, 32);
		/* Only a tall view (ToolPalette) has more rows: a ToolBar gets its width after its buttons (ReBar) */
		if (x > 0 && width > 0 && x + s.width > width && v.bounds.size.height >= s.height * 2) { x = 0; y += rowHeight; rowHeight = 0; rowEnd = 0; v.rows = YES; }
		b.frame = CGRectMake(x, y, s.width, s.height);
		[v addSubview:b];
		[v.buttons addObject:b];
		objc_setAssociatedObject(b, &kMffGapBeforeKey, @(x - rowEnd), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		x += s.width;
		rowEnd = x;
		right = MAX(right, x);
		rowHeight = MAX(rowHeight, s.height);
	}
	v.contentWidth = right;
	[v layoutExpand];
}
int mffButtonsItem(void *view, int index, int what) {
	id o = mffObj(view);
	if (![o isKindOfClass:[MffButtonsView class]]) return -1;
	MffButtonsView *v = o;
	/* The places after the last size of the bar (ToolBar puts the controls over the gaps now) */
	[v layoutExpand];
	if (index < 0) return (int)v.contentWidth;
	if (index >= (int)[v.buttons count] || ![v.buttons[index] isKindOfClass:[UIView class]]) return -1;
	CGRect f = [(UIView *)v.buttons[index] frame];
	return (int)(what ? f.size.width : f.origin.x);
}
int mffViewFittingWidth(void *view) {
	return (int)[mffView(view) sizeThatFits:CGSizeZero].width;
}

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
	((MffView *)o).mffImage = [UIImage imageWithContentsOfFile:mffStr(path)];
	((MffView *)o).mffImageCenter = center != 0;
	[(UIView *)o setNeedsDisplay];
}

/* A popup menu: a sheet with the items of the first level */
int mffPopupMenu(const char *items, int x, int y) {
	(void)x; (void)y;
	if (!mffRunning) return -1;
	UIAlertController *a = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	__block int result = -2;
	NSArray *lines = [mffStr(items) componentsSeparatedByString:@"\n"];
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		if ([f count] < 4 || [f[3] isEqualToString:@"-"]) continue;
		UIAlertAction *act = [UIAlertAction actionWithTitle:[[@"" stringByPaddingToLength:[f[0] intValue] * 2 withString:@" " startingAtIndex:0] stringByAppendingString:mffNoMnemonic(mffCellText(f[3]))] style:UIAlertActionStyleDefault handler:^(UIAlertAction *z) { result = (int)i; }];
		act.enabled = [f[1] intValue] != 0;
		[a addAction:act];
	}
	[a addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *z) { result = -1; }]];
	a.popoverPresentationController.sourceView = mffMainWindow;
	[mffTopController() presentViewController:a animated:YES completion:nil];
	while (result == -2) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
	return result;
}

/* Regular expressions */
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
char *mffRegexError(void) { return mffDup(mffRegexLastError ?: @""); }
void mffRegexFree(int id_) { [mffRegexes removeObjectForKey:@(id_)]; }
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

/* Tables */
void mffTableInit(void *view) { (void)view; }
void mffTableSetView(void *view, const char *viewName) {
	UITableView *t = mffTable(view);
	if (![t isKindOfClass:[MffTableView class]]) return;
	MffTableView *table = (MffTableView *)t;
	NSString *name = mffStr(viewName);
	if ([name isEqualToString:@"report"] || ![name length]) {
		mffRemoveView(table.grid);
		table.grid = nil;
		table.scrollEnabled = YES;
		return;
	}
	if (!table.grid) {
		MffIconGrid *g = [[MffIconGrid alloc] initWithFrame:table.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
		g.backgroundColor = [UIColor systemBackgroundColor];
		g.table = table;
		g.dataSource = g;
		g.delegate = g;
		[g registerClass:[MffIconCell class] forCellWithReuseIdentifier:@"mff"];
		table.grid = g;
		table.scrollEnabled = NO;
		[table addSubview:g];
	}
	table.grid.small = ![name isEqualToString:@"icon"];
	[table.grid refresh];
	[table setNeedsLayout];
}
void mffTableSetColumns(void *view, const char *captions, const char *widths) { (void)view; (void)captions; (void)widths; }
void mffTableInsertRow(void *view, int index, const char *cells) {
	UITableView *t = mffTable(view);
	if (!t) return;
	NSMutableArray *a = mffItems(t);
	NSArray *row = [mffStr(cells) componentsSeparatedByString:@"\t"];
	if (index < 0 || index > (int)[a count]) [a addObject:row]; else [a insertObject:row atIndex:index];
	[t reloadData];
}
void mffTableSetRow(void *view, int index, const char *cells) {
	UITableView *t = mffTable(view);
	if (!t) return;
	NSMutableArray *a = mffItems(t);
	if (index < 0 || index >= (int)[a count]) return;
	a[index] = [mffStr(cells) componentsSeparatedByString:@"\t"];
	[t reloadData];
}
void mffTableCellRect(void *view, int row, int col, void *pRect) {
	(void)col;
	UITableView *t = mffTable(view);
	int *r = pRect;
	if (!t || !r) return;
	CGRect f = (row >= 0 && row < [t numberOfRowsInSection:0]) ? [t rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] : CGRectZero;
	r[0] = (int)CGRectGetMinX(f); r[1] = (int)CGRectGetMinY(f); r[2] = (int)CGRectGetMaxX(f); r[3] = (int)CGRectGetMaxY(f);
}
int mffTableDblClick(void) { return mffDblClick; }

/* Canvas: draws in drawRect of the view, the path works like the one of cairo */
static UIBezierPath *mffPath;

static UIBezierPath *mffCurrentPath(void) {
	if (!mffPath) mffPath = [UIBezierPath bezierPath];
	return mffPath;
}
static UIColor *mffColorAlpha(int color, int alpha) {
	return [mffColor(color < 0 ? 0 : color) colorWithAlphaComponent:alpha / 255.0];
}
void mffCanvasBegin(void *id_) { (void)id_; mffPath = nil; }
void mffCanvasEnd(void *id_) { (void)id_; }
void mffCanvasNewPath(void) { mffPath = nil; }
void mffCanvasMoveTo(double x, double y) { [mffCurrentPath() moveToPoint:CGPointMake(x, y)]; }
void mffCanvasLineTo(double x, double y) {
	UIBezierPath *p = mffCurrentPath();
	if ([p isEmpty]) [p moveToPoint:CGPointMake(x, y)]; else [p addLineToPoint:CGPointMake(x, y)];
}
void mffCanvasCurveTo(double x1, double y1, double x2, double y2, double x3, double y3) {
	UIBezierPath *p = mffCurrentPath();
	if ([p isEmpty]) [p moveToPoint:CGPointMake(x1, y1)];
	[p addCurveToPoint:CGPointMake(x3, y3) controlPoint1:CGPointMake(x1, y1) controlPoint2:CGPointMake(x2, y2)];
}
void mffCanvasArc(double cx, double cy, double r, double a1, double a2, int negative) {
	/* clockwise of UIKit is the direction of the growing angles on the screen like the one of cairo */
	[mffCurrentPath() addArcWithCenter:CGPointMake(cx, cy) radius:r startAngle:a1 endAngle:a2 clockwise:!negative];
}
void mffCanvasRectPath(double x, double y, double w, double h) { [mffCurrentPath() appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)]]; }
void mffCanvasClosePath(void) { if (![mffCurrentPath() isEmpty]) [mffCurrentPath() closePath]; }
void mffCanvasClip(void) {
	if (!UIGraphicsGetCurrentContext()) return;
	[mffCurrentPath() addClip];
	mffPath = nil;
}
void mffCanvasFill(int color, int alpha) {
	if (!UIGraphicsGetCurrentContext()) return;
	[mffColorAlpha(color, alpha) setFill];
	[mffCurrentPath() fill];
}
void mffCanvasStroke(int color, int alpha, double lineWidth, const char *dash) {
	if (!UIGraphicsGetCurrentContext()) return;
	UIBezierPath *p = mffCurrentPath();
	[mffColorAlpha(color, alpha) setStroke];
	p.lineWidth = lineWidth;
	NSArray *parts = (dash && *dash) ? [mffStr(dash) componentsSeparatedByString:@","] : @[];
	CGFloat pattern[8];
	NSInteger n = 0;
	for (NSString *s in parts) if (n < 8) pattern[n++] = [s doubleValue];
	[p setLineDash:n ? pattern : NULL count:n phase:0];
	[p stroke];
}
void mffCanvasFillRect(double x, double y, double w, double h, int color, int alpha) {
	if (!UIGraphicsGetCurrentContext()) return;
	[mffColorAlpha(color, alpha) setFill];
	UIRectFillUsingBlendMode(CGRectMake(x, y, w, h), kCGBlendModeNormal);
}
void mffCanvasInvertRect(double x, double y, double w, double h) {
	if (!UIGraphicsGetCurrentContext()) return;
	[[UIColor whiteColor] setFill];
	UIRectFillUsingBlendMode(CGRectMake(x, y, w, h), kCGBlendModeDifference);
}
void mffCanvasRotate(double x, double y, double angle) {
	CGContextRef c = UIGraphicsGetCurrentContext();
	if (!c) return;
	CGContextTranslateCTM(c, x, y);
	CGContextRotateCTM(c, -angle * M_PI / 180.0);
	CGContextTranslateCTM(c, -x, -y);
}
void mffCanvasSave(void) { CGContextRef c = UIGraphicsGetCurrentContext(); if (c) CGContextSaveGState(c); }
void mffCanvasRestore(void) { CGContextRef c = UIGraphicsGetCurrentContext(); if (c) CGContextRestoreGState(c); }
void mffCanvasText(double x, double y, const char *text, int color, int bkColor, const char *fontName, double fontSize, int bold, int italic) {
	if (!UIGraphicsGetCurrentContext()) return;
	NSMutableDictionary *a = [NSMutableDictionary dictionary];
	a[NSFontAttributeName] = mffFontOf(fontName, fontSize, bold, italic);
	a[NSForegroundColorAttributeName] = mffColor(color < 0 ? 0 : color);
	if (bkColor >= 0) a[NSBackgroundColorAttributeName] = mffColor(bkColor);
	[mffStr(text) drawAtPoint:CGPointMake(x, y) withAttributes:a];
}
int mffCanvasTextWidth(const char *text, const char *fontName, double fontSize, int bold, int italic) {
	return (int)ceil([mffStr(text) sizeWithAttributes:@{NSFontAttributeName: mffFontOf(fontName, fontSize, bold, italic)}].width);
}
int mffCanvasTextHeight(const char *fontName, double fontSize, int bold, int italic) {
	return (int)ceil([@"Wg" sizeWithAttributes:@{NSFontAttributeName: mffFontOf(fontName, fontSize, bold, italic)}].height);
}
int mffCanvasGetPixel(double x, double y) { (void)x; (void)y; return -1; }
void mffCanvasImage(const char *path, double x, double y, double w, double h, int alpha) {
	if (!UIGraphicsGetCurrentContext() || !path || !*path) return;
	UIImage *img = [UIImage imageWithContentsOfFile:mffStr(path)];
	if (!img) return;
	[img drawInRect:CGRectMake(x, y, w > 0 ? w : img.size.width, h > 0 ? h : img.size.height) blendMode:kCGBlendModeNormal alpha:alpha / 255.0];
}

/* The runtime of FreeBASIC for iOS: its console needs the terminal functions, a program of iOS has no terminal.
   system() is not allowed there (Apple/patch-fbc-rtlib.sh) */
char PC;
short ospeed;
char *BC, *UP;
int tgetent(char *bp, const char *name) { (void)bp; (void)name; return -1; }
int tgetflag(const char *id) { (void)id; return 0; }
int tgetnum(const char *id) { (void)id; return -1; }
char *tgetstr(const char *id, char **area) { (void)id; (void)area; return NULL; }
char *tgoto(const char *cap, int col, int row) { (void)cap; (void)col; (void)row; return NULL; }
int tputs(const char *str, int affcnt, int (*putc_)(int)) { (void)str; (void)affcnt; (void)putc_; return 0; }
int mff_no_system(const char *command) { (void)command; return -1; }

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
	int index = (int)row;
	if (ctrl) mffAfterEvent(^{ mffOnChange(ctrl, index); });
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

static char kMffPageSizeKey;

void *mffPageCreate(int width, int height) {
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(width > 0 ? width : 1, height > 0 ? height : 1), YES, 0);
	[[UIColor whiteColor] setFill];
	UIRectFill(CGRectMake(0, 0, width, height));
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	/* The object of the page keeps its picture: it is another one after each drawing */
	NSMutableArray *page = [NSMutableArray arrayWithObject:img];
	objc_setAssociatedObject(page, &kMffPageSizeKey, [NSValue valueWithCGSize:img.size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return (__bridge_retained void *)page;
}

void mffPageFree(void *page) {
	if (page) (void)(__bridge_transfer id)page;
}

void mffPageBeginDraw(void *page) {
	NSMutableArray *a = (__bridge NSMutableArray *)page;
	UIImage *img = a[0];
	UIGraphicsBeginImageContextWithOptions(img.size, YES, img.scale);
	[img drawAtPoint:CGPointZero];
}

void mffPageEndDraw(void *page) {
	NSMutableArray *a = (__bridge NSMutableArray *)page;
	a[0] = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

void mffPageDraw(void *page, int x, int y, int w, int h) {
	if (!page || !UIGraphicsGetCurrentContext()) return;
	NSMutableArray *a = (__bridge NSMutableArray *)page;
	[(UIImage *)a[0] drawInRect:CGRectMake(x, y, w, h)];
}

void mffPagesPrint(void **pages, int count, const char *name) {
	if (count <= 0) return;
	NSMutableArray *items = [NSMutableArray array];
	for (int i = 0; i < count; i++) [items addObject:((__bridge NSMutableArray *)pages[i])[0]];
	UIPrintInteractionController *c = [UIPrintInteractionController sharedPrintController];
	UIPrintInfo *info = [UIPrintInfo printInfo];
	info.jobName = mffStr(name);
	c.printInfo = info;
	c.printingItems = items;
	[c presentAnimated:YES completionHandler:nil];
}

/* ---- Dialogs: the program waits in a nested loop ---- */

@interface MffPicker : NSObject <UIDocumentPickerDelegate, UIColorPickerViewControllerDelegate>
@property (nonatomic, strong) NSArray<NSURL *> *urls;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL done;
@end

@implementation MffPicker
- (void)documentPicker:(UIDocumentPickerViewController *)c didPickDocumentsAtURLs:(NSArray<NSURL *> *)u {
	self.urls = u;
	self.done = YES;
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)c {
	self.done = YES;
}
- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)c {
	self.color = c.selectedColor;
	self.done = YES;
}
@end

static void mffWait(MffPicker *p) {
	while (!p.done) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
}

/* Open: the picker of the system (a copy of the file in the sandbox of the program). Save: the file in the Documents of the
   program, its other folders can not be written */
char *mffFileDialog(int mode, const char *caption, const char *initialDir, const char *fileName, const char *filter, int filterIndex) {
	(void)caption; (void)initialDir; (void)filter; (void)filterIndex;
	if (!mffRunning) return NULL;
	if (mode == 2) {
		NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
		return mffDup([docs stringByAppendingPathComponent:[mffStr(fileName) length] ? [mffStr(fileName) lastPathComponent] : @"Untitled"]);
	}
	MffPicker *p = [[MffPicker alloc] init];
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	UIDocumentPickerViewController *c = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[mode == 3 ? @"public.folder" : @"public.item"] inMode:mode == 3 ? UIDocumentPickerModeOpen : UIDocumentPickerModeImport];
	#pragma clang diagnostic pop
	c.delegate = p;
	c.allowsMultipleSelection = mode == 1;
	[mffTopController() presentViewController:c animated:YES completion:nil];
	mffWait(p);
	if (![p.urls count]) return NULL;
	NSMutableArray *paths = [NSMutableArray array];
	for (NSURL *u in p.urls) [paths addObject:[u path]];
	return mffDup([paths componentsJoinedByString:@"\n"]);
}

char *mffFontDialog(const char *fontName, int size, int style, int fontColor) {
	if (!mffRunning) return NULL;
	UIAlertController *a = [UIAlertController alertControllerWithTitle:@"Font" message:nil preferredStyle:UIAlertControllerStyleAlert];
	[a addTextFieldWithConfigurationHandler:^(UITextField *f) { f.text = mffStr(fontName); f.placeholder = @"Name"; }];
	[a addTextFieldWithConfigurationHandler:^(UITextField *f) { f.text = [NSString stringWithFormat:@"%d", size > 0 ? size : 10]; f.keyboardType = UIKeyboardTypeNumberPad; }];
	__block int result = -1;
	[a addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *x) { result = 1; }]];
	[a addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *x) { result = 0; }]];
	[mffTopController() presentViewController:a animated:YES completion:nil];
	while (result < 0) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
	if (!result) return NULL;
	return mffDup([NSString stringWithFormat:@"%@\n%d\n%d\n%d", a.textFields[0].text, [a.textFields[1].text intValue], style, fontColor]);
}

int mffColorDialog(const char *caption, int colorValue) {
	(void)caption;
	if (!mffRunning) return -1;
	MffPicker *p = [[MffPicker alloc] init];
	UIColorPickerViewController *c = [[UIColorPickerViewController alloc] init];
	if (colorValue >= 0) c.selectedColor = mffColor(colorValue);
	c.delegate = p;
	[mffTopController() presentViewController:c animated:YES completion:nil];
	mffWait(p);
	[c dismissViewControllerAnimated:YES completion:nil];
	CGFloat r, g, b, al;
	if (!p.color || ![p.color getRed:&r green:&g blue:&b alpha:&al]) return -1;
	return ((int)lround(r * 255)) | ((int)lround(g * 255) << 8) | ((int)lround(b * 255) << 16);
}

#define MFF_MAIN_THREAD_WRAPPERS
#include "../Apple/mffMainThread.h"
