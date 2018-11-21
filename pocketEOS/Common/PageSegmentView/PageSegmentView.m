//
//  PageSegmentView.m
//  PageSegment
//
//  Created by Hunter on 12/08/2017.
//  Copyright © 2017 Hunter. All rights reserved.
//

#import "PageSegmentView.h"

@interface PageSegmentView ()<UIScrollViewDelegate>

@property (nonatomic, strong) BodyScrollView *bodyScrollView;

@property (nonatomic, strong) UIView         *bottomLine;
@property (nonatomic, strong) UIView         *selectedLine;

@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, strong) NSMutableArray *tabRedDots;  //按钮上的红点

@property (nonatomic, assign) NSUInteger     continueDraggingNumber;
@property (nonatomic, assign) NSUInteger     currentTabSelected;

@property (nonatomic, assign) CGFloat        startOffsetX;
@property (nonatomic, assign) CGFloat        selectedLineOffsetXBeforeMoving;
@property (nonatomic, assign) CGFloat        tabViewContentSizeWidth;
@property (nonatomic, assign) CGFloat        itemButtonX;

@property (nonatomic, assign) BOOL           isBuildUI;
@property (nonatomic, assign) BOOL           isUseDragging; //是否使用手拖动的，自动的就设置为NO
@property (nonatomic, assign) BOOL           isEndDecelerating;

@end


@implementation PageSegmentView

- (void)buildUI {
    _isBuildUI = NO;
    _isUseDragging = NO;
    _isEndDecelerating = YES;
    _startOffsetX = 0;
    _continueDraggingNumber = 0;

    [self.viewsArray removeAllObjects];
    [self.tabButtons removeAllObjects];
    
    NSUInteger number = [self.delegate numberOfPagers:self];

    for (int i = 0; i < number; i++) {
        //ScrollView部分
        UIViewController* vc = [self.delegate pagerViewOfPagers:self indexOfPagers:i];
        [self.viewsArray addObject:vc];
        [self.bodyScrollView addSubview:vc.view];

        //tab上按钮
        UIButton* itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton.titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:self.tabButtonFontSize]];
        [itemButton setTitle:vc.title forState:UIControlStateNormal];
        [itemButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [itemButton setTitleColor:HEXCOLOR(0x2A2A2A) forState:UIControlStateSelected];
        itemButton.font = [UIFont boldSystemFontOfSize:15];
        
        [itemButton addTarget:self action:@selector(onTabButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i + 1; // "tag = 0" 为父视图本身,所以tag+1
        itemButton.size = [self buttonTitleRealSize:itemButton];
        [itemButton setFrame:CGRectMake(self.itemButtonX, 0, itemButton.width, self.tabFrameHeight)];
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [self.tabButtons addObject:itemButton];
        [self.tabView addSubview:itemButton];

        // 记录itemButtonX
        if (i == 0) {
            _itemButtonX = self.tabMargin + itemButton.width + self.tabMargin;
        } else {
            _itemButtonX = CGRectGetMaxX(itemButton.frame) + self.tabMargin;
        }

        //tab上的红点
        UIView* aRedDot = [[UIView alloc] initWithFrame:CGRectMake(itemButton.width / 2 + [self buttonTitleRealSize:itemButton].width / 2 + 3, itemButton.height / 2 - [self buttonTitleRealSize:itemButton].height / 2, 8, 8)];
        aRedDot.backgroundColor = [UIColor redColor];
        aRedDot.layer.cornerRadius = aRedDot.width/2.0f;
        aRedDot.layer.masksToBounds = YES;
        aRedDot.hidden = YES;
        [self.tabRedDots addObject:aRedDot];
        [itemButton addSubview:aRedDot];

        // getTabViewContentSizeWidth
        if (i == number - 1) {
            self.tabViewContentSizeWidth = CGRectGetMaxX(itemButton.frame) + _tabMargin;

            // 当itemButton数量较少，强制设置其size，自动填充
            if (self.tabViewContentSizeWidth < self.tabView.width) {
                for (int t = 0; t < _tabButtons.count; t++) {
                    UIButton *btn = _tabButtons[t];
                    [btn setFrame:CGRectMake((_tabView.width / _tabButtons.count) * t,
                                             0,
                                             _tabView.width / _tabButtons.count,
                                             self.tabFrameHeight)];


                    UIView *redDot = _tabRedDots[t];
                    [redDot setFrame:CGRectMake(btn.width / 2 + [self buttonTitleRealSize:btn].width / 2 + 3, btn.height / 2 - [self buttonTitleRealSize:btn].height / 2, 8, 8)];
                }

                self.tabViewContentSizeWidth = _tabView.width;
            }
        }
    }
    
    
    // add leftbtn
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn addTarget:self action:@selector(leftBtnDidClick:) forControlEvents:(UIControlEventTouchUpInside)];
    leftBtn.lee_theme.LeeAddButtonImage(SOCIAL_MODE, [UIImage imageNamed:@"back"], UIControlStateNormal).LeeAddButtonImage(BLACKBOX_MODE, [UIImage imageNamed:@"back_white"], UIControlStateNormal);
    leftBtn.frame = CGRectMake(5, 5, 30, 30);
    self.leftBtn = leftBtn;
    [self addSubview:self.leftBtn];

    // add rightBtn
    BaseView *rightView = [[BaseView alloc] init];
    rightView.frame = CGRectMake(SCREEN_WIDTH-5-60, 5, 60, 30);
    

    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"rescue-icon"];

    BaseLabel *label = [[BaseLabel alloc] init];
    label.text = NSLocalizedString(@"账号救援", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];

    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(pageSegmentRightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setBackgroundColor:[UIColor clearColor]];
    
    self.rightView = rightView;
    [self addSubview:self.rightView];
    
    
    [self.rightView addSubview:img];
    img.sd_layout.centerXEqualToView(self.rightView).topSpaceToView(self.rightView, 5).widthIs(12).heightIs(12);

    [self.rightView addSubview:label];
    label.sd_layout.centerXEqualToView(self.rightView).topSpaceToView(img, 4).widthIs(60).heightIs(10);

    [self.rightView addSubview:btn];
    btn.frame = self.rightView.bounds;
    
    
    //tabView
    self.tabView.lee_theme.LeeConfigBackgroundColor(@"baseTopView_background_color");
    

    //bottomLine
    self.bottomLine.backgroundColor = [UIColor redColor];

    _isBuildUI = YES;

    //起始选择一个tab,默认index = 0
    [self selectTabWithIndex:0 animate:NO];

    [self setNeedsLayout];
}

