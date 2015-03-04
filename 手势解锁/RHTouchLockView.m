//
//  RHTouchLockView.m
//  手势解锁
//
//  Created by forex-apple on 14/11/15.
//  Copyright (c) 2014年 forex. All rights reserved.
//

#import "RHTouchLockView.h"
//按钮高度
#define LockBtn (is3_5Inch?(57):(77))
//排列数
#define counts (3)
//密码正确时候的颜色
#define SuccessColor (RHColor(174, 92, 98))
//密码错误时候的颜色
#define ErrorColor (RHColor(192, 38, 42))
@interface RHTouchLockView()
//设置所有按钮
@property (nonatomic ,strong) NSArray *buttons;

//设置当前选中的按钮数组
@property (nonatomic ,strong) NSMutableArray *selectedButtons;

//当前手指的位置
@property (nonatomic ,assign) CGPoint currentLocation;


@end


@implementation RHTouchLockView

#pragma mark  - 懒加载

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.lineWidth = 5.0f;
        self.color = [UIColor blueColor];
        self.isSure = YES;
       
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 5.0f;
        self.color = [UIColor blueColor];
        self.isSure = YES;
    }
    return self;
}

- (void)setIsSure:(BOOL)isSure
{
    _isSure = isSure;
    //遍历选中按钮 设置选中背景
    if (_isSure) {
        for (int i = 0; i < self.buttons.count; i++) {
            UIButton *btn = self.buttons[i];
            [btn setBackgroundImage:[UIImage imageNamed:@"圆_点击时"] forState:UIControlStateSelected];
        }
        self.color = [UIColor blueColor];
    }else{
        for (int i = 0; i < self.buttons.count; i++) {
            UIButton *btn = self.buttons[i];
            [btn setBackgroundImage:[UIImage imageNamed:@"圆_设置错误时"] forState:UIControlStateSelected];
        }
        self.color = [UIColor redColor];
    }
    [self layoutIfNeeded];
  
}

- (NSMutableArray *)selectedButtons
{
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

- (NSArray *)buttons
{
    if (!_buttons) {
        NSMutableArray *arrarM = [NSMutableArray array];
        
        // 仅初始化控件，设置数组内容
        for (int i = 0; i < 9; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            // 禁止按钮的用户交互
            btn.userInteractionEnabled = NO;
            
            // 设置按钮的tag
            btn.tag = i;
            
            // 设置背景图片
            [btn setBackgroundImage:[UIImage imageNamed:@"圆_未点击"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"圆_点击时"] forState:UIControlStateSelected];
            
            [self addSubview:btn];
            [arrarM addObject:btn];
        }
        
        // 返回数组
        _buttons = arrarM;
    }
    return _buttons;
}

// 重新调整界面布局
- (void)layoutSubviews
{
    [super layoutSubviews];

    // 九宫格
    CGFloat buttonW = 74;
    CGFloat buttonH = 74;
    CGFloat marginX = (self.bounds.size.width - buttonW * counts) / (counts + 1);
    CGFloat marginY = (self.bounds.size.height - buttonH * counts) / (counts + 1);
    
    int index = 0;
    for (int row = 0; row < counts; row++) {
        for (int col = 0; col < counts; col++) {
            // col -> x
            // row -> y
            // 取出按钮
            UIButton *btn = self.buttons[index];
            
            CGFloat x = col * (buttonW + marginX) + marginX;
            CGFloat y = row * (buttonH + marginY) + marginY;
            
            btn.frame = CGRectMake(x, y, buttonW, buttonH);
            
            index++;
        }
    }
}

#pragma mark - 私有方法
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = touches.anyObject;
    return [touch locationInView:self];
}

- (UIButton *)buttonWithPoint:(CGPoint)point
{
    // 遍历所有的按钮
    for (UIButton *btn in self.buttons) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

// 所有的按钮点击都有touch事件来处理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 取出点中的位置
    CGPoint point = [self pointWithTouches:touches];
    
    // 取出按钮
    UIButton *btn = [self buttonWithPoint:point];
    
    // 如果点中按钮，同时按钮未被选中
    if (btn && btn.selected == NO) {
        // 按钮被选中
        btn.selected = YES;
        // 记录被选中的按钮
        [self.selectedButtons addObject:btn];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 取出点中的位置
    CGPoint point = [self pointWithTouches:touches];
    
    // 取出按钮
    UIButton *btn = [self buttonWithPoint:point];
    
    // 如果点中按钮，同时按钮未被选中
    if (btn && btn.selected == NO) {
        // 按钮被选中
        btn.selected = YES;
        
        // 记录被选中的按钮
        [self.selectedButtons addObject:btn];
        
        // 判断代理是否实现方法
        if ([self.Delegate respondsToSelector:@selector(touchBeganLockView:path:)]) {
            // 通知掉用方用户输入的手势字符串
            NSMutableString *strM = [NSMutableString string];
            // 遍历选中的按钮集合
            for (UIButton *btn in self.selectedButtons) {
                [strM appendString:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
            }
            [self.Delegate touchBeganLockView:self path:strM];
        }
        
    } else {
        // 绘图
        self.currentLocation = point;
    }
    
    [self setNeedsDisplay];
    
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 判断代理是否实现方法
    if ([self.Delegate respondsToSelector:@selector(touchEndLockView:path:)]) {
        // 通知掉用方用户输入的手势字符串
        NSMutableString *strM = [NSMutableString string];
        // 遍历选中的按钮集合
        for (UIButton *btn in self.selectedButtons) {
            [strM appendString:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
        }
        [self.Delegate touchEndLockView:self path:strM];
    }
    
    UIButton *lastButton = self.selectedButtons.lastObject;
    
    for (UIButton *button in self.buttons) {
        if (self.currentLocation.x != button.center.x && self.currentLocation.y != button.center.y && button.selected == YES) {
            self.currentLocation = lastButton.center;
        }
    }

    //延时清除路径 和选中状态
    [self setUpCompleteAnimate];
    
    [self setNeedsDisplay];
}
//延时清除路径
- (void)setUpCompleteAnimate
{
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //     清楚所有选中按钮的被选中状态
        for (UIButton *btn in self.selectedButtons) {
            btn.selected = NO;
        }
        //重新设置可以交互
        self.userInteractionEnabled = YES;
        //重新设置默认正确
        self.isSure = YES;
        [self setIsSure:YES];
        [self.selectedButtons removeAllObjects];
        [self setNeedsDisplay];
    });
}

// 每次都是重新绘制，之前绘制的线条都会被清除掉
// drawRect仅仅负责绘图部分的内容
- (void)drawRect:(CGRect)rect
{
    if (self.selectedButtons.count == 0) {
        return;
    }
    
    // 将selectedButtons数组中的所有中心点连线
    // 贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 循环遍历所有选中的按钮，找出中心点坐标
    int index = 0;
    for (UIButton *button in self.selectedButtons) {
        
        if (index == 0) {
            // 被选中的第一个按钮
            [path moveToPoint:button.center];
        } else {
            // 其他按钮
            [path addLineToPoint:button.center];
        }
        
        index++;
    }
   
    
    [path addLineToPoint:self.currentLocation];
   
    // 增加当前的位置的连线
    
    // 绘制路径
    [self.color set];
    [path setLineWidth:self.lineWidth];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path stroke];
    
}

@end
