//
//  AccountNotExistView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/8/2.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AccountNotExistView.h"

@interface AccountNotExistView()

@property (weak, nonatomic) IBOutlet UILabel *contactUsLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactUsLabel1;

@end


@implementation AccountNotExistView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contactUsLabel.userInteractionEnabled = YES;
    self.contactUsLabel1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactUsLabelTap)];
    [self.contactUsLabel addGestureRecognizer:tap];
    [self.contactUsLabel1 addGestureRecognizer:tap];
}

- (IBAction)checkAccountStatusBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkAccountStatusBtnDidClick)]) {
        [self.delegate checkAccountStatusBtnDidClick];
    }
}

- (void)contactUsLabelTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactUsLabelDidTap)]) {
        [self.delegate contactUsLabelDidTap];
    }
}

@end
