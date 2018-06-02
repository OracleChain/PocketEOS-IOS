//
//  ImageAndTipLabelViewManager.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/31.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImageAndTipLabelViewManager.h"

@interface ImageAndTipLabelViewManager()
@property (nonatomic,strong) UIView *baseView;
@property(nonatomic , strong) UIImageView *img;
@property(nonatomic , strong) BaseLabel1 *tipLabel;
@end

static ImageAndTipLabelViewManager * manager = nil;
@implementation ImageAndTipLabelViewManager

+(ImageAndTipLabelViewManager *)shareManager{
    @synchronized(self) {
        if(manager == nil){
            manager = [[ImageAndTipLabelViewManager alloc] init];
        }
    }
    return manager;
}

- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
    }
    return _baseView;
}
- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _img;
}
- (BaseLabel1 *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[BaseLabel1 alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (void)showImageAddTipLabelViewWithSocial_Mode_ImageName:(NSString *)imageName andBlackbox_Mode_ImageName:(NSString *)imageName_BB andTitleStr:(NSString *)titleStr toView:(UIView *)parentView andViewController:(UIViewController *) viewController{
    [self showImageAddTipLabelViewWithSocial_Mode_ImageName:imageName andBlackbox_Mode_ImageName:imageName_BB andTitleStr:titleStr toView:parentView andViewController:viewController tag:0];
}

-(void)showImageAddTipLabelViewWithSocial_Mode_ImageName:(NSString *)imageName andBlackbox_Mode_ImageName:(NSString *)imageName_BB andTitleStr:(NSString *)titleStr toView:(UIView *)parentView andViewController:(UIViewController *) viewController tag:(NSInteger)tag
{
    
    self.img.lee_theme
    .LeeAddImage(SOCIAL_MODE, [UIImage imageNamed:imageName])
    .LeeAddImage(BLACKBOX_MODE, [UIImage imageNamed:imageName_BB]);
    
    self.tipLabel.text = titleStr;
    
    [self.baseView addSubview:self.img];
    [self.baseView addSubview:self.tipLabel];
    
    self.baseView.frame = parentView.bounds;
    
    self.img.sd_layout.centerYEqualToView(self.baseView).centerXEqualToView(self.baseView).widthIs(160).heightIs(160);
    
    
    self.tipLabel.sd_layout.topSpaceToView(self.img, 34).centerXEqualToView(self.baseView).widthIs(SCREEN_WIDTH).heightIs(14);
    [parentView addSubview:self.baseView];
    
    [self.baseView addSubview:self.img];
    [self.baseView addSubview:self.tipLabel];

}

- (void)removeImageAndTipLabelViewManager{
    if (self.baseView) {
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
}



@end
