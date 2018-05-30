//
//  SystemSettingViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/17.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "NavigationView.h"
#import "SystemSettingService.h"
#import "BaseTabBarController.h"
#import "AppDelegate.h"
#import "RtfBrowserViewController.h"

@interface SystemSettingViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) SystemSettingService *mainService;
@end

@implementation SystemSettingViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"系统设置" rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}

- (SystemSettingService *)mainService{
    if (!_mainService) {
        _mainService = [[SystemSettingService alloc] init];
    }
    return _mainService;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    WS(weakSelf);
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        weakSelf.mainTableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT + 32, SCREEN_WIDTH, 46*self.mainService.dataSourceArray.count);
        [weakSelf.view addSubview:weakSelf.mainTableView];
        [weakSelf.mainTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
   
    cell.rightIconImgName = @"right_arrow_gray";
    [cell.contentView addSubview:cell.rightIconImageView];
    cell.rightIconImageView.sd_layout.rightSpaceToView(cell.contentView, 20).widthIs(7).heightIs(14).centerYEqualToView(cell.contentView);
    cell.textLabel.text = self.mainService.dataSourceArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.rightIconImageView.hidden = NO;
    
    if (indexPath.row == 0) {
         NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
         cell.detailTextLabel.text = [cachePath fileSize];
         cell.detailTextLabel.textColor = RGB(240, 143, 67);
         cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.rightIconImageView.hidden = YES;
        
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // clear cache
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
        NSFileManager *mgr = [NSFileManager defaultManager];
        if ([mgr fileExistsAtPath:cachePath]) {
            // 删除子文件夹
            BOOL isRemoveSuccessed = [mgr removeItemAtPath:cachePath error:nil];
            if (isRemoveSuccessed) { // 删除成功
                [TOASTVIEW showWithText:@"清理成功~"];
            }
        }
        [tableView reloadData];
        
    }else if (indexPath.row == 1){
        RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
        vc.rtfFileName = @"PocketEOSPrivacyPolicy";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        RtfBrowserViewController *vc = [[RtfBrowserViewController alloc] init];
        vc.rtfFileName = @"AboutPocketEOS";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