- (void)leftBtnDidClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageSegmentleftBtnDidClick)]) {
        [self.delegate pageSegmentleftBtnDidClick];
    }
}

- (void)pageSegmentRightBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageSegmentRightBtnDidClick)]) {
        [self.delegate pageSegmentRightBtnDidClick];
    }
}


- (CGSize)buttonTitleRealSize:(UIButton *)button {
    CGSize size = CGSizeZero;
    size = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    return size;
}

- (CGFloat)selectedLineWidth:(UIButton *)button {
    if (self.selectedLineWidth) {
        return _selectedLineWidth;
    }
    if (self.tabViewContentSizeWidth == self.tabView.width) {
        return _tabView.width / _tabButtons.count;
    }
    return [self buttonTitleRealSize:button].width;
}

- (void)layoutSubviews {
    if (_isBuildUI) {
        self.bodyScrollView.contentSize = CGSizeMake(self.width * [self.viewsArray count], self.tabFrameHeight);
        _tabView.contentSize = CGSizeMake(_tabViewContentSizeWidth, self.tabFrameHeight);
        for (int i = 0; i < [self.viewsArray count]; i++) {
            UIViewController* vc = self.viewsArray[i];
            vc.view.frame = CGRectMake(self.bodyScrollView.width * i, self.tabFrameHeight, self.bodyScrollView.width, self.bodyScrollView.height - self.tabFrameHeight);
        }
    }
}


#pragma mark - Tab
- (void)onTabButtonSelected:(UIButton *)button {
    [self selectTabWithIndex:button.tag - 1 animate:YES];
}

- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    UIButton *preButton = self.tabButtons[self.currentTabSelected];
    preButton.selected = NO;
    UIButton *currentButton = self.tabButtons[index];
    currentButton.selected = YES;
    _currentTabSelected = index;

    void(^moveSelectedLine)(void) = ^(void) {
        self.selectedLine.size = CGSizeMake([self selectedLineWidth:currentButton], self.selectedLineHeight);
        self.selectedLine.center = CGPointMake(currentButton.center.x, self.selectedLine.center.y);
        self.selectedLineOffsetXBeforeMoving = self.selectedLine.origin.x;
    };

    //移动select line
    if (isAnimate) {
        [UIView animateWithDuration:0.3 animations:^{
            moveSelectedLine();
        }];
    } else {
        moveSelectedLine();
    }

    [self updaTetabViewContentOffset];

    [self switchWithIndex:index animate:isAnimate];

    if ([self.delegate respondsToSelector:@selector(whenSelectOnPager:)]) {
        [self.delegate whenSelectOnPager:index];
    }

    [self hideRedDotWithIndex:index];
}

