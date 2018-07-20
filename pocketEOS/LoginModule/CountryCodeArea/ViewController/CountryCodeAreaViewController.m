//
//  CountryCodeAreaViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/6.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CountryCodeAreaViewController.h"
#import "AreaCodeService.h"
#import "IndexTipView.h"

@interface CountryCodeAreaViewController ()
@property(nonatomic , strong) AreaCodeService *mainService;
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) IndexTipView *indexTipView;

@end

@implementation CountryCodeAreaViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"" title:NSLocalizedString(@"选择地区", nil)rightBtnImgName:@"" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    }
    return _navView;
}



- (AreaCodeService *)mainService{
    if (!_mainService) {
        _mainService = [[AreaCodeService alloc] init];
    }
    return _mainService;
}

- (IndexTipView *)indexTipView{
    if (!_indexTipView) {
        _indexTipView = [[IndexTipView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT / 2, 40, 33)];
    }
    return _indexTipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self buildDataSource];
    
}
- (void)buildDataSource{
    WS(weakSelf);
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        if (weakSelf.mainService.keysArray.count > 0) {
            [weakSelf.mainTableView reloadData];
        }
    }];
}


#pragma mark - tableviewDataSource & delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainService.keysArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELL_REUSEIDENTIFIER];
    }
    if (self.mainService.keysArray.count > 0) {
        NSString *key = self.mainService.keysArray[indexPath.section];
        NSArray *areaCodeModelArr = [self.mainService.dataDictionary objectForKey: key];
        AreaCodeModel *model = areaCodeModelArr[indexPath.row];
        if ([NSBundle isChineseLanguage]) {
            cell.textLabel.text = model.zh;
        }else{
            cell.textLabel.text = model.en;
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@", model.code];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mainService.keysArray.count > 0) {
        NSString *key = self.mainService.keysArray[indexPath.section];
        NSArray *areaCodeModelArr = [self.mainService.dataDictionary objectForKey: key];
        AreaCodeModel *model = areaCodeModelArr[indexPath.row];
        NSLog(@"%@, %@" , model.zh, model.code);
        if (self.delegate && [self.delegate respondsToSelector:@selector(countryCodeAreaCellDidSelect:)]) {
            [self.delegate countryCodeAreaCellDidSelect:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.mainService.keysArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    self.indexTipView.hidden = NO;
    self.indexTipView.text = title;
    [self.navigationController.view addSubview:self.indexTipView];
    [self performSelector:@selector(hideIndexTipView) withObject:nil afterDelay:0.5];
    return index;
}

- (void)hideIndexTipView{
    self.indexTipView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mainService.keysArray.count > 0) {
        NSArray *arr = [self.mainService.dataDictionary objectForKey: self.mainService.keysArray[section]];
        return arr.count;
        
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.mainService.keysArray.count > 0) {
        BaseLabel *headerLabel = [[BaseLabel alloc] init];
        headerLabel.text = [NSString stringWithFormat:@"    %@", self.mainService.keysArray[section]];
        headerLabel.font = [UIFont systemFontOfSize:14];
        headerLabel.lee_theme
        .LeeConfigBackgroundColor(@"baseHeaderView_background_color");
        return headerLabel;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.5;
}


-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
