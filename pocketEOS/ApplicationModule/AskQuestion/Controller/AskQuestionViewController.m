//
//  AskQuestionViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/10.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "NavigationView.h"
#import "AskQuestionHeaderView.h"
#import "AskQuestionService.h"
#import "AddOptionTableViewCell.h"
#import "AskQuestionTableViewCell.h"
#import "AskQuestionModel.h"
#import "AskQuestionService.h"
#import "TransferService.h"
#import "PGDatePickManager.h"
#import "TransactionResult.h"
#import "LoginPasswordView.h"
#import "AskQuestionTipView.h"
#import "AskQuestion_abi_to_json_request.h"
#import "ApproveAbi_json_to_bin_request.h"

@interface AskQuestionViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate , UITableViewDataSource, NavigationViewDelegate, AskQuestionTableViewCellDelegate, AskQuestionHeaderViewDelegate, PGDatePickerDelegate , TransferServiceDelegate, LoginPasswordViewDelegate, AskQuestionTipViewDelegate>
@property(nonatomic, strong) NavigationView *navView;
@property(nonatomic, strong) AskQuestionHeaderView *headerView;
@property(nonatomic, strong) AskQuestionService *mainService;
@property(nonatomic , strong) AskQuestion_abi_to_json_request *askQuestion_abi_to_json_request;
@property(nonatomic , strong) ApproveAbi_json_to_bin_request *approveAbi_json_to_bin_request;
@property(nonatomic, copy) NSString *binargs;
@property(nonatomic, strong) TransferService *transferService;
@property(nonatomic, strong) NSNumber *endTimetamp; // timechooser
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) AskQuestionTipView *askQuestionTipView;
@end

@implementation AskQuestionViewController

- (NavigationView *)navView{
    if (!_navView) {
        _navView = [NavigationView navigationViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT) LeftBtnImgName:@"back" title:@"我来提问" rightBtnTitleName:@"提交" delegate:self];
        _navView.leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
        _navView.rightBtn.lee_theme.LeeAddButtonTitleColor(SOCIAL_MODE, HEXCOLOR(0x2A2A2A), UIControlStateNormal).LeeAddButtonTitleColor(BLACKBOX_MODE, HEX_RGB_Alpha(0xFFFFFF, 0.6), UIControlStateNormal);
    }
    return _navView;
}
- (AskQuestionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"AskQuestionHeaderView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 243);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (AskQuestionService *)mainService{
    if (!_mainService) {
        _mainService = [[AskQuestionService alloc] init];
    }
    return _mainService;
}
- (AskQuestion_abi_to_json_request *)askQuestion_abi_to_json_request{
    if (!_askQuestion_abi_to_json_request) {
        _askQuestion_abi_to_json_request = [[AskQuestion_abi_to_json_request alloc] init];
    }
    return _askQuestion_abi_to_json_request;
}
- (ApproveAbi_json_to_bin_request *)approveAbi_json_to_bin_request{
    if (!_approveAbi_json_to_bin_request) {
        _approveAbi_json_to_bin_request = [[ApproveAbi_json_to_bin_request alloc] init];
    }
    return _approveAbi_json_to_bin_request;
}

- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}
- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}
- (AskQuestionTipView *)askQuestionTipView{
    if (!_askQuestionTipView) {
        _askQuestionTipView = [[[NSBundle mainBundle] loadNibNamed:@"AskQuestionTipView" owner:nil options:nil] firstObject];
        _askQuestionTipView.frame = self.view.bounds;
        _askQuestionTipView.delegate = self;
    }
    return _askQuestionTipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView setTableHeaderView:self.headerView];
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    
    [self.mainService buildDataSource:^(id service, BOOL isSuccess) {
        [self.mainTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.mainService.dataSourceArray.count) {
        AddOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEUDENTIFIER1];
        if (!cell) {
            cell = [[AddOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSEUDENTIFIER1];
        }
        return cell;
    }else{
        
        AskQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSEIDENTIFIER];
        if (!cell) {
            cell = [[AskQuestionTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_REUSEIDENTIFIER];
        }
        
        cell.delegate = self;
        if (indexPath.row == 0 || indexPath.row == 1) {
            cell.deleteBtn.hidden = YES;
        }else{
            cell.deleteBtn.hidden = NO;
        }
        AskQuestionModel *model = self.mainService.dataSourceArray[indexPath.row];
        cell.model = model;
        return cell;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainService.dataSourceArray.count + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.mainService.dataSourceArray.count ) {
        // 添加选项 cell
        if (self.mainService.dataSourceArray.count == 6) {
            [TOASTVIEW showWithText:@"最多添加六个选项"];
        }else{
            // 当前的 count
            NSUInteger count = self.mainService.dataSourceArray.count ;
            [self.mainService.dataSourceArray addObject: self.mainService.optionsModelArr[count]];
            [self.mainTableView beginUpdates];
            [self.mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            [self.mainTableView endUpdates];
        }
    }else{
        NSLog(@"%@", indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//AskQuestionTableViewCellDelegate
- (void)deleteCurrentRowBtnDidClick:(AskQuestionTableViewCell *)sender{
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:sender];
    [self.mainService.dataSourceArray removeObjectAtIndex: indexPath.row];
    [self.mainTableView beginUpdates];
    [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    [self.mainTableView endUpdates];
}

//NavigationViewDelegate
-(void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnDidClick{
    NSMutableArray *answerArr = [NSMutableArray array];
    for (int i = 0 ; i < 2 ; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        AskQuestionTableViewCell *cell = (AskQuestionTableViewCell *)[self.mainTableView cellForRowAtIndexPath: index];
        NSString *answerStr = cell.editTextView.text;
        [answerArr addObject:answerStr];
    }

    if (IsStrEmpty(self.headerView.amountTF.text) || IsStrEmpty(self.headerView.chooseTimeLabel.text) || IsStrEmpty(self.headerView.titleTV.text) || IsStrEmpty(self.headerView.contentTV.text) || IsStrEmpty(self.headerView.chooseTimeLabel.text) || IsStrEmpty(answerArr[0]) ||
        IsStrEmpty(answerArr[1])) {
        [TOASTVIEW showWithText:@"问题没有编辑完整, 请继续编辑!"];
        return;
    }
    [self.view addSubview:self.askQuestionTipView];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"发布此问题将消费您 %@ OCT ", self.headerView.amountTF.text]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:HEXCOLOR(0x2A2A2A)
                       range:NSMakeRange(0, 9)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:HEXCOLOR(0xB51515)
                       range:NSMakeRange(10, self.headerView.amountTF.text.length + 2)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:HEXCOLOR(0x2A2A2A)
                       range:NSMakeRange(9+self.headerView.amountTF.text.length + 2, 3)];
    self.askQuestionTipView.titleLabel.attributedText = attrString;
}

// AskQuestionTipViewDelegate
- (void)askQuestionTipViewCancleBtnDidClick:(UIButton *)sender{
    [self.askQuestionTipView removeFromSuperview];
}

- (void)askQuestionTipViewConfirmBtnDidClick:(UIButton *)sender{
    if (self.loginPasswordView) {
        self.loginPasswordView.inputPasswordTF.text = nil;
    }
    [self.askQuestionTipView removeFromSuperview];
    [self.view addSubview:self.loginPasswordView];
}


// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self.loginPasswordView removeFromSuperview];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![NSString validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:@"密码输入错误!"];
        return;
    }
    
    // 1.押币 2.提问
    [self approve];
}

// 押币
- (void)approve{
    [SVProgressHUD show];
    self.approveAbi_json_to_bin_request.action = @"approve";
    self.approveAbi_json_to_bin_request.code = @"octoneos";
    self.approveAbi_json_to_bin_request.owner = self.choosedAccountName;
    self.approveAbi_json_to_bin_request.spender = @"ocaskans";
    self.approveAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%.4f OCT", self.headerView.amountTF.text.doubleValue];
    WS(weakSelf);
    [self.approveAbi_json_to_bin_request postOuterDataSuccess:^(id DAO, id data) {
        #pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
        weakSelf.transferService.available_keys = @[accountInfo.account_owner_public_key , accountInfo.account_active_public_key];
        weakSelf.transferService.action = @"approve";
        weakSelf.transferService.sender = self.choosedAccountName;
        weakSelf.transferService.code = @"octoneos";
        #pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeApprove;
         weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}

// 提问
- (void)askQuestion{
    
    NSDictionary *asktitleDic = @{
                                  @"content" : self.headerView.contentTV.text,
                                  @"title" : self.headerView.titleTV.text,
                                  };
    NSString *escapeCharacterAsktitle = [asktitleDic mj_JSONString];
    NSMutableDictionary *optionanswersDic = [NSMutableDictionary dictionary];
    NSMutableArray *answersKeyArr = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F",  nil];
    
    int i ;
    for ( i = 0 ; i < self.mainService.dataSourceArray.count ; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        AskQuestionTableViewCell *cell = (AskQuestionTableViewCell *)[self.mainTableView cellForRowAtIndexPath: index];
        [optionanswersDic setObject:cell.editTextView.text forKey:answersKeyArr[i]];
    }
    
    NSMutableString *json = [NSMutableString stringWithFormat:@"{}"];
    NSString *insertStr;
    for (int i = 0 ; i < optionanswersDic.allKeys.count; i++) {
        NSString *key = answersKeyArr[i];
        insertStr = [NSString stringWithFormat:@"\"%@\":\"%@\",",  key , [optionanswersDic objectForKey:key]];
        if (i == optionanswersDic.allKeys.count - 1) {
            insertStr = [NSString stringWithFormat:@"\"%@\":\"%@\"",  key , [optionanswersDic objectForKey:key]];
        }
        [json insertString:insertStr atIndex: json.length - 1];
    }
    
    self.askQuestion_abi_to_json_request.code = @"ocaskans";
    self.askQuestion_abi_to_json_request.action = @"ask";
    self.askQuestion_abi_to_json_request.from = self.choosedAccountName;
    self.askQuestion_abi_to_json_request.quantity = [NSString stringWithFormat:@"%.4f OCT", self.headerView.amountTF.text.doubleValue];
    self.askQuestion_abi_to_json_request.endtime = self.endTimetamp;
    self.askQuestion_abi_to_json_request.optionanswerscnt = @(i);
    self.askQuestion_abi_to_json_request.asktitle = escapeCharacterAsktitle;
    self.askQuestion_abi_to_json_request.optionanswers = json;
    WS(weakSelf);
    [self.askQuestion_abi_to_json_request postOuterDataSuccess:^(id DAO, id data) {
        #pragma mark -- [@"data"]
        NSLog(@"askQuestion_abi_to_json_request_success: --binargs: %@",data[@"data"][@"binargs"] );
        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.choosedAccountName];
        weakSelf.transferService.available_keys = @[accountInfo.account_owner_public_key , accountInfo.account_active_public_key];
        weakSelf.transferService.action = @"ask";
        weakSelf.transferService.sender = weakSelf.choosedAccountName;
        weakSelf.transferService.code = @"ocaskans";
        #pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeAskQustion;
        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
        [weakSelf.transferService pushTransaction];
        [weakSelf.loginPasswordView removeFromSuperview];
        weakSelf.loginPasswordView = nil;
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}


//transferserviceDelegate
extern NSString *AskQuestionDidSuccessNotification;
-(void)askQuestionDidFinish:(TransactionResult *)result{
//    if ([result.code isEqualToNumber:@0 ]) {
        [TOASTVIEW showWithText:@"提问成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:AskQuestionDidSuccessNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [TOASTVIEW showWithText: result.message];
//    }
}

-(void)approveDidFinish:(TransactionResult *)result{
    if ([result.code isEqualToNumber:@0 ]) {
        [self askQuestion];
    }else{
        [TOASTVIEW showWithText: result.message];
    }
}

//AskQuestionHeaderViewDelegate
-(void)chooseTimeBtnDidClick:(UIButton *)sender{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePickManager.isShadeBackgroud = true;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinuteSecond;
    datePicker.minimumDate = [NSDate date];
    datePicker.maximumDate = [NSDate setYear:2100 month:12 day:31 hour:23 minute:59 second:59];
    // ui
     datePickManager.headerViewBackgroundColor = RGB(245, 245, 245);
    datePicker.lineBackgroundColor = HEXCOLOR(0xEEEEEE);
    datePicker.textColorOfSelectedRow = HEXCOLOR(0x2B2B2B);
     datePicker.textColorOfOtherRow = HEXCOLOR(0xDDDDDD);
    datePickManager.cancelButtonTextColor = HEXCOLOR(0xB0B0B0);
    datePickManager.cancelButtonText = @"取消";
    datePickManager.confirmButtonTextColor = HEXCOLOR(0xB0B0B0);
    datePickManager.confirmButtonText = @"确定";
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * date = [calendar dateFromComponents:dateComponents];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.headerView.chooseTimeLabel.text = [dateFormatter stringFromDate: date];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    self.endTimetamp = [NSNumber numberWithInteger:(int)timeStamp];
}



@end
