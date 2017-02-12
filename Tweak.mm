#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDTMColours.h"
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"
#import "DDViewControllerPeekDetection.h"

// MARK: - Main Application

%hook SMSApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    [application _setBackgroundStyle:[DDTMColours blurStyle]];
    UIWindow *window = MSHookIvar<UIWindow *>(application, "_window");
    [window setBackgroundColor:[UIColor clearColor]];
    [window setOpaque:NO];
    return result;
}

-(void)_setBackgroundStyle:(UIBackgroundStyle)style {
    %orig([DDTMColours blurStyle]);
}

%end

// MARK: - Theme Changes

%hook CKUIThemeLight

-(UIColor *)messagesControllerBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)conversationListBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)conversationListSenderColor {
    return [DDTMColours listTitleColour];
}

-(UIColor *)conversationListSummaryColor {
    return [DDTMColours listSubtitleColour];
}

-(UIColor *)conversationListDateColor {
    return [DDTMColours listSubtitleColour];
}

-(id)gray_balloonColors {
    return @[[UIColor colorWithWhite:1 alpha:0.65], [UIColor colorWithWhite:1 alpha:0.5]];
}

-(UIColor *)stickerDetailsSubheaderTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptDeemphasizedTextColor {
    return [DDTMColours insideChatViewLabelSubtleColour];
}

-(UIColor *)appTintColor {
    return %orig;
}

-(UIColor *)entryFieldCoverFillColor {
    return [DDTMColours entryFieldCoverFillColor];
}

-(UIColor *)entryFieldCoverBorderColor {
    return [DDTMColours entryFieldCoverBorderColor];
}

-(UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDark;
}

%end

// MARK: - Make navigation bar more translucent

%hook CKAvatarNavigationBar

-(void)_commonNavBarInit {
    %orig;
    _UIBarBackground *barBackgroundView = MSHookIvar<_UIBarBackground *>(self, "_barBackgroundView");
    [barBackgroundView setDDIsInAvatarNavigationBar:YES];
}

%end

%hook _UIBarBackground