/*!
 * @brief Selected Line跟随移动
 */
- (void)moveSelectedLineByScrollWithOffsetX:(CGFloat)movingOffsetX {

    CGFloat selectedLineMaxMovedFloat = 50.0;            // 线移动最大距离
    CGFloat selectedLineMovedFloat = 0.0;                // 线移动的距离

    // 第一步：求出线移动最大距离
    typedef enum : NSUInteger {
        Left,
        Right
    } MovingDirection;
    MovingDirection direction = movingOffsetX > 0 ? Right : Left; // 移动方向
    NSUInteger targetBarItemIndex;
    if (direction == Right) {
        targetBarItemIndex = _currentTabSelected + 1;
    } else {
        movingOffsetX = -movingOffsetX;
        targetBarItemIndex = _currentTabSelected - 1;
    }

    if (targetBarItemIndex < 0 || targetBarItemIndex > _tabButtons.count) {
        return;
    }
    UIButton *currentSelectedBarItemBtn = _tabButtons[_currentTabSelected];
    UIButton *targetBarItemBtn = _tabButtons[targetBarItemIndex];
    selectedLineMaxMovedFloat = targetBarItemBtn.centerX - currentSelectedBarItemBtn.centerX;

    // 第二步：求出线移动的距离
    selectedLineMovedFloat = (movingOffsetX / _bodyScrollView.width) * selectedLineMaxMovedFloat;

    // 第三步: 改变线的CenterX
    CGFloat selectedLineOriginCenterX = self.selectedLineOffsetXBeforeMoving + self.selectedLine.width / 2;
    [self.selectedLine setCenterX:selectedLineOriginCenterX + selectedLineMovedFloat];
}

- (void)updaTetabViewContentOffset{
    CGFloat leftmost = _tabView.centerX; // 最左边
    CGFloat rightmost = _tabView.contentSize.width - _tabView.centerX; // 最右边
    CGFloat tabViewContentOffsetX;

    if (_selectedLine.centerX < leftmost || _selectedLine.centerX == leftmost) {
        tabViewContentOffsetX = 0;
    } else if (_selectedLine.centerX > rightmost || _selectedLine.centerX == rightmost) {
        tabViewContentOffsetX = _tabView.contentSize.width - _tabView.width;
    } else {
        tabViewContentOffsetX = _selectedLine.centerX - _tabView.centerX;
    }

    [UIView animateWithDuration:0.3 animations:^{
        _tabView.contentOffset = CGPointMake(tabViewContentOffsetX, 0);
    }];
}

/*!
 * @brief 红点
 */
- (void)showRedDotWithIndex:(NSUInteger)index {
    UIView* redDot = self.tabRedDots[index];
    redDot.hidden = NO;
}

- (void)hideRedDotWithIndex:(NSUInteger)index {
    UIView* redDot = self.tabRedDots[index];
    redDot.hidden = YES;
}


#pragma mark - 获取Bundel资源图片
/**
 获取Bundel资源图片

 @param imgName 图片名称
 @param bundleName bundle名字
 @return Img对象
 */
- (UIImage *)imageNamed:(NSString *)imgName BundleNamed:(NSString *)bundleName{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:self.class];
    NSURL *bundleURL = [[frameworkBundle resourceURL] URLByAppendingPathComponent:bundleName];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    UIImage *image = [UIImage imageNamed:imgName inBundle:resourceBundle compatibleWithTraitCollection:nil];
    return image;
}


#pragma mark - BodyScrollView
- (void)switchWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    [self.bodyScrollView setContentOffset:CGPointMake(index*self.width, 0) animated:isAnimate];
    _isUseDragging = NO;
}


#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        _continueDraggingNumber += 1;
        if (_isEndDecelerating) {
            _startOffsetX = scrollView.contentOffset.x;
        }
        _isUseDragging = YES;
        _isEndDecelerating = NO;
    }
}

