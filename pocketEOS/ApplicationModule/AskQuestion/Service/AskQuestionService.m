//
//  AskQuestionService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/11.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "AskQuestionService.h"
#import "AskQuestionModel.h"


@interface AskQuestionService()
@end

@implementation AskQuestionService

- (NSMutableArray *)optionsModelArr{
    if (!_optionsModelArr) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"A.", @"B.", @"C.", @"D.", @"E.", @"F.",  nil];
        self.optionsModelArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            AskQuestionModel *model = [[AskQuestionModel alloc] init];
            model.optionStr = arr[i];
            [self.optionsModelArr addObject:model];
        }
    }
    return _optionsModelArr;
}
- (void)buildDataSource:(CompleteBlock)complete{
    NSArray *arr = [self.optionsModelArr subarrayWithRange:(NSMakeRange(0, 2))];
    for (int i = 0; i < arr.count; i++) {
        AskQuestionModel *model = [[AskQuestionModel alloc] init];
        model = arr[i];
        [self.dataSourceArray addObject:model];
    }
    complete(self, YES);
}

@end
