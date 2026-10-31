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
#include "../Apple/mffApple.h"

static char kMffCtrlKey, kMffItemsKey, kMffChecksKey, kMffFileViewKey;
static void mffFileViewChoose(id table, id owner, NSInteger row, BOOL activate);
static BOOL mffSilent, mffRunning;
static int mffDblClick;
static UIWindow *mffMainWindow;
static UIView *mffMainFormView;
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

/* The view of a control without a view of its own kind, the view of a form */
@interface MffView : UIView
@property (nonatomic, strong) UIImage *mffImage;
@property (nonatomic) BOOL mffImageCenter, mffModal, mffModalDone;
@end

@implementation MffView
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
	if (ctrl && self == mffMainFormView) mffOnResize(ctrl, (int)self.bounds.size.width, (int)self.bounds.size.height);
}
- (void)touch:(NSSet *)t action:(int)action {
	void *ctrl = mffGetCtrl(self);
	if (!ctrl) return;
	CGPoint p = [[t anyObject] locationInView:self];
	mffOnMouse(ctrl, action, action == 2 ? 0 : 0, (int)p.x, (int)p.y, 0);
}
- (void)touchesBegan:(NSSet *)t withEvent:(UIEvent *)e { [self touch:t action:0]; }
- (void)touchesMoved:(NSSet *)t withEvent:(UIEvent *)e { [self touch:t action:2]; }
- (void)touchesEnded:(NSSet *)t withEvent:(UIEvent *)e {
	[self touch:t action:1];
	void *ctrl = mffGetCtrl(self);
	if (ctrl && self != mffMainFormView) {
		if ([[t anyObject] tapCount] == 2) mffOnDblClick(ctrl); else mffOnClick(ctrl);
	}
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

@interface MffTabsView : MffView
@property (nonatomic, strong) UISegmentedControl *segments;
@property (nonatomic) int tabPosition;
@end

@implementation MffTabsView
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect b = self.bounds;
	self.segments.frame = CGRectMake(0, self.tabPosition == 3 ? b.size.height - 28 : 0, b.size.width, 28);
}
@end

@interface MffButtonsView : MffView
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) CGFloat contentWidth;
@end

@implementation MffButtonsView
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
@property (nonatomic) int index;
- (void)mffUpdate;
@end

