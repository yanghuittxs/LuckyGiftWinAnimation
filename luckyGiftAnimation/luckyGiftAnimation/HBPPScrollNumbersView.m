//
//  HBPPScrollNumbersView.m
//  Live
//
//  Created by Young on 2019/7/15.
//  Copyright © 2019 HaiBo. All rights reserved.
//

#import "HBPPScrollNumbersView.h"

static NSInteger kNum = 20;
NSString * const kFontNamePFSC_Regular = @"PingFangSC-Regular";
NSString * const kFontNamePFSC_Medium = @"PingFangSC-Medium";
NSString * const kFontNamePFSC_Semibold = @"PingFangSC-Semibold";
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface HBPPScrollNumbersView ()

@property (nonatomic, assign, readwrite) BOOL   containsXView;/**< */
@property (nonatomic, strong) UILabel   *xLabel;/**< */
@property (nonatomic, assign) CGSize   itemSize;/**< */
@property (nonatomic, assign) NSInteger   recordNums;/**< */
@property (nonatomic, assign) NSInteger   currentNums;/**< */
@property (nonatomic, strong) NSMutableArray   *bitLayerArray;/**< */

@end

@implementation HBPPScrollNumbersView
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame withContainsXView:(BOOL)isContains {
    if (self = [super initWithFrame:frame]) {
        _containsXView = isContains;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _recordNums = 0;
    _currentNums = 0;
    _limitScrollNum = 1;
    _scaleDuration = 0.2;
    _scrollDuration = 0.2;
    _itemSize = CGSizeMake(18.0, 42.0);
    self.clipsToBounds = YES;
    if (self.containsXView) {
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = [NSString stringWithFormat:@"X"];
        numLabel.textColor = UIColorFromRGB(0xFFD600);
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont fontWithName:kFontNamePFSC_Regular size:30.0];
        [self addSubview:numLabel];
        self.xLabel = numLabel;
        self.xLabel.frame = CGRectMake(0, (self.frame.size.height - self.itemSize.height) / 2, _itemSize.width, _itemSize.height);
    }
    int itemCount = (int)floor((CGRectGetWidth(self.frame) - (self.containsXView ? _itemSize.width : 0)) / _itemSize.width);
    for (int i = 0; i < itemCount; i++) {
        CALayer *scrollLayer = [CALayer layer];
        scrollLayer.hidden = YES;
        scrollLayer.frame = CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height);
        [self.bitLayerArray addObject:scrollLayer];
        [self.layer addSublayer:scrollLayer];
        for (int j = 0 ; j < kNum; j++) {
            CALayer *itemlayer = [self createItemlLayerWithIndex:j text:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:abs(j % 10)]]];
            [scrollLayer addSublayer:itemlayer];
        }
    }
}

#pragma mark - Pravite Method
- (void)startAnimationWithNumbers:(NSInteger)nums {
    if (nums <= 0) {
        return;
    }
    self.currentNums = nums + self.recordNums;
//    NSMutableArray *numArray = [NSMutableArray array];
    NSString *numStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.currentNums]];
    for (int i = 0; i < numStr.length; i++) {
        CALayer *scrollLayer = self.bitLayerArray[i];
        scrollLayer.hidden = NO;
    }
//    if (self.bitLayerArray.count) {//不是第一次,累加
//        [self readyScrollAnimation];
//    }
//    else {
//        for (int i = 0; i < numArray.count; i++) {
//            CALayer *scrollLayer = [CALayer layer];
//            scrollLayer.frame = CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height);
//            [self.bitLayerArray addObject:scrollLayer];
//            [self.layer addSublayer:scrollLayer];
//            for (int j = 0 ; j < kNum; j++) {
//               CALayer *itemlayer = [self createItemlLayerWithIndex:j text:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:abs(j % 10)]]];
//                [scrollLayer addSublayer:itemlayer];
//            }
//        }
//    }
    [self readyScrollAnimation];
}

