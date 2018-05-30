//
//  AskQuestionTableViewCell.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/11.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AskQuestionTableViewCell.h"
#import "AskQuestionModel.h"


@interface AskQuestionTableViewCell()

/**
 选项lable A./B./C./D./E./F.
 */
@property(nonatomic, strong) BaseLabel *optionLabel;



@end

@implementation AskQuestionTableViewCell

- (BaseLabel *)optionLabel{
    if (!_optionLabel) {
        _optionLabel = [[BaseLabel alloc] init];
        [_optionLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _optionLabel;
}

- (BaseTextView *)editTextView{
    if (!_editTextView) {
        _editTextView = [[BaseTextView alloc] init];
        [_editTextView setFont:[UIFont systemFontOfSize:14]];
        _editTextView.placeholder = @"输入答案选项";
    }
    return _editTextView;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_answer_option"] forState:(UIControlStateNormal)];
        [_deleteBtn addTarget:self action:@selector(deleteCurrentRow   :) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.optionLabel];
        self.optionLabel.sd_layout.leftSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(self.contentView).widthIs(15).heightIs(18);
        
        [self.contentView addSubview:self.editTextView];
        self.editTextView.sd_layout.leftSpaceToView(_optionLabel, 0).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 40).heightIs(40);
        
        [self.contentView addSubview:self.deleteBtn];
        self.deleteBtn.sd_layout.rightSpaceToView(self.contentView, MARGIN_20).centerYEqualToView(_editTextView).widthIs(10).heightIs(10);
        
    }
    return self;
}

- (void)setModel:(AskQuestionModel *)model{
    self.optionLabel.text = model.optionStr;
}

- (void)deleteCurrentRow:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCurrentRowBtnDidClick:)]) {
        [self.delegate deleteCurrentRowBtnDidClick: self];
    }
}

@end