@implementation MffComboButton
- (void)mffUpdate {
	NSString *t = (self.index >= 0 && self.index < (int)[self.items count]) ? self.items[self.index] : @"";
	[self setTitle:[t stringByAppendingString:@" ▾"] forState:UIControlStateNormal];
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

static NSString *mffCellText(NSString *s) {
	if ([s hasPrefix:@"\x01"]) {
		NSRange end = [s rangeOfString:@"\x01" options:0 range:NSMakeRange(1, [s length] - 1)];
		if (end.location != NSNotFound) return [s substringFromIndex:end.location + 1];
	}
	return s;
}

@implementation MffTarget
- (void)buttonTap:(UIButton *)b {
	void *ctrl = mffGetCtrl(b);
	if ([b isKindOfClass:[MffCheckButton class]]) {
		MffCheckButton *c = (MffCheckButton *)b;
		c.mffChecked = c.mffRadio ? 1 : !c.mffChecked;
		[c mffUpdate];
	}
	if (ctrl) mffOnClick(ctrl);
}
- (void)comboTap:(MffComboButton *)b {
	UIAlertController *a = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	for (NSUInteger i = 0; i < [b.items count]; i++) {
		[a addAction:[UIAlertAction actionWithTitle:b.items[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *x) {
			b.index = (int)i;
			[b mffUpdate];
			void *ctrl = mffGetCtrl(b);
			if (ctrl) mffOnChange(ctrl, (int)i);
		}]];
	}
	[a addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	a.popoverPresentationController.sourceView = b;
	[mffTopController() presentViewController:a animated:YES completion:nil];
}
- (void)sliderChanged:(UISlider *)s {
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
- (void)tabsTap:(UISegmentedControl *)s {
	void *ctrl = mffGetCtrl(s.superview);
	if (ctrl) mffOnChange(ctrl, (int)s.selectedSegmentIndex);
}
- (void)buttonsTap:(UIButton *)b {
	void *ctrl = mffGetCtrl(b.superview);
	if (ctrl) mffOnChange(ctrl, (int)b.tag);
}
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return [mffItems(t) count]; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
	UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"mff"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mff"];
	NSArray *a = mffItems(t);
	id item = p.row < (NSInteger)[a count] ? a[p.row] : @"";
	NSString *text = [item isKindOfClass:[NSArray class]] ? [(NSArray *)item componentsJoinedByString:@"   "] : item;
	c.textLabel.text = mffCellText(text);
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
	void *ctrl = mffGetCtrl(t);
	if (ctrl && !mffSilent) mffOnChange(ctrl, (int)p.row);
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

void *mffViewCreate(const char *kind, void *ctrl) {
	NSString *k = mffStr(kind);
	CGRect r = CGRectMake(0, 0, 100, 30);
	id obj = nil;
	MffTarget *t = mffTarget();
	if ([k isEqualToString:@"Form"]) {
		MffView *v = [[MffView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		v.backgroundColor = [UIColor systemBackgroundColor];
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
	} else if ([k isEqualToString:@"Label"] || [k isEqualToString:@"LinkLabel"]) {
		UILabel *l = [[UILabel alloc] initWithFrame:r];
		l.numberOfLines = 0;
		obj = l;
	} else if ([k isEqualToString:@"TextBox"] || [k isEqualToString:@"ComboBox"]) {
		UITextField *f = [[UITextField alloc] initWithFrame:r];
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
		v.segments = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
		[v.segments addTarget:t action:@selector(tabsTap:) forControlEvents:UIControlEventValueChanged];
		[v addSubview:v.segments];
		obj = v;
	} else if ([k isEqualToString:@"ToolBar"] || [k isEqualToString:@"ToolPalette"]) {
		MffButtonsView *v = [[MffButtonsView alloc] initWithFrame:r];
		v.buttons = [NSMutableArray array];
		obj = v;
	} else if ([k isEqualToString:@"WebBrowser"]) {
		obj = [[WKWebView alloc] initWithFrame:r configuration:[[WKWebViewConfiguration alloc] init]];
	} else if ([k isEqualToString:@"ListControl"] || [k isEqualToString:@"CheckedListBox"] || [k isEqualToString:@"ListView"] || [k isEqualToString:@"TreeView"] || [k isEqualToString:@"TreeListView"] || [k isEqualToString:@"GridData"] || [k isEqualToString:@"Grid"] || [k isEqualToString:@"OpenFileControl"]) {
		UITableView *v = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
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
	} else if ([k isEqualToString:@"TrackBar"]) {
		UISlider *s = [[UISlider alloc] initWithFrame:r];
		s.minimumValue = 0;
		s.maximumValue = 10;
		[s addTarget:t action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
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
	if ([o isKindOfClass:[UIView class]]) [(UIView *)o removeFromSuperview];
}

void *mffViewControl(void *view) { return view ? mffGetCtrl(mffObj(view)) : NULL; }

void *mffViewLayout(void *view) { return view; }

void mffViewAddChild(void *parent, void *child) {
	UIView *p = mffView(parent), *c = mffView(child);
	if (p && c && c.superview != p) [p addSubview:c];
}

void mffViewSetBounds(void *view, int x, int y, int w, int h) {
	UIView *v = mffView(view);
	/* A form has the size of the screen */
	if (!v || v == mffMainFormView || !mffGetCtrl(v)) return;
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
		if (index < 0 || index > (int)[b.items count]) [b.items addObject:s]; else [b.items insertObject:s atIndex:index];
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
		if (index >= 0 && index < (int)[b.items count]) [b.items removeObjectAtIndex:index];
		[b mffUpdate];
	}
}
void mffListClear(void *view) {
	id o = mffObj(view);
	UITableView *t = mffTable(view);
	if (t) { [mffItems(t) removeAllObjects]; [t reloadData]; }
	else if ([o isKindOfClass:[MffComboButton class]]) { [((MffComboButton *)o).items removeAllObjects]; ((MffComboButton *)o).index = -1; [(MffComboButton *)o mffUpdate]; }
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
	else if ([o isKindOfClass:[UIProgressView class]]) {
		objc_setAssociatedObject(o, &kMffMinKey, @(minValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		objc_setAssociatedObject(o, &kMffMaxKey, @(maxValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}
void mffPositionSet(void *view, int value) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UISlider class]]) [(UISlider *)o setValue:value];
	else if ([o isKindOfClass:[MffTabsView class]]) ((MffTabsView *)o).segments.selectedSegmentIndex = value;
	else if ([o isKindOfClass:[UIProgressView class]]) {
		int lo = [objc_getAssociatedObject(o, &kMffMinKey) intValue];
		NSNumber *m = objc_getAssociatedObject(o, &kMffMaxKey);
		int hi = m ? [m intValue] : 100;
		[(UIProgressView *)o setProgress:hi > lo ? (float)(value - lo) / (hi - lo) : 0];
	}
}
int mffPositionGet(void *view) {
	id o = mffObj(view);
	if ([o isKindOfClass:[UISlider class]]) return (int)lround([(UISlider *)o value]);
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
	if (!v.superview && v != mffMainFormView) {
		v.frame = mffMainWindow.rootViewController.view.bounds;
		v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[mffMainWindow.rootViewController.view addSubview:v];
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
	if (v != mffMainFormView) [v removeFromSuperview];
}
void mffFormSetState(void *view, int state) { (void)view; (void)state; }
void mffFormSetBorder(void *view, int style) { (void)view; (void)style; }
void mffFormSetMainMenu(void *view, const char *items) { (void)view; (void)items; }
void mffMenuBarSet(const char *items) { (void)items; }
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
- (void)viewSafeAreaInsetsDidChange {
	[super viewSafeAreaInsetsDidChange];
	mffMainFormView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
}
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	mffMainFormView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
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
	MffRootController *root = [[MffRootController alloc] init];
	root.view.backgroundColor = [UIColor systemBackgroundColor];
	self.window.rootViewController = root;
	mffRunning = YES;
	/* The forms shown before UIApplicationMain: the first one is the main form */
	for (UIView *v in mffFormsToShow) {
		if (!mffMainFormView) {
			mffMainFormView = v;
			[root.view addSubview:v];
		} else {
			mffFormShow((__bridge void *)v, 0);
		}
	}
	[self.window makeKeyAndVisible];
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
	mffMainWindow.overrideUserInterfaceStyle = value < 0 ? UIUserInterfaceStyleUnspecified : (value ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight);
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
	UISegmentedControl *seg = ((MffTabsView *)o).segments;
	NSInteger selected = seg.selectedSegmentIndex;
	[seg removeAllSegments];
	NSArray *lines = [mffStr(titles) length] ? [mffStr(titles) componentsSeparatedByString:@"\n"] : @[];
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		[seg insertSegmentWithTitle:mffNoMnemonic(f[0]) atIndex:i animated:NO];
	}
	if (selected >= 0 && selected < (NSInteger)[lines count]) seg.selectedSegmentIndex = selected;
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
	for (id b in v.buttons) if ([b isKindOfClass:[UIView class]]) [(UIView *)b removeFromSuperview];
	[v.buttons removeAllObjects];
	NSArray *lines = [mffStr(items) length] ? [mffStr(items) componentsSeparatedByString:@"\n"] : @[];
	CGFloat x = 0, y = 0, rowHeight = 0, width = v.bounds.size.width, right = 0;
	for (NSUInteger i = 0; i < [lines count]; i++) {
		NSArray *f = [lines[i] componentsSeparatedByString:@"\t"];
		NSString *first = f[0];
		unichar flag = [first length] ? [first characterAtIndex:0] : '0';
		if (flag == '4' || flag == '3') {
			[v.buttons addObject:[NSNull null]];
			if (flag == '3') x += 8;
			continue;
		}
		UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
		UIImage *img = ([f count] > 1 && [f[1] length]) ? [UIImage imageWithContentsOfFile:f[1]] : nil;
		NSString *options = [f count] > 2 ? f[2] : @"";
		if (img) [b setImage:img forState:UIControlStateNormal];
		if (!img || [options rangeOfString:@"S"].location != NSNotFound) [b setTitle:[first length] > 1 ? mffNoMnemonic([first substringFromIndex:1]) : @"" forState:UIControlStateNormal];
		b.enabled = flag != '1';
		b.selected = flag == '2';
		b.tag = i;
		[b addTarget:mffTarget() action:@selector(buttonsTap:) forControlEvents:UIControlEventTouchUpInside];
		[b sizeToFit];
		CGSize s = b.frame.size;
		s.width = MAX(s.width + 8, 32);
		s.height = MAX(s.height, 32);
		if (x > 0 && width > 0 && x + s.width > width) { x = 0; y += rowHeight; rowHeight = 0; }
		b.frame = CGRectMake(x, y, s.width, s.height);
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
void mffTableSetView(void *view, const char *viewName) { (void)view; (void)viewName; }
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