-(id)_blurWithStyle:(long long)arg1 tint:(id)arg2 {
    if([self DDIsInAvatarNavigationBar]) {
        return [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return %orig;
}

%new
-(BOOL)DDIsInAvatarNavigationBar {
    NSNumber *isInAvatarNavigationBar = objc_getAssociatedObject(self, @selector(DDIsInAvatarNavigationBar));
    return [isInAvatarNavigationBar boolValue];
}

%new
-(void)setDDIsInAvatarNavigationBar:(BOOL)isInAvatarNavigationBar {
    objc_setAssociatedObject(self, @selector(DDIsInAvatarNavigationBar), @(isInAvatarNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook CKMessageEntryView

-(id)initWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldAllowImpact:(BOOL)arg3 shouldShowSendButton:(BOOL)arg4 shouldShowSubject:(BOOL)arg5 shouldShowPluginButtons:(BOOL)arg6 shouldShowCharacterCount:(BOOL)arg7 {
    self = %orig;
    [self DDInitialize];
    return self;
}

-(id)initForFullscreenAppViewWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldAllowImpact:(BOOL)arg3 shouldShowSendButton:(BOOL)arg4 shouldShowSubject:(BOOL)arg5 shouldShowBrowserButton:(BOOL)arg6 shouldShowCharacterCount:(BOOL)arg7 {
    self = %orig;
    [self DDInitialize];
    return self;
}

-(id)initWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldShowSendButton:(BOOL)arg3 shouldShowSubject:(BOOL)arg4 shouldShowPluginButtons:(BOOL)arg5 shouldShowCharacterCount:(BOOL)arg6 {
    self = %orig;
    [self DDInitialize];
    return self;
}

%new
-(void)DDInitialize {
    [[self backdropView] setDDIsMessageEntryView:YES];
}

%end

%hook _UIBackdropView

-(UIView *)colorTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setColorTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

-(UIView *)effectView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setEffectView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

-(UIView *)colorBurnTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setColorBurnTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

-(UIView *)grayscaleTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setGrayscaleTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

%new
-(BOOL)DDIsMessageEntryView {
    NSNumber *isMessageEntryView = objc_getAssociatedObject(self, @selector(DDIsMessageEntryView));
    return [isMessageEntryView boolValue];
}

%new
-(void)setDDIsMessageEntryView:(BOOL)isMessageEntryView {
    objc_setAssociatedObject(self, @selector(DDIsMessageEntryView), @(isMessageEntryView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook CKEntryViewButton

-(UIColor *)ckTintColor {
    %log;
    NSLog(@"[TranslucentMessages] FUCK FFS");
    if([self.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")]) {
        NSLog(@"[TranslucentMessages] FUCK YEAH");
        return [DDTMColours entryFieldButtonColor];
    }
    return %orig;
}

-(void)setCkTintColor:(UIColor *)tintColor {
    %orig([self ckTintColor]);
}

%end

// MARK: - Fix balloon mask

%hook CKBalloonView

-(BOOL)canUseOpaqueMask {
    return NO;
}

-(void)setCanUseOpaqueMask:(BOOL)arg1 {
    %orig(NO);
}

%end

// MARK: - Nav Controller?

%hook CKViewController

-(UIView *)view {
    UIView *orig = %orig;
    [self handleBG:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self handleBG:orig];
    %orig;
}

-(void)setDDPreviewing:(BOOL)previewing {
    %orig;
    [self handleBG:self.view];
}

%new
-(void)handleBG:(UIView *)view {
    [view setOpaque:NO];
    [view setBackgroundColor:[[DDTMColours viewBackgroundColour] colorWithAlphaComponent:([self DDPreviewing] ? 0.7 : 0)]];
}

%end

// MARK: - Conversation List

%hook CKConversationListController

-(UIView *)view {
    UIView *orig = %orig;
    [self setDDProperTransparencyOnView:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self setDDProperTransparencyOnView:orig];
    %orig;
}

- (UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location {
    UIViewController *vc = %orig;
    if(vc) {
        [vc setDDPreviewing:YES];
    }
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
commitViewController:(UIViewController *)viewControllerToCommit {
    %orig;
    [viewControllerToCommit setDDPreviewing:NO];
}

%end

%hook CKConversationListTableView

-(void)layoutSubviews {
    %orig;
    [self setSeparatorColor:[self separatorColor]];
}

-(UIColor *)separatorColor {
    return [DDTMColours separatorColour];
}

-(void)setSeparatorColor:(UIColor *)color {
    %orig([self separatorColor]);
}

%end

%hook CKConversationListCell

-(void)layoutSubviews {
    // Chevron
    UIImageView *chevronImageView = MSHookIvar<UIImageView *>(self, "_chevronImageView");
    [chevronImageView setImage:[chevronImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [chevronImageView setTintColor:[DDTMColours separatorColour]];
    
    // Selection Colour
    UIView *selectionView = [[UIView alloc] init];
    [selectionView setBackgroundColor:[DDTMColours selectionColour]];
    [self setSelectedBackgroundView:selectionView];
    
    %orig;
}

-(UIColor *)backgroundColor {
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([UIColor clearColor]);
}

%end

// MARK: - DDViewControllerPeekDetection Hooks

%hook UIViewController

%new
-(BOOL)DDPreviewing {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDPreviewing));
    return [previewing boolValue];
}

%new
-(void)setDDPreviewing:(BOOL)previewing {
    objc_setAssociatedObject(self, @selector(DDPreviewing), @(previewing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

// MARK: - DDViewControllerTransparency Hooks

%hook UIViewController

%new
-(void)setDDProperTransparencyOnView:(UIView *)view {
    [self setDDHasProperTransparency:YES];
    [view setBackgroundColor:[DDTMColours viewBackgroundColour]];
    [view setOpaque:NO];
}

%new
-(BOOL)DDHasProperTransparency {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDHasProperTransparency));
    return [previewing boolValue];
}

%new
-(void)setDDHasProperTransparency:(BOOL)hasProperTransparency {
    objc_setAssociatedObject(self, @selector(DDHasProperTransparency), @(hasProperTransparency), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end