/*!
 * @brief 对拖动过程中的处理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        CGFloat movingOffsetX = scrollView.contentOffset.x - _startOffsetX;
        if (_isUseDragging) {
            //tab处理事件待完成
             [self moveSelectedLineByScrollWithOffsetX:movingOffsetX];
        }
    }
}

/*!
 * @brief 手释放后pager归位后的处理
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
        _isUseDragging = YES;
        _isEndDecelerating = YES;
        _continueDraggingNumber = 0;
    }
}

/*!
 * @brief 自动停止
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        //tab处理事件待完成
        [self selectTabWithIndex:(int)scrollView.contentOffset.x/self.bounds.size.width animate:YES];
    }
}


#pragma mark - Setter/Getter
/*!
 * @brief 滑动pager主体
 */
- (BodyScrollView*)bodyScrollView {
    if (!_bodyScrollView) {
        self.bodyScrollView = [[BodyScrollView alloc] initWithFrame:CGRectMake(0,_tabFrameHeight,self.width,self.height - _tabFrameHeight)];
        _bodyScrollView.delegate = self;
        _bodyScrollView.pagingEnabled = YES;
        _bodyScrollView.userInteractionEnabled = YES;
        _bodyScrollView.bounces = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight
        | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bodyScrollView];
    }
    return _bodyScrollView;
}

/*!
 * @brief 头部tab
 */
- (UIView *)tabView {
    if (!_tabView) {
        self.tabView = [[UIScrollView alloc]initWithFrame:CGRectMake(100,0,self.tabViewWidth-100*2,_tabFrameHeight)];
        _tabView.delegate = self;
        _tabView.userInteractionEnabled = YES;
        _tabView.showsHorizontalScrollIndicator = NO;
        _tabView.autoresizingMask = UIViewAutoresizingFlexibleHeight
        | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_tabView];
    }
    return _tabView;
}

- (UIView *)selectedLine {
    if (!_selectedLine) {
        self.selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0,self.tabView.height - 2,0,self.selectedLineHeight)];
        _selectedLine.backgroundColor = HEXCOLOR(0x4D7BFE);
        [self.tabView addSubview:_selectedLine];
    }
    return _selectedLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,self.tabView.height-0.5,self.width,0.5)];
//        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (CGFloat)selectedLineHeight{
    if (!_selectedLineHeight) {
        self.selectedLineHeight = 2;
    }
    return _selectedLineHeight;
}

- (CGFloat)tabFrameHeight {
    if (!_tabFrameHeight) {
        self.tabFrameHeight = 40;
    }
    return _tabFrameHeight;
}

- (CGFloat)tabMargin {
    if (!_tabMargin) {
        self.tabMargin = 20;
    }
    return _tabMargin;
}

- (CGFloat)itemButtonX{
    if (!_itemButtonX) {
        self.itemButtonX = self.tabMargin;
    }
    return _itemButtonX;
}

- (CGFloat)tabButtonFontSize {
    if (!_tabButtonFontSize) {
        self.tabButtonFontSize = 14;
    }
    return _tabButtonFontSize;
}

- (CGFloat)selectedLineOffsetXBeforeMoving {
    if (!_selectedLineOffsetXBeforeMoving) {
        self.selectedLineOffsetXBeforeMoving = 0;
    }
    return _selectedLineOffsetXBeforeMoving;
}

- (NSUInteger)currentTabSelected {
    if (!_currentTabSelected) {
        self.currentTabSelected = 0;
    }
    return _currentTabSelected;
}

- (UIColor *)tabBackgroundColor {
    if (!_tabBackgroundColor) {
        self.tabBackgroundColor = [UIColor whiteColor];
    }
    return _tabBackgroundColor;
}

- (UIColor *)tabButtonTitleColorForNormal {
    if (!_tabButtonTitleColorForNormal) {
        self.tabButtonTitleColorForNormal = [UIColor colorWithRed:142/255.0
                                                            green:142/255.0
                                                             blue:142/255.0
                                                            alpha:1];
    }
    return _tabButtonTitleColorForNormal;
}

- (UIColor *)tabButtonTitleColorForSelected {
    if (!_tabButtonTitleColorForSelected) {
        self.tabButtonTitleColorForSelected = HEXCOLOR(0x4E7CFD);
    }
    return _tabButtonTitleColorForSelected;
}

- (NSMutableArray *)tabButtons {
    if (!_tabButtons) {
        self.tabButtons = [[NSMutableArray alloc] init];
    }
    return _tabButtons;
}

- (NSMutableArray *)tabRedDots {
    if (!_tabRedDots) {
        self.tabRedDots = [[NSMutableArray alloc] init];
    }
    return _tabRedDots;
}

- (NSMutableArray *)viewsArray {
    if (!_viewsArray) {
        self.viewsArray = [[NSMutableArray alloc] init];
    }
    return _viewsArray;
}



@end
