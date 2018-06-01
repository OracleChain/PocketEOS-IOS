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
#import "MessageFeedbackViewController.h"

@interface SystemSettingViewController ()< UIGestureRecognizerDelegate, NavigationViewDelegate, UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) SystemSettingService *mainService;
@property(nonatomic , strong) NSDictionary *dataSourceDictionary;
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
- (NSDictionary *)dataSourceDictionary{
    if (!_dataSourceDictionary) {
        _dataSourceDictionary = @{
                                  @"topSection" : @[@"消息反馈"]  ,
                                  @"bottomSection" : @[@"清空缓存", @"法律条款与隐私政策", @"关于Pocket EOS"]
                                  };
    }
    return _dataSourceDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.navView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    
    [self.mainTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell1 alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    
    cell.rightIconImgName = @"right_arrow_gray";
    [cell.contentView addSubview:cell.rightIconImageView];
    cell.rightIconImageView.sd_layout.rightSpaceToView(cell.contentView, 20).widthIs(7).heightIs(14).centerYEqualToView(cell.contentView);
    cell.rightIconImageView.hidden = NO;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.bottomLineView.hidden = YES;
    
    if (indexPath.section == 0) {
        NSArray *topArr = [self.dataSourceDictionary objectForKey:@"topSection"];
        cell.textLabel.text = topArr[indexPath.row];
        
    }else if (indexPath.section == 1){
        NSArray *bottomArr = [self.dataSourceDictionary objectForKey:@"bottomSection"];
        cell.textLabel.text = bottomArr[indexPath.row];

        if (indexPath.row == 0) {
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
            cell.detailTextLabel.text = [cachePath fileSize];
            cell.detailTextLabel.textColor = RGB(240, 143, 67);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.rightIconImageView.hidden = YES;
            cell.bottomLineView.hidden = NO;
        }else if (indexPath.row == 1){
            cell.bottomLineView.hidden = NO;
        }
        
        
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSArray *topArr = [self.dataSourceDictionary objectForKey:@"topSection"];
        return topArr.count;
    }else if (section ==  1){
        NSArray *bottomArr = [self.dataSourceDictionary objectForKey:@"bottomSection"];
        return bottomArr.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceDictionary.allKeys.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.lee_theme
    .LeeAddBackgroundColor(SOCIAL_MODE, HEXCOLOR(0xF5F5F5))
    .LeeAddBackgroundColor(BLACKBOX_MODE, HEXCOLOR(0x161823));
    headerLabel.font = [UIFont systemFontOfSize:11];
    return headerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  10;
    }else if (section == 1){
        return 20;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MessageFeedbackViewController *vc = [[MessageFeedbackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1){
        
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
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
