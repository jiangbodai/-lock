//
//  RHTouchLockView.h
//  手势解锁
//
//  Created by forex-apple on 14/11/15.
//  Copyright (c) 2014年 forex. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RHTouchLockView;

@protocol RHTouchLockViewDelegate <NSObject>

@optional
/**传出最终确定手势路径*/
- (void)touchEndLockView:(RHTouchLockView *)touchLockView path:(NSString *)path;

/**传出实时手势路径*/
- (void)touchBeganLockView:(RHTouchLockView *)touchLockView path:(NSString *)path;

@end

@interface RHTouchLockView : UIView
/**设置多长时间后移除画的线（默认是0*/
@property (nonatomic, assign) CGFloat time;

/**设置画线的宽度(默认是5.0)*/
@property (nonatomic, assign) CGFloat lineWidth;

/**设置画线的颜色（默认是白色)*/
@property (nonatomic, strong) UIColor *color;
/**出入绘制路径是否错误*/
@property (nonatomic ,assign)  BOOL isSure;


@property (nonatomic ,weak) id<RHTouchLockViewDelegate> Delegate;

@end
