//
//  CDZPicker.h
//  CDZPickerViewDemo
//
//  Created by Nemocdz on 2016/11/18.
//  Copyright © 2016年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CDZCancelBlock)(void);
typedef void (^CDZConfirmBlock)(NSArray<NSString *> *strings, NSArray<NSNumber *> *indexs);

@interface CDZPickerComponentObject : NSObject

@property (nonatomic, strong, nullable) NSMutableArray<CDZPickerComponentObject *> *subArray;
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithText:(NSString *)text subArray:(NSMutableArray *)array;
- (instancetype)initWithText:(NSString *)text;
@end


@interface CDZPickerBuilder : NSObject
//是否显示背后遮罩，默认为YES
@property (nonatomic, assign, getter=isShowMask) BOOL showMask;
//确认按钮的文字，默认为“确认”
@property (nonatomic, copy, nullable) NSString *confirmText;
//取消按钮的文字，默认为“取消”
@property (nonatomic, copy, nullable) NSString *cancelText;
//确认文字的颜色，默认是蓝色
@property (nonatomic, strong, nullable) UIColor *confirmTextColor;
//取消文字的颜色，默认为蓝色
@property (nonatomic, strong, nullable) UIColor *cancelTextColor;
//选择器的背景颜色，默认为白色
@property (nonatomic, strong, nullable) UIColor *pickerColor;
//选择器的文字颜色，默认为黑色
@property (nonatomic, strong, nullable) UIColor *pickerTextColor;
//默认滚动的行数，默认为第1行
@property (nonatomic, assign) NSInteger defaultIndex;
//整个pickerView的高度，默认为248，包括44的按钮栏
@property (nonatomic, assign) CGFloat pickerHeight;
@end

@interface CDZPicker : UIView

/**
 单行数据
 
 @param view 所在view
 @param builder 配置
 @param strings 单个string数组
 @param confirmBlock 点击确认后
 @param cancelBlcok 点击取消后
 */

+ (void)showSinglePickerInView:(UIView *)view
                   withBuilder:(nullable CDZPickerBuilder *)builder
                       strings:(NSArray<NSString *> *)strings
                       confirm:(CDZConfirmBlock)confirmBlock
                        cancel:(CDZCancelBlock)cancelBlcok;



/**
 多行不联动数据
 
 @param view 所在view
 @param builder 配置
 @param arrays 二维数组，数组里string数组个数为行数，互相独立
 @param confirmBlock 点击确认后
 @param cancelBlcok 点击取消后
 */

+ (void)showMultiPickerInView:(UIView *)view
                  withBuilder:(nullable CDZPickerBuilder *)builder
                 stringArrays:(NSArray<NSArray <NSString*> *> *)arrays
                      confirm:(CDZConfirmBlock)confirmBlock
                       cancel:(CDZCancelBlock)cancelBlcok;

/**
 多行联动数据

 @param view 所在的view
 @param builder 配置
 @param components 传入componetobject数组，可嵌套
 @param confirmBlock 点击确认后
 @param cancelBlcok 点击取消后
 */
+ (void)showLinkagePickerInView:(UIView *)view
                    withBuilder:(nullable CDZPickerBuilder *)builder
                     components:(NSArray<CDZPickerComponentObject *> *)components
                        confirm:(CDZConfirmBlock)confirmBlock
                         cancel:(CDZCancelBlock)cancelBlcok;




@end

NS_ASSUME_NONNULL_END
