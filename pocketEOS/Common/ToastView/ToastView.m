//
//  ToastView.m
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/9.
//  Copyright © 2016 Youdar. All rights reserved.
//
#define ALERTCONTENT_VIEW 240.0f
#import "ToastView.h"
static ToastView * toastView = nil;

@interface ToastView()
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIAlertView *alertView;

@property(nonatomic, strong) UIImageView *effectMainView; //虚化背景
@property(nonatomic, strong) UIVisualEffectView *effectMainView_iOS10; //虚化背景(iOS10.0)
@property(nonatomic, strong) UIView *effectContentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIButton *cancelButton;

@end

@implementation ToastView
#pragma mark - calss method
+(ToastView *)shareManager{
    @synchronized(self) {
        if(toastView == nil){
            toastView = [[ToastView alloc] init];
        }
    }
    return toastView;
}

#pragma mark - getters and setters
- (UILabel *)textLabel{
    if(!_textLabel){
        _textLabel = [[UILabel alloc] init];
        [_textLabel setBackgroundColor: [UIColor clearColor]];
        [_textLabel setTextColor: [UIColor whiteColor]];
        [_textLabel setNumberOfLines: 0];
        [_textLabel setLineBreakMode: NSLineBreakByCharWrapping];
        [_textLabel setShadowColor: [UIColor darkGrayColor]];
        [_textLabel setShadowOffset: CGSizeMake(1.0, 1.0f)];
    }
    return _textLabel;
}

- (UIAlertView *)alertView{
    if(!_alertView){
        _alertView = [[UIAlertView alloc] initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: NSLocalizedString(@"确定", nil)otherButtonTitles: nil];
    }
    return _alertView;
}

- (UIImageView *)effectMainView{
    if(!_effectMainView){
        //UIImage
        _effectMainView = [[UIImageView alloc] init];
        [_effectMainView setImage: [UIImage gaussBlur: 0.5f]];
        [_effectMainView setUserInteractionEnabled: YES];
    }
    return _effectMainView;
}

- (UIVisualEffectView *)effectMainView_iOS10{
    if(!_effectMainView_iOS10){
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectMainView_iOS10 = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectMainView_iOS10.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _effectMainView_iOS10;
}

- (UIView *)effectContentView{
    if(!_effectContentView){
        _effectContentView = [[UIView alloc] init];
        [_effectContentView setBackgroundColor: [[UIColor alloc] initWithWhite: 0.1f alpha: 0.6f]];
    }
    return _effectContentView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment: NSTextAlignmentCenter];
        [_titleLabel setTextColor: [UIColor whiteColor]];
        [_titleLabel setFont: [UIFont systemFontOfSize: 15.0f]];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setTextAlignment: NSTextAlignmentCenter];
        [_contentLabel setTextColor: [UIColor whiteColor]];
        [_contentLabel setFont: [UIFont systemFontOfSize: 14.0f]];
    }
    return _contentLabel;
}

- (UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setImage: [UIImage imageNamed: @"ic_delete_blue"] forState: UIControlStateNormal];
        [_cancelButton addTarget: self action: @selector(cancelButtonClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark -
- (id)init{
    self = [super init];
    if(self){
        [self setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [self.layer setCornerRadius: 5.0f];
        [self.layer setMasksToBounds: YES];
        [self addSubview: self.textLabel];
    }
    return self;
}

#pragma mark - public method
/**
 *  show the specified message
 *  default duration is 2.0s
 *  @param text message
 */
- (void)showWithText:(NSString *) text{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showWithText: text duration: 2.0f];
    });
}
/**
 *  show the specified message
 *
 *  @param text     message
 *  @param duration The disappearance of time
 */
