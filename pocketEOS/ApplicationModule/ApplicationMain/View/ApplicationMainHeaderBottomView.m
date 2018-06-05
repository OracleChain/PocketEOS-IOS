//
//  ApplicationMainHeaderBottomView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ApplicationMainHeaderBottomView.h"

@interface ApplicationMainHeaderBottomView()
@property (weak, nonatomic) IBOutlet UIImageView *starImg;
@property (weak, nonatomic) IBOutlet UILabel *starTitleLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *starDetailLabel;

@end


@implementation ApplicationMainHeaderBottomView

- (IBAction)starApplicationBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(starApplicationBtnDidClick:)]) {
        [self.delegate starApplicationBtnDidClick:sender];
    }
}


- (void)updateStarViewWithModel:(Application *)model{
    [self.starImg sd_setImageWithURL:String_To_URL(VALIDATE_STRING(model.applyIcon)) placeholderImage:[UIImage imageNamed:@"account_default_blue"]];
    self.starTitleLabel.text = [NSString stringWithFormat:@"%@", model.applyName];
    self.starDetailLabel.text = model.applyDetails;
}
@end
