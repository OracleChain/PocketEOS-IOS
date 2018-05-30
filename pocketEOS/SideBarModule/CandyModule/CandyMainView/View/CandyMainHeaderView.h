//
//  CandyMainHeaderView.h
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandyMainHeaderView : UIView
@property(nonatomic , strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *myPointsLabel;
@end
