//
//  CandyMainHeaderView.m
//  pocketEOS
//
//  Created by oraclechain on 2018/5/21.
//  Copyright © 2018 oraclechain. All rights reserved.
//
#define COLLECTIONVIEW_HEIGHT 80.0f
#define COLLECTIONVIEW_WIDTH 103.0f

#import "CandyMainHeaderView.h"
#import "CandyMainCollectionViewCell.h"
#import "CandyEquityModel.h"

@interface CandyMainHeaderView()<UICollectionViewDataSource , UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *collectionBackgroundView;

@end


@implementation CandyMainHeaderView

- (UICollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize: CGSizeMake(SCREEN_WIDTH / 3 , 170 - 30)];
        [layout setSectionInset:UIEdgeInsetsMake(10, 0, 10, 13)];
//        [layout setMinimumInteritemSpacing: 20.0f];
//        [layout setMinimumLineSpacing: 20.0f];
        [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
        _mainCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, MARGIN_20, COLLECTIONVIEW_WIDTH, COLLECTIONVIEW_HEIGHT ) collectionViewLayout: layout];
        [_mainCollectionView setDataSource: self];
        [_mainCollectionView setPagingEnabled: YES];
        [_mainCollectionView setDelegate: self];
        [_mainCollectionView setBackgroundColor: [UIColor whiteColor]];
        [_mainCollectionView setShowsVerticalScrollIndicator: NO];
        [_mainCollectionView setShowsHorizontalScrollIndicator: NO];
        [_mainCollectionView setScrollEnabled: YES];
        [_mainCollectionView registerClass: [CandyMainCollectionViewCell class] forCellWithReuseIdentifier: CELL_REUSEIDENTIFIER];
        
    }
    return _mainCollectionView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.collectionBackgroundView addSubview:self.mainCollectionView];
    self.mainCollectionView.sd_layout
    .leftSpaceToView(self.collectionBackgroundView, MARGIN_20)
    .rightSpaceToView(self.collectionBackgroundView, 0.0f)
    .topSpaceToView(self.collectionBackgroundView, 0.0f)
    .bottomSpaceToView(self.collectionBackgroundView, 0.0f);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CandyMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSEIDENTIFIER forIndexPath:indexPath];
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSEIDENTIFIER forIndexPath:indexPath];
    }
    
    CandyEquityModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
    CandyEquityModel *model = self.dataArray[indexPath.row];
    [TOASTVIEW showWithText:model.equity_description];
}

@end
