//
//  ApplicationDetailViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/12/15.
//  Copyright © 2017年 oraclechain. All rights reserved.
//
#define ITEMSIZE_WIDTH 75.0f
#import "ApplicationDetailViewController.h"
#import "ApplicationDetailHeaderView.h"
#import "ApplicationCollectionViewCell.h"
#import "Application.h"
#import "NavigationView.h"
#import "CDZPicker.h"

@interface ApplicationDetailViewController ()<UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation ApplicationDetailViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"应用详情" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView registerClass: [ApplicationCollectionViewCell class] forCellWithReuseIdentifier: CELL_REUSEUDENTIFIER1];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"ApplicationDetailHeaderView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Cell_Header2"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 63;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ApplicationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CELL_REUSEUDENTIFIER1 forIndexPath: indexPath];
    Application *model = [[Application alloc] init];
    [cell updateViewWithModel:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@" , indexPath);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            ApplicationDetailHeaderView *reuseableView = (ApplicationDetailHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Cell_Header2" forIndexPath:indexPath];
            return reuseableView;
        }
    }
    return reusableview;
}

- (void)leftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
