//
//  AppConstant.h
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/4.
//  Copyright © 2016 Youdar. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h


// 生产环境
// 一般接口
//#define REQUEST_BASEURL @"http://59.110.162.106:8080"
//// 账号注册地址
//#define REQUEST_APIPATH [NSString stringWithFormat: @"/app_api/v1.0.0%@", [self requestUrlPath]]
//#define ACCOUNT_REGISTER_URL @"http://59.110.162.106:8001/eos_account_service/v1.0.0/register"


// 测试环境
// 一般接口
#define REQUEST_BASEURL @"http://39.106.118.225:8080"
// 路径: api_oc_personal || api_oc_blockchain

// 账号注册地址
#define REQUEST_APIPATH [NSString stringWithFormat: @"/app_api/v1.0.0%@", [self requestUrlPath]]
#define ACCOUNT_REGISTER_URL @"http://39.106.118.225:8080/v1.0.0/eos_account_service/register"


/**
 当前钱包
 */
#define CURRENT_WALLET [[[WalletTableManager walletTable] selectCurrentWallet] firstObject];
////////////////////////////////////////////////////////////////////////////////////
///////////////////////////Begin: Device Macro definition///////////////////////////
/**
 *  device width and height
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HEIGHT_PROPORTION SCREEN_HEIGHT / 568.0f
#define WIDTH_PROPORTION 375.0f / SCREEN_WIDTH
/**
 *  tabbar height
 */
#define TABBAR_HEIGHT 49.0f

/**
 *  statusBar height
 */
#define STATUSBAR_HEIGHT 20.0f

/**
 *  navitaionbar height
 */
#define NAVIGATIONBAR_HEIGHT 64.0f

/**
 *  statusbar height
 */
#define STATUSBAR_HEIGHT 20.0f

/**
 *  UIApplication object
 */
#define UIAPPLICATION [UIApplication sharedApplication]

/**
 *  window object
 */
#define WINDOW [[[UIApplication sharedApplication] delegate] window]

/**
 *  device system version
 */
#define DEVICE_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
///////////////////////////End: Device Macro definition///////////////////////////
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////
///////////////////////////Begin: Function Macro definition/////////////////////////
/**
 *  __weak self define
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**
 *  object is not nil and null
 */
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))

/**
 *  object is nil or null
 */
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:[NSNull class]]))

/**
 *  string is nil or null or empty
 */
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

/**
 *  Array is nil or null or empty
 */
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

/**
 *  validate string
 */
#define VALIDATE_STRING(str) (IsNilOrNull(str) ? @"" : str)

/**
 *  update string
 */
#define UPDATE_STRING(old, new) ((IsNilOrNull(new) || IsStrEmpty(new)) ? old : new)

/**
 *  validate NSNumber
 */
#define VALIDATE_NUMBER(number) (IsNilOrNull(number) ? @0 : number)

/**
 *  update NSNumber
 */
#define UPDATE_NUMBER(old, new) (IsNilOrNull(new) ? old : new)

/**
 *  validate NSArray
 */
#define VALIDATE_ARRAY(arr) (IsNilOrNull(arr) ? [NSArray array] : arr)

/**
 *  validate NSMutableArray
 */
#define VALIDATE_MUTABLEARRAY(arr) (IsNilOrNull(arr) ? [NSMutableArray array] :     [NSMutableArray arrayWithArray: arr])



/**
 *  update NSArray
 */
#define UPDATE_ARRAY(old, new) (IsNilOrNull(new) ? old : new)

/**
 *  update NSDate
 */
#define UPDATE_DATE(old, new) (IsNilOrNull(new) ? old : new)

/**
 *  validate bool
 */
#define VALIDATE_BOOL(value) ((value > 0) ? YES : NO)

/**
 *  Url transfer
 */
#define String_To_URL(str) [NSURL URLWithString: str]

/**
 *  nil turn to null
 */
#define Nil_TURNTO_Null(objc) (objc == nil ? [NSNull null] : objc)
///////////////////////////End: Function Macro definition/////////////////////////
//////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////
///////////////////////Begin: App Parameters Macro definition///////////////////////
/**
 *  The path of the local user information
 */
#define LOCAL_USER_ARCHIVE [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"LocalUser.archiver"]

/**
 *  Server token
 */
#define SERVER_TOKEN @"ServerToken"

/**
 *  devicetoken
 */
#define DEVICE_TOKEN @"DeviceToken"

/**
 *  default Image
 */
#define DEFAULT_LIST_IMAGE [UIImage imageNamed: @"ic_placeholder_list"]

#define DEFAULT_AVATAR_IMAGE [UIImage imageNamed: @"ic_placeholder_list"]

/**
 *  defaults pageSize
 */
#define DEFAULT_PAGESIZE 30

/**
 *  defaults button height
 */
#define DEFAULT_BUTTON_HEIGHT 50.0f

/**
 *  默认TableView的HeaderView的高度
 */
#define DEFAULT_TABLEHEADERVIEW_HEIGHT 230.0f

/**
 *  默认加载更多的起始点
 */
#define LOADMORE_FIREVALUE 8

/**
 *  默认线条高度
 */
#define DEFAULT_LINE_HEIGHT 0.5f

/**
 *  默认 tableVIew 图片的高度
 */
#define DEFAULT_TABLEVIEWICONIMAGEHEIGHT 125.0f

/**
 *  默认 攻略背景 图片的高度
 */
#define DEFAULT_STRATEGY_ICONIMAGEHEIGHT 210.0f

/**
 *  默认 TitleLabel 高度
 */
#define TITLELABEL_HEIGHT 46.5f

#define MARGIN_15 15.0f
#define MARGIN_20 20.0f

/**
 *  defaults reuseIdentifier
 */
#define CELL_REUSEIDENTIFIER @"ListCell"

#define CELL_REUSEUDENTIFIER1 @"ListCell1"



/**
 *  本地数据库
 */
#define LOCAL_DATABASE  @"LOCAL_DATABASE"


/**
 *  本地表
 */
#define WALLET_TABLE @"wallet_table"


///////////////////////Begin: App Parameters Macro definition///////////////////////
////////////////////////////////////////////////////////////////////////////////////
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define BACKGROUND_GRAY RGB(240, 240,240)
#define TEXTCOLOR_LIGHT_GRAY RGBA(0,0,0,0.3)
#define TEXTCOLOR_DARK_GRAY RGBA(0,0,0,0.7)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define RandomColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#endif /* AppConstant_h */
