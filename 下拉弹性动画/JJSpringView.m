//
//  JJSpringView.m
//  下拉弹性动画
//
//  Created by liujianjian on 16/3/25.
//  Copyright © 2016年 rdg. All rights reserved.
//

#import "JJSpringView.h"
#import "UIView+Geometry.h"

#define kShapeLayerHeight 100

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface JJSpringView ()
{
    BOOL _isAnimating;
}
@property (nonatomic, strong)CAShapeLayer *shapeLayer;
@property (nonatomic, strong)UIView *datumView;
@property (nonatomic, strong)CADisplayLink *displayLink;

// 间接需要监听的属性
@property (nonatomic, assign)CGFloat observerX;
// 间接需要监听的属性
@property (nonatomic, assign)CGFloat observerY;


@end

@implementation JJSpringView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"observerX"];
    [self removeObserver:self forKeyPath:@"observerY"];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.observerX = kScreenWidth / 2.0;
        self.observerY = kShapeLayerHeight;
        
        [self makeShapeLayer];
        [self makeGuesture];
    }
    return self;
}
- (void)makeShapeLayer {

    UIView *clacView = [[UIView alloc] initWithFrame:CGRectMake(self.observerX, self.observerY, 10, 10)];
    clacView.backgroundColor = [UIColor redColor];
    [self addSubview:clacView];
    self.datumView = clacView;
    
    // 不能直接监听datumView的@"frame"或其他属性，会有BUG（手指松开的时候先回弹才会产生动画）
//    [self.datumView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addObserver:self forKeyPath:@"observerX" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"observerY" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.anchorPoint = CGPointZero;
//    shapeLayer.frame = CGRectMake(0, 0, self.width, kShapeLayerHeight);
    shapeLayer.fillColor = [UIColor colorWithRed:1.000 green:0.431 blue:0.912 alpha:1.000].CGColor;
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    [self updatePath]; // 更新一次路径，让路径画出来
    
}
- (void)makeGuesture {

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calcPath)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.paused = YES;
    self.displayLink = displayLink;
}
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    if (_isAnimating) {
        return;
    } else {
        
        
        if (pan.state == UIGestureRecognizerStateChanged) {
        
            CGPoint point = [pan translationInView:pan.view];
//        CGFloat xxx = self.clacView.left + point.x;
            CGFloat yyy = kShapeLayerHeight + point.y;
//            self.datumView.left += point.x;
//            self.datumView.top = yyy >= kShapeLayerHeight ? yyy : kShapeLayerHeight;
            
            
//            CGFloat x = point.x + kScreenWidth / 2.0;
//            CGFloat y = yyy >= kShapeLayerHeight ? yyy : kShapeLayerHeight;
            
//            [self setValue:@"observerX" forKey:[NSString stringWithFormat:@"%f", x]];
//            [self setValue:@"observerY" forKey:[NSString stringWithFormat:@"%f", y]];
            
            self.observerX = point.x + kScreenWidth / 2.0;
            self.observerY =  yyy >= kShapeLayerHeight ? yyy : kShapeLayerHeight;
            

            self.datumView.frame = CGRectMake(self.observerX, self.observerY, 10, 10);
            
            
            NSLog(@"NSStringFromCGPoint = %@", NSStringFromCGPoint(point));
//            [pan setTranslation:CGPointZero inView:pan.view];
            
//            NSLog(@"self.datumView.frame = %@", NSStringFromCGRect(self.datumView.frame));

        } else if (pan.state == UIGestureRecognizerStateCancelled ||
                   pan.state == UIGestureRecognizerStateEnded ||
                   pan.state == UIGestureRecognizerStateFailed) { // 手松开，会开启定时器调用定时器方法
            
            self.displayLink.paused = NO;
            _isAnimating = YES;
            
//            NSLog(@"self.datumView.frame = %@", NSStringFromCGRect(self.datumView.frame));
            
            [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
//                NSLog(@"self.datumView.frame = %@", NSStringFromCGRect(self.datumView.frame));
                
//                [UIView animateWithDuration:1.5 animations:^{
                    self.datumView.frame = CGRectMake(kScreenWidth / 2.0, kShapeLayerHeight, 10, 10);
//                }];
                
            } completion:^(BOOL finished) {
                self.displayLink.paused = YES;
                _isAnimating = NO;
            }];
            
        }

    }
    
    
}
/**
 *  更新路径，kvo调用
 */
- (void)updatePath {
//    NSLog(@"calcPath");
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [bezierPath addLineToPoint:CGPointMake(kScreenWidth, kShapeLayerHeight)];
    [bezierPath addQuadCurveToPoint:CGPointMake(0, kShapeLayerHeight) controlPoint:CGPointMake(self.observerX, self.observerY)];
    [bezierPath closePath];
    self.shapeLayer.path = bezierPath.CGPath;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    NSLog(@"observeValueForKeyPath = %@", change);
    [self updatePath];
}
/**
 *  定时器调用
 */
- (void)calcPath {
//    NSLog(@"calcPath");
    CALayer *layer = self.datumView.layer.presentationLayer;
    NSLog(@"%@", NSStringFromCGPoint(layer.position));
//    NSLog(@"self.datumView.frame = %@", NSStringFromCGRect(self.datumView.frame));
    self.observerX = layer.position.x;
    self.observerY = layer.position.y;
    
    [self updatePath];
    
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointZero];
//    [bezierPath fill];
//    [bezierPath addLineToPoint:CGPointMake(kScreenWidth, 0)];
//    [bezierPath addLineToPoint:CGPointMake(kScreenWidth, kShapeLayerHeight)];
//    [bezierPath addQuadCurveToPoint:CGPointMake(0, kShapeLayerHeight) controlPoint:layer.position];
//    [bezierPath closePath];
//    self.shapeLayer.path = bezierPath.CGPath;
    
    
}














@end