- (void)showWithText:(NSString *) text duration:(CGFloat) duration{
    if(IsStrEmpty(text)){
        return;
    }
    // Initialization code
    UIFont *font = self.textLabel.font;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = CGSizeMake(SCREEN_WIDTH - 30.0f, SCREEN_HEIGHT);
    CGSize textSize = [text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes: attributes context:nil].size;
    
    textSize.height += 20.0f;
    //update textLabel
    [self.textLabel setFrame: CGRectMake(10.0f, 10.0f, textSize.width, textSize.height)];
    [self.textLabel setText: text];
    [self.textLabel setFont: font];
    
    //update self
    CGRect frame;
    frame.size = CGSizeMake(textSize.width + 20.0f, textSize.height + 20.0f);
    frame.origin = CGPointMake((SCREEN_WIDTH - frame.size.width) / 2, SCREEN_HEIGHT /3);
    [self setFrame: frame];
    [WINDOW addSubview:self];
    
    //timer
    NSTimer *timer = [NSTimer timerWithTimeInterval: duration  target:self selector:@selector(removeToastView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

- (void)showAlertText:(NSString *) text{
    [self.alertView setTitle: NSLocalizedString(@"温馨提示", nil)];
    [self.alertView setMessage: text];
    [self.alertView show];
}

- (void)showAlertText:(NSString *) text withTitle: (NSString *)title{
    [self.alertView setTitle: title];
    [self.alertView setMessage: text];
    [self.alertView show];
}

- (void)showCustomerAlertText:(NSString *) text withTitle: (NSString *)title{
   
    [self loadCustomerAlertView];
    
    [self.effectContentView addSubview: self.cancelButton];
    self.cancelButton.sd_layout
    .centerXEqualToView(self.effectContentView)
    .topSpaceToView(self.contentLabel, 30.0f)
    .heightIs(25.0f)
    .widthEqualToHeight();
    
    [self.effectContentView setupAutoHeightWithBottomView: self.cancelButton bottomMargin: 15.0f];
    [self.effectContentView updateLayout];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0f){
        self.effectContentView.sd_layout
        .topSpaceToView(self.effectMainView, (SCREEN_HEIGHT - self.effectContentView.height) / 2.0f - NAVIGATIONBAR_HEIGHT);
    }
    else{
        self.effectContentView.sd_layout
        .topSpaceToView(self.effectMainView_iOS10, (SCREEN_HEIGHT - self.effectContentView.height) / 2.0f - NAVIGATIONBAR_HEIGHT);
    }
    
    
    //data bind
    [self.titleLabel setText: title];
    [self.contentLabel setText: text];
}

- (void)showCustomerAlertText:(NSString *) text withTitle: (NSString *)title cancelButton:(UIButton *) customerCancelButton Button:(UIButton *) button{
    
    [self loadCustomerAlertView];
    
    CGFloat margin = 30.0f;
    [self.effectContentView addSubview: customerCancelButton];
    customerCancelButton.sd_layout
    .topSpaceToView(self.contentLabel, 30.0f)
    .leftSpaceToView(self.effectContentView, margin)
    .widthIs((ALERTCONTENT_VIEW - 3 * margin) / 2.0f)
    .heightIs(30.0f);
    [customerCancelButton setTag: 0];
    [customerCancelButton addTarget: self action: @selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.effectContentView addSubview: button];
    button.sd_layout
    .topEqualToView(customerCancelButton)
    .leftSpaceToView(customerCancelButton, margin)
    .rightSpaceToView(self.effectContentView, margin)
    .heightIs(30.0f);
    [button setTag: 1];
    [button addTarget: self action: @selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.effectContentView setupAutoHeightWithBottomView: customerCancelButton bottomMargin: 15.0f];
    [self.effectContentView updateLayout];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0f){
        self.effectContentView.sd_layout
        .topSpaceToView(self.effectMainView, (SCREEN_HEIGHT - self.effectContentView.height) / 2.0f - NAVIGATIONBAR_HEIGHT);
    }
    else{
        self.effectContentView.sd_layout
        .topSpaceToView(self.effectMainView_iOS10, (SCREEN_HEIGHT - self.effectContentView.height) / 2.0f - NAVIGATIONBAR_HEIGHT);
    }
    
    //data bind
    [self.titleLabel setText: title];
    [self.contentLabel setText: text];
}

#pragma mark - 加载自定义视图
- (void)loadCustomerAlertView{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0f){
        [WINDOW addSubview: self.effectMainView];
        self.effectMainView.sd_layout
        .leftSpaceToView(WINDOW, 0.0f)
        .topSpaceToView(WINDOW, 0.0f)
        .bottomSpaceToView(WINDOW, 0.0f)
        .rightSpaceToView(WINDOW, 0.0f);
        
        [self.effectMainView addSubview: self.effectContentView];
        self.effectContentView.sd_layout
        .widthIs(ALERTCONTENT_VIEW)
        .centerXEqualToView(self.effectMainView);
    }
    else{
        [WINDOW addSubview: self.effectMainView_iOS10];
        self.effectMainView_iOS10.sd_layout
        .leftSpaceToView(WINDOW, 0.0f)
        .topSpaceToView(WINDOW, 0.0f)
        .bottomSpaceToView(WINDOW, 0.0f)
        .rightSpaceToView(WINDOW, 0.0f);
        
        [self.effectMainView_iOS10 addSubview: self.effectContentView];
        self.effectContentView.sd_layout
        .widthIs(ALERTCONTENT_VIEW)
        .centerXEqualToView(self.effectMainView_iOS10);
    }
    
    
    
    
    [self.effectContentView addSubview: self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self.effectContentView, 10.0f)
    .topSpaceToView(self.effectContentView, 15.0f)
    .rightSpaceToView(self.effectContentView, 10.0f)
    .autoHeightRatio(0);
    
    [self.effectContentView addSubview: self.contentLabel];
    self.contentLabel.sd_layout
    .leftSpaceToView(self.effectContentView, 20.0f)
    .topSpaceToView(self.titleLabel, 15.0f)
    .rightSpaceToView(self.effectContentView, 20.0f)
    .autoHeightRatio(0);
}

#pragma mark － remove toastView
- (void)removeToastView{
    [UIView animateWithDuration: 0.5f animations:^{
        toastView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [toastView removeFromSuperview];
        toastView = nil;
    }];
}

- (void)cancelButtonClick{
    [self dismiss];
}

- (void)dismiss{
    if(!IsNilOrNull(_effectMainView)){
        [self.effectMainView removeFromSuperview];
        self.effectMainView = nil;
    }
    
    if(!IsNilOrNull(_effectMainView_iOS10)){
        [self.effectMainView_iOS10 removeFromSuperview];
        self.effectMainView_iOS10 = nil;
    }
}

#pragma mark - button action
- (void)buttonClick:(UIButton *)sender{
    if(IsNilOrNull(self.onButtonClick)){
        return;
    }
    self.onButtonClick(sender.tag);
}
@end
