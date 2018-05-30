//
//  NSDictionary+ExFoundation.m
//  Giivv
//
//  Created by Xiong, Zijun on 4/25/16.
//  Copyright © 2016 Youdar . All rights reserved.
//

#import "NSDictionary+ExFoundation.h"

@implementation NSDictionary (ExFoundation)
#pragma mark - clear object whit value is empty
- (NSDictionary *)clearEmptyObject{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithDictionary: self];
    for(id key in [newDictionary allKeys]){
        id value = [newDictionary objectForKey: key];
        if([value isKindOfClass: [NSNull class]]){
            [newDictionary removeObjectForKey: key];
        }
        if([value isKindOfClass: [NSString class]]){
            if(IsStrEmpty(value)){
                [newDictionary removeObjectForKey: key];
            }
        }
        if([value isKindOfClass: [NSArray class]] || [value isKindOfClass: [NSMutableArray class]]){
            if([value count] == 0){
                [newDictionary removeObjectForKey: key];
            }
        }
        if([value isKindOfClass: [NSSet class]] || [value isKindOfClass: [NSMutableSet class]]){
            if([value count] == 0){
                [newDictionary removeObjectForKey: key];
            }
        }
    }
    return newDictionary;
}
@end