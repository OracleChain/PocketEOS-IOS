//
//  PersonalSettingHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 08/04/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalSettingHeaderViewDelegate<NSObject>
- (void)avatarBtnDidClick:(UIButton *)sender;
- (void)nameBtnDidClick:(UIButton *)sender;
- (void)wechatIDBtnDidClick:(UIButton *)sender;
- (void)qqIDBtnBtnDidClick:(UIButton *)sender;
@end


@interface PersonalSettingHeaderView : BaseView
@property(nonatomic, weak) id<PersonalSettingHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *wechatIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqIDLabel;
@property (weak, nonatomic) IBOutlet UIView *avatarBaseView;
@property (weak, nonatomic) IBOutlet UIView *nameBaseView;
@property (weak, nonatomic) IBOutlet UIView *wechatBaseView;
@property (weak, nonatomic) IBOutlet UIView *qqBaseView;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UIView *line5;

@end
