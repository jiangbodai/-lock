//
//  ViewController.m
//  手势解锁
//
//  Created by 代江波 on 15/3/3.
//  Copyright (c) 2015年 代江波. All rights reserved.
//

#import "ViewController.h"
#import "RHTouchLockView.h"

@interface ViewController ()<RHTouchLockViewDelegate>{
    UILabel *_lable;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, self.view.bounds.size.width, 40)];
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor redColor];
    
    RHTouchLockView *lockView = [[RHTouchLockView alloc] initWithFrame:self.view.bounds];
    lockView.backgroundColor = [UIColor grayColor];
    lockView.Delegate = self;
    lockView.time = 3.0f;
    [lockView addSubview:_lable];
    [self.view addSubview:lockView];
    
    NSLog(@"==========");
    
}


#pragma mark RHTouchLockViewDelegate
- (void)touchBeganLockView:(RHTouchLockView *)touchLockView path:(NSString *)path
{

}

- (void)touchEndLockView:(RHTouchLockView *)touchLockView path:(NSString *)path{
    _lable.text = path;
}
@end
