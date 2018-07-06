//
//  AreaCodeService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/7/6.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "AreaCodeService.h"
#import "AreaCodeModel.h"


@interface AreaCodeService()

/**
 用来临时存放索引数组
 */
@property(nonatomic, strong) NSMutableArray *tempArr;

@end

@implementation AreaCodeService

- (NSMutableDictionary *)dataDictionary{
    if (!_dataDictionary) {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataDictionary;
}

- (NSMutableArray *)keysArray{
    if (!_keysArray) {
        _keysArray = [[NSMutableArray alloc] init];
    }
    return _keysArray;
}

- (NSMutableArray *)tempArr{
    if (!_tempArr) {
        _tempArr = [[NSMutableArray alloc] init];
    }
    return _tempArr;
}

- (void)buildDataSource:(CompleteBlock)complete{
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource: @"CountryAreaCode" ofType:@"json"];
    NSData * jsonData = [[NSData alloc] initWithContentsOfFile: jsonPath];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingMutableLeaves error:nil];
    [self handleDataWithResultArr:dataArray];
    complete(self, YES);
}

- (void)handleDataWithResultArr:(NSArray *)resultArray{
    // 获取 key 对应的数据源
    NSMutableArray *itemArray = [NSMutableArray array];
    
    for (NSDictionary *dic in resultArray) {
        AreaCodeModel *model = [AreaCodeModel mj_objectWithKeyValues:dic];
        // 生成索引数组
        NSString *firstLetter = [NSString firstCharactorWithString: VALIDATE_STRING(model.en) ];
        NSString *regex = @"[A-Z]";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject: firstLetter]) {
            // 是字母 A - Z
            if (![self.tempArr containsObject: firstLetter]) {
                [self.tempArr addObject:firstLetter];
            }
            itemArray = [self.dataDictionary objectForKey:firstLetter];
            if (IsNilOrNull(itemArray)) {
                itemArray = [NSMutableArray array];
            }
            [itemArray addObject:model];
            [self.dataDictionary setObject:itemArray forKey:firstLetter];
        }else {
            // 其他非字母 A - Z 开头的联系人
            if (![self.tempArr containsObject:@"#"]) {
                [self.tempArr addObject: @"#"];
            }
            itemArray = [self.dataDictionary objectForKey:@"#"];
            if (IsNilOrNull(itemArray)) {
                itemArray = [NSMutableArray array];
            }
            [itemArray addObject:model];
            [self.dataDictionary setObject:itemArray forKey:@"#"];
        }
        
    }
    // 对索引数组进行排序
    NSArray *sortArr = [self.tempArr sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedArr = [NSMutableArray arrayWithArray: sortArr];
    if ([sortedArr containsObject:@"#"]) {
        if (sortedArr.count > 0) {
            [sortedArr removeObjectAtIndex:0];
        }
        [sortedArr addObject:@"#"];
    }
    [self.keysArray addObjectsFromArray:sortedArr];
}



@end
