//
//  ViewController.m
//  luckyGiftAnimation
//
//  Created by Young on 2019/7/8.
//  Copyright © 2019 Young. All rights reserved.
//

#import "ViewController.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()
<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView   *bags;/**< */
@property (nonatomic, strong) NSMutableArray   *animationArray;/**< */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bags = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hongbao_bags"]];
    _bags.frame = CGRectMake(80, 200, 129, 168);
    [self.view addSubview:_bags];
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"点击开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    startBtn.frame  = CGRectMake((ScreenWidth - 120) / 2, ScreenHeight - 100, 120, 35.0);
    [startBtn addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

- (void)startAnimation:(UIButton *)sender {
    if (self.animationArray.count > 0) {
        //删除动画
        for (NSNumber *index in self.animationArray) {
            UIView * view = [self.view viewWithTag:index.integerValue];
            if (view.superview) {
                [view removeFromSuperview];
            }
        }
        [self.animationArray removeAllObjects];
    }
    for (int i = 0; i < 15; i++) {
        [self performSelector:@selector(createAnimationPath:) withObject:@(i) afterDelay:0.1];
    }
}

- (void)createAnimationPath:(NSNumber *)index {
    UIImageView *dou = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_coin_1"]];
    dou.frame = CGRectMake(0, 0, 25, 25);
    dou.center = self.bags.center;
    dou.tag = 3400 + index.integerValue;
    [self.view addSubview:dou];
    [self.animationArray addObject:@(dou.tag)];
    [self setupAnimationLayer:dou];
}

- (void)setupAnimationLayer:(UIView *)dou {
    CGFloat startx = dou.layer.position.x;
    CGFloat starty = dou.layer.position.y;
    NSInteger index = dou.tag - 3400;
    CGFloat controlX = 0;
    CGFloat controlY = 0;
    CGFloat endX = ScreenWidth + 20;
    CGFloat endY = starty + 250;
    switch (index) {
        case 0:
            controlX = startx - 300;
            controlY = starty - 80;
            break;
        case 1:
            controlX = startx - 360;
            controlY = starty - 100;
            break;
        case 2:
            controlX = startx - 300;
            controlY = starty - 150;
            break;
        case 3:
            controlX = startx - 380;
            controlY = starty - 500;
            break;
        case 4:
            controlX = startx - 380;
            controlY = starty - 700;
            break;
        case 5:
            controlX = startx - 280;
            controlY = starty - 500;
            break;
        case 6:
            controlX = startx - 200;
            controlY = starty - 500;
            break;
        case 7:
            controlX = startx - 100;
            controlY = starty - 400;
            break;
        case 8:
            controlX = startx - 130;
            controlY = starty - 280;
            break;
        case 9:
            controlX = startx - 130;
            controlY = starty - 280;
            break;
        case 10:
            controlX = startx - 0;
            controlY = starty - 280;
            break;
        case 11:
            controlX = startx + 80;
            controlY = starty - 180;
            break;
        case 12:
            controlX = startx + 200;
            controlY = starty - 190;
            break;
        case 13:
            controlX = startx + 200;
            controlY = starty - 190;
            break;
        case 14:
            controlX = startx + 200;
            controlY = starty ;
            break;
        default:
            break;
    }
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startx, starty);
    CGPathAddQuadCurveToPoint(path, NULL, controlX, controlY, endX, endY);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CFRelease(path);
    animation.duration = 0.8;
    animation.delegate = self;
    animation.repeatCount = 0;
    animation.fillMode = kCAFillModeForwards;
    [dou.layer addAnimation:animation forKey:[NSString stringWithFormat:@"luckyBean_%@", [NSNumber numberWithInteger:dou.tag]]];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && self.animationArray.count) {
        UIView *coinView = [self.view viewWithTag:[[self.animationArray firstObject] integerValue]];
        [coinView removeFromSuperview];
        [self.animationArray removeObjectAtIndex:0];
    }
}

-(NSMutableArray *)animationArray {
    if (!_animationArray) {
        _animationArray = [NSMutableArray array];
    }
    return _animationArray;
}

@end
