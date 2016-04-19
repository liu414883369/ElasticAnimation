//
//  ViewController.m
//  下拉弹性动画
//
//  Created by liujianjian on 16/3/25.
//  Copyright © 2016年 rdg. All rights reserved.
//

#import "ViewController.h"
#import "JJSpringView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JJSpringView *springView = [[JJSpringView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:springView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
