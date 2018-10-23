//
//  AssestsCollectionHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/10/20.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN


@protocol AssestsCollectionHeaderViewDelegate <NSObject>

- (void)selectAssestBtnDidClick;
- (void)allSelectBtnDidClick;

@end

@interface AssestsCollectionHeaderView : BaseView

@property(nonatomic, weak) id<AssestsCollectionHeaderViewDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *accountAvatarView;
@property (weak, nonatomic) IBOutlet BaseLabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet BaseLabel *assestsNameLabel;
@property (weak, nonatomic) IBOutlet BaseLabel1 *contractNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;

@end

NS_ASSUME_NONNULL_END
