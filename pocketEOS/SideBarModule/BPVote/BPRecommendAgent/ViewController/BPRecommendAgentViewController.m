//
//  BPRecommendAgentViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/8.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "BPRecommendAgentViewController.h"

@interface BPRecommendAgentViewController ()<NavigationViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@end

@implementation BPRecommendAgentViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back_white" title:NSLocalizedString(@"推荐代理人", nil)rightBtnImgName:@"" delegate:self];
        _navView.backgroundColor = HEXCOLOR(0x000000);
        _navView.titleLabel.textColor = HEXCOLOR(0xFFFFFF);
    }
    return _navView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.view.backgroundColor = HEXCOLOR(0x000000);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    cell.backgroundColor = HEXCOLOR(0x000000);
    cell.textLabel.text =@"sww";
    cell.textLabel.textColor = HEXCOLOR(0xFFFFFF);
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.mainService.dataSourceArray.count;
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [TOASTVIEW showWithText:[NSString stringWithFormat:@"%@", indexPath]];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68.5;
}

-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
