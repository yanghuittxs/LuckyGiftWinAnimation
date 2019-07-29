//
//  ViewController.m
//  LayerLine
//
//  Created by Young on 2019/7/20.
//  Copyright © 2019 Young. All rights reserved.
//

#import "ViewController.h"
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)




@interface ViewController ()
@property (nonatomic, strong) UIView   *startPoint;/**< */
@property (nonatomic, strong) NSMutableArray   *lineLayerArray;/**< */
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *startPoint = [[UIView alloc] init];
    startPoint.frame = CGRectMake(80, 200, 129, 168);
    startPoint.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:startPoint];
    self.startPoint = startPoint;
    _lineLayerArray = [NSMutableArray array];
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"点击开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    startBtn.frame  = CGRectMake((ScreenWidth - 120) / 2, ScreenHeight - 80, 120, 35.0);
    [startBtn addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

- (void)startAnimation:(UIButton *)sender {
    [_lineLayerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CGFloat startx = _startPoint.layer.position.x;
    CGFloat starty = _startPoint.layer.position.y;
    CGFloat endX = ScreenWidth + 20;
    CGFloat endY = starty + 250;
    
    CGFloat controlX = startx - [_textfield1.text floatValue];
    CGFloat controlY = starty - [_textfield2.text floatValue];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startx, starty);
    CGPathAddQuadCurveToPoint(path, NULL, controlX, controlY, endX, endY);
    CAShapeLayer *linelayer = [CAShapeLayer layer];
    linelayer.path = path;
    CFRelease(path);
    linelayer.strokeColor = [UIColor redColor].CGColor;
    linelayer.lineWidth = 2.0;
    linelayer.fillColor = [UIColor clearColor].CGColor;
    [self.lineLayerArray addObject:linelayer];
    [self.view.layer addSublayer:linelayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
