//
//  HWShoppinglistController.m
//  HWDemo
//
//  Created by huangwei on 2017/9/21.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import "HWShoppinglistController.h"

@interface HWShoppinglistController ()
/** 加入购物车按钮 */
@property (nonatomic, strong) UIButton *addButton;
/** 购物车按钮 */
@property (nonatomic, strong) UIButton *shoppingCartButton;
/** 商品数量label */
@property (nonatomic, strong) UILabel *goodsNumLabel;

@end

@implementation HWShoppinglistController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // UI搭建
    [self setUpUI];
}


- (void)setUpUI {
    // 加入购物车按钮
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 50, 120, 50)];
    [self.view addSubview:self.addButton];
    self.addButton.backgroundColor = [UIColor redColor];
    [self.addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 购物车按钮
    self.shoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120 - 50 - 20, self.addButton.frame.origin.y, 50, 50)];
    [self.view addSubview:self.shoppingCartButton];
    self.shoppingCartButton.backgroundColor = [UIColor cyanColor];
    [self.shoppingCartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 商品数量label
    self.goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shoppingCartButton.center.x, self.shoppingCartButton.frame.origin.y, 30, 15)];
    [self.view addSubview:self.goodsNumLabel];
    self.goodsNumLabel.backgroundColor = [UIColor redColor];
    self.goodsNumLabel.textColor = [UIColor whiteColor];
    self.goodsNumLabel.textAlignment = NSTextAlignmentCenter;
    self.goodsNumLabel.font = [UIFont systemFontOfSize:10];
    self.goodsNumLabel.layer.cornerRadius = 7;
    self.goodsNumLabel.clipsToBounds = YES;
    self.goodsNumLabel.text = @"99+";
}


/** 加入购物车按钮点击 */
- (void)addButtonClicked:(UIButton *)sender {
    
    CAShapeLayer * animationLayer = [[CAShapeLayer alloc]init];
    animationLayer.bounds = CGRectMake(0, 0, 40, 40);
    animationLayer.position = self.addButton.center;
    animationLayer.backgroundColor = [UIColor yellowColor].CGColor;
    // 添加layer到顶层视图控制器上
    [self.view.layer addSublayer:animationLayer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:self.addButton.center];
    [path addQuadCurveToPoint:self.shoppingCartButton.center controlPoint:CGPointMake(200,100)];

    //轨迹动画
    
    CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGFloat t = 1.0;
    pathAnimation.duration = t;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.path = path.CGPath;
    [animationLayer addAnimation:pathAnimation forKey:nil];
    //缩放
    CABasicAnimation * basea = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basea.duration = 1;
    basea.fromValue = [NSNumber numberWithFloat:1.0];
    basea.toValue = [NSNumber numberWithFloat:0.5];
    basea.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basea.removedOnCompletion = NO;
    basea.fillMode = kCAFillModeForwards;
    
    [animationLayer addAnimation:basea forKey:nil];
    //------- 动画结束后执行 -------//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationLayer removeFromSuperlayer];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.7];
        scaleAnimation.duration = 0.1;
        scaleAnimation.repeatCount = 2; // 颤抖两次
        scaleAnimation.autoreverses = YES;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.goodsNumLabel.layer addAnimation:scaleAnimation forKey:nil];
        
    });
    
    }

@end
