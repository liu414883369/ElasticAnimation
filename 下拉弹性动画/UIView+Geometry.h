//
//  UIView+Geometry.h
//  AskBookStore
//
//  Created by liujianjian on 16/1/18.
//  Copyright © 2016年 rdgcina. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (Geometry)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

/// 高
@property CGFloat height;
/// 宽
@property CGFloat width;
/// Y坐标
@property CGFloat top;
/// X坐标
@property CGFloat left;
/// 底部 Y坐标+高度
@property CGFloat bottom;
/// 右侧 X坐标+宽度
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