- (void)readyScrollAnimation {
    NSString *currentStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.currentNums]];
    NSString *recordStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.recordNums]];
    NSInteger newBit = currentStr.length - recordStr.length;
    if (self.recordNums) {
        if (newBit) {//位数增加
            for (int i = 0; i < currentStr.length; i++) {
                CALayer *scrollLayer = self.bitLayerArray[i];
                scrollLayer.hidden = NO;
//                [self.bitLayerArray insertObject:scrollLayer atIndex:i];
//                [self.layer addSublayer:scrollLayer];
//                scrollLayer.frame = CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height);
//                for (int j = 0 ; j < kNum; j++) {
//                    CALayer *itemlayer = [self createItemlLayerWithIndex:j text:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:abs(j % 10)]]];
//                    [scrollLayer addSublayer:itemlayer];
//                }
            }
//            for (NSInteger i = recordStr.length; i < self.bitLayerArray.count; i++) {
//                CALayer *scrollLayer = self.bitLayerArray[i];
//                scrollLayer.frame = CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height);
//                [self.layer addSublayer:scrollLayer];
//            }
//            [self setNeedsDisplay];
            for (int i = 0; i < newBit; i++) {
                recordStr = [recordStr stringByAppendingString:@"0"];
            }
        }
        if (self.currentNums - self.recordNums > self.limitScrollNum) {//缩放+滚动
            [UIView animateWithDuration:self.scaleDuration animations:^{
                self.transform = CGAffineTransformMakeScale(2.5, 2.5);
                self.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [self commitScrollAnimationWithZoreRecord:recordStr];
            }];
        }
        else {
            recordStr = [NSString stringWithFormat:@"%0*d", (int)currentStr.length, (int)self.recordNums];
            for (int i = 0; i < currentStr.length; i++) {
                CALayer *scrollLayer = self.bitLayerArray[i];
                CGRect sFrame = scrollLayer.frame;
                CGFloat offset = ([[currentStr substringWithRange:NSMakeRange(i, 1)] intValue] - [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue]) * _itemSize.height;
                CGRect eFrame = CGRectMake(sFrame.origin.x, sFrame.origin.y - offset, sFrame.size.width, sFrame.size.height);
                scrollLayer.frame = eFrame;
            }
            [UIView animateWithDuration:self.scaleDuration animations:^{
                self.transform = CGAffineTransformMakeScale(2.5, 2.5);
                self.transform = CGAffineTransformMakeScale(0.8, 0.8);
            } completion:^(BOOL finished) {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [self noticeAnimationComplete];
            }];
            self.recordNums = self.currentNums;
        }
//        [UIView animateWithDuration:self.scaleDuration animations:^{
//            self.transform = CGAffineTransformMakeScale(2.5, 2.5);
//            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        } completion:^(BOOL finished) {
//            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            [self commitScrollAnimationWithZoreRecord:recordStr];
//        }];
    }
    else {//第一次
        recordStr = [NSString stringWithFormat:@"%0*d", (int)currentStr.length, (int)self.recordNums];
        for (int i = 0; i < currentStr.length; i++) {
            CALayer *scrollLayer = self.bitLayerArray[i];
            CGRect sFrame = scrollLayer.frame;
            CGFloat offset = ([[currentStr substringWithRange:NSMakeRange(i, 1)] intValue] - [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue]) * _itemSize.height;
            CGRect eFrame = CGRectMake(sFrame.origin.x, sFrame.origin.y - offset, sFrame.size.width, sFrame.size.height);
            scrollLayer.frame = eFrame;
        }
        [UIView animateWithDuration:self.scaleDuration animations:^{
            self.transform = CGAffineTransformMakeScale(2.5, 2.5);
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self noticeAnimationComplete];
        }];
        self.recordNums = self.currentNums;
    }
    
//    if (newBit && self.recordNums) {
//        for (int i = 0; i < newBit; i++) {
//            CALayer *scrollLayer = [CALayer layer];
//            [self.bitLayerArray insertObject:scrollLayer atIndex:i];
//            [self.layer addSublayer:scrollLayer];
//            scrollLayer.frame = CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height);
//            for (int j = 0 ; j < kNum; j++) {
//                CALayer *itemlayer = [self createItemlLayerWithIndex:j text:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:abs(j % 10)]]];
//                [scrollLayer addSublayer:itemlayer];
//            }
//        }
//        for (NSInteger i = newBit; i < self.bitLayerArray.count; i++) {
//            CALayer *scrollLayer = self.bitLayerArray[i];
//            scrollLayer.frame = CGRectMake(i * _itemSize.width + (self.containsXView ? _itemSize.width : 0), 0, _itemSize.width, _itemSize.height);
//            [self.layer addSublayer:scrollLayer];
//        }
//        [self setNeedsDisplay];
//        recordStr = [NSString stringWithFormat:@"%0*d", (int)currentStr.length, (int)self.recordNums];
//    }
    //初始化完成
//    if (self.currentNums - self.recordNums > self.limitScrollNum) {//放大+滚动
//        if (self.recordNums) {
//            [UIView animateWithDuration:self.scaleDuration animations:^{
//                self.transform = CGAffineTransformMakeScale(1.0, 2.5);
//            } completion:^(BOOL finished) {
//                self.transform = CGAffineTransformIdentity;
//                [self commitScrollAnimation];
//            }];
//        }
//        else {//第一次
//            recordStr = [NSString stringWithFormat:@"%0*d", (int)currentStr.length, (int)self.recordNums];
//            for (int i = 0; i < self.bitLayerArray.count; i++) {
//                CALayer *scrollLayer = self.bitLayerArray[i];
//                CGPoint sPosition = scrollLayer.position;
//                CGFloat offset = ([[currentStr substringWithRange:NSMakeRange(i, 1)] intValue] - [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue]) * _itemSize.height;
//                CGPoint ePosition = CGPointMake(sPosition.x, sPosition.y - offset);
//                scrollLayer.position = ePosition;
//            }
//            [UIView animateWithDuration:self.scaleDuration animations:^{
//                self.transform = CGAffineTransformMakeScale(1.5, 2.5);
//            } completion:^(BOOL finished) {
//                self.transform = CGAffineTransformIdentity;
//            }];
//            self.recordNums = self.currentNums;
//            [self noticeAnimationComplete];
//        }
//    }
//    else {//放大
//        for (int i = 0; i < self.bitLayerArray.count; i++) {
//            CALayer *scrollLayer = self.bitLayerArray[i];
//            CGPoint sPosition = scrollLayer.position;
//            CGFloat offset = ([[currentStr substringWithRange:NSMakeRange(i, 1)] intValue] - [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue]) * _itemSize.height;
//            CGPoint ePosition = CGPointMake(sPosition.x, sPosition.y - offset);
//            scrollLayer.position = ePosition;
//        }
//        [UIView animateWithDuration:self.scaleDuration animations:^{
//            self.transform = CGAffineTransformMakeScale(1.5, 2.5);
//        } completion:^(BOOL finished) {
//            self.transform = CGAffineTransformIdentity;
//        }];
//        self.recordNums = self.currentNums;
//        [self noticeAnimationComplete];
//    }
}

