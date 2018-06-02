//
//  BaseViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2017/11/27.
//  Copyright © 2017年 oraclechain. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate , UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UIView *noDataView;


@end

@implementation BaseViewController


/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        if (LEETHEME_CURRENTTHEME_IS_SOCAIL_MODE) {
            _mainTableView.separatorColor = HEX_RGB(0xEEEEEE);
            
        }else if (LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
            _mainTableView.separatorColor = HEX_RGB_Alpha(0xFFFFFF, 0.1);
        }
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _mainTableView.mj_header = header;
        
        //底部刷新
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        //        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        
        _mainTableView.scrollsToTop = YES;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}

- (void)loadNewData{}
- (void)loadMoreData{}



- (UICollectionView *)mainCollectionView{
    if(!_mainCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize: CGSizeMake(SCREEN_WIDTH / 2 - 1, 66)];
        
        layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 338 + SCREEN_WIDTH * 0.40 );
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT) collectionViewLayout: layout];
    _mainCollectionView.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
        [_mainCollectionView setDataSource: self];
        [_mainCollectionView setDelegate: self];
        [_mainCollectionView setShowsVerticalScrollIndicator: NO];
        
    }
    return _mainCollectionView;
}


// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏默认的navigationBar
    [self.navigationController.navigationBar setHidden: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示默认的navigationBar
    [self.navigationController.navigationBar setHidden: NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.lee_theme.LeeConfigBackgroundColor(@"baseView_background_color");
    if ([[LEETheme currentThemeTag ] isEqualToString:SOCIAL_MODE]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else if(LEETHEME_CURRENTTHEME_IS_BLACKBOX_MODE){
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

}


+ (void)showNoDataViewWithImageName:(NSString *)imageName andTitleStr:(NSString *)titleStr toView:(UIView *)parentView andViewController:(UIViewController *) viewController{
    [self showNoDataViewWithImageName:imageName andTitleStr:titleStr toView:parentView andViewController:viewController];
}

-(void)showNoDataViewWithImageName:(NSString *)imageName andTitleStr:(NSString *)titleStr toView:(UIView *)parentView andViewController:(UIViewController *) viewController tag:(NSInteger)tag
{
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:imageName];
    img.contentMode = UIViewContentModeScaleAspectFill;
    
    BaseLabel *label = [[BaseLabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.text = titleStr;
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.noDataView addSubview:img];
    [self.noDataView addSubview:label];
    
    [parentView addSubview:self.noDataView];
}


-(void)removeNoDataView{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}





@end
