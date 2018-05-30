//
//  EnterpriseDetailHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/30.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "EnterpriseDetailHeaderView.h"
#import "Enterprise.h"
#import "Application.h"

@interface EnterpriseDetailHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *introImg;
@property (weak, nonatomic) IBOutlet UILabel *introTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recommandImg;
@property (weak, nonatomic) IBOutlet UILabel *recommandApplicationTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *recommandApplicationDetailLabel;


@end


@implementation EnterpriseDetailHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
   self.introImg.contentMode = UIViewContentModeScaleAspectFill; self.recommandApplicationDetailLabel.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
     self.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
}

/**
 企业推荐应用点击
 */
- (IBAction)recommandBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommandBtnDidClick:)]) {
        [self.delegate recommandBtnDidClick:sender];
    }
}

- (void)updateViewWithModel:(Enterprise *)model{
    [self.introImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.publicImage)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.introTextLabel.text = VALIDATE_STRING(model.summary);
    
}

- (void)upadteRecommandViewWithModel:(Application *)model{
    [self.recommandImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.applyIcon)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.recommandApplicationTitleLabel.text = VALIDATE_STRING(model.applyName);
    self.recommandApplicationDetailLabel.text = VALIDATE_STRING(model.applyDetails);
}
@end
