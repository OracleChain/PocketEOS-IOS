//
//  ApplicationHeaderViewModel.m
//  pocketEOS
//
//  Created by oraclechain on 2018/6/4.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ApplicationHeaderViewModel.h"

@implementation ApplicationHeaderViewModel
- (NSMutableArray *)top4DataArray{
    if (!_top4DataArray) {
        _top4DataArray = [[NSMutableArray alloc] init];
    }
    return _top4DataArray;
}
- (NSMutableArray *)starDataArray{
    if (!_starDataArray) {
        _starDataArray = [[NSMutableArray alloc] init];
    }
    return _starDataArray;
}

@end