- (void)commitScrollAnimationWithZoreRecord:(NSString *)Zrecord {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setCompletionBlock:^{
        [self noticeAnimationComplete];
    }];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    NSString *currentStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.currentNums]];
//    NSString *recordStr = [NSString stringWithFormat:@"%0*d", (int)currentStr.length, (int)self.recordNums];
    NSString *recordStr = Zrecord;
    for (int i = 0; i < currentStr.length; i++) {
        CALayer *scrollLayer = self.bitLayerArray[i];
        CGRect sFrame = scrollLayer.frame;
        int from = [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue];
        int to = [[currentStr substringWithRange:NSMakeRange(i, 1)] intValue];
        CGFloat offset = 0;
        if (from > to) {
            offset = from - to - 10;
        }
        else {
            offset = from - to;
        }
        offset = offset * _itemSize.height;
        CGRect eFrame = CGRectMake(sFrame.origin.x, sFrame.origin.y + offset, sFrame.size.width, sFrame.size.height);
//        scrollLayer.frame = eFrame;
        CABasicAnimation *pAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
        pAnimation.fromValue = [NSValue valueWithCGRect:sFrame];
        pAnimation.toValue = [NSValue valueWithCGRect:eFrame];
        pAnimation.duration = self.scrollDuration;
        pAnimation.fillMode = kCAFillModeForwards;
        pAnimation.removedOnCompletion = NO;
        [scrollLayer addAnimation:pAnimation forKey:nil];
    }
    
//    for (int i = 0; i < currentStr.length; i++) {
//        CALayer *scrollLayer = self.bitLayerArray[i];
//        CGPoint sPosition = scrollLayer.position;
//        int from = [[recordStr substringWithRange:NSMakeRange(i, 1)] intValue];
//        int to = [[currentStr substringWithRange:NSMakeRange(i, 1)] intValue];
//        CGFloat offset = 0;
//        if (from > to) {
//            offset = from - to - 10;
//        }
//        else {
//            offset = from - to;
//        }
//        NSLog(@"position-->%@,offset--->%f", NSStringFromCGPoint(sPosition), offset);
////        CGPoint ePosition = CGPointMake(sPosition.x, sPosition.y - offset * _itemSize.height);
//        CABasicAnimation *pAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
//        pAnimation.fromValue = [NSNumber numberWithFloat:sPosition.y];
//        pAnimation.toValue = [NSNumber numberWithFloat:sPosition.y + offset * _itemSize.height];
//        pAnimation.duration = self.scrollDuration;
//        pAnimation.fillMode = kCAFillModeForwards;
//        pAnimation.removedOnCompletion = NO;
//        [scrollLayer addAnimation:pAnimation forKey:nil];
//    }
    self.recordNums = self.currentNums;
    [CATransaction commit];
}

- (CALayer *)createItemlLayerWithIndex:(NSInteger)index text:(NSString *)text {
    CATextLayer *layer = [CATextLayer layer];
    layer.string = text;
    layer.frame = CGRectMake(0, index * _itemSize.height, _itemSize.width, _itemSize.height);
    layer.font = (__bridge CFTypeRef _Nullable)(kFontNamePFSC_Medium);
    layer.fontSize = 30.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = UIColorFromRGB(0xFFD600).CGColor;
    return layer;
}

- (void)noticeAnimationComplete {
    
    NSString *currnetS = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:self.recordNums]];
            for (int i = 0; i < currnetS.length; i++) {
                CALayer *scrollLayer = self.bitLayerArray[i];
                CGRect sFrame = scrollLayer.frame;
                if (sFrame.origin.y < -9 * self.itemSize.height) {
                    CGRect eFrame = CGRectMake(sFrame.origin.x, sFrame.origin.y + 10 * _itemSize.height, sFrame.size.width, sFrame.size.height);
                    scrollLayer.frame = eFrame;
                }
            }
    if (self.scrollAnimationComplete) {
        self.scrollAnimationComplete();
    }
}

#pragma mark - Setter And Getter

- (NSMutableArray *)bitLayerArray {
    if (!_bitLayerArray) {
        _bitLayerArray = [NSMutableArray array];
    }
    return _bitLayerArray;
}

@end
