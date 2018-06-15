//
//  OptionModel.h
//  pocketEOS
//
//  Created by oraclechain on 2018/6/9.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject
@property(nonatomic, strong) NSString *optionID;
@property(nonatomic, strong) NSString *optionName;
@property(nonatomic, strong) NSString *optionNormalizedName;
@property(nonatomic, strong) NSString *optionNormalIcon;
@property(nonatomic, strong) NSString *optionSelectedIcon;
@property(nonatomic, assign) BOOL isSelected;
@property (nonatomic , strong) NSString *detail;
@property (nonatomic , assign) BOOL hasImage;
@end
