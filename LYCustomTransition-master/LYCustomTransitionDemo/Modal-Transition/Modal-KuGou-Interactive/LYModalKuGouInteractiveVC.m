//
//  LYModalKuGouInteractiveVC.m
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/2/23.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "LYModalKuGouInteractiveVC.h"
#import "LYModalKuGouInteractiveAnimatedTransition.h"
#import "LYModalKuGouInteractiveSecondVC.h"

@interface LYModalKuGouInteractiveVC ()

@property (nonatomic, strong) LYModalKuGouInteractiveAnimatedTransition *animatedTransition;
@property (nonatomic, strong) UIImageView         *imgView;

@end

@implementation LYModalKuGouInteractiveVC

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KuGou";
    self.view.backgroundColor = bgColor;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    _imgView.center = self.view.center;
    _imgView.image = [UIImage imageNamed:@"kugoou"];
    _imgView.userInteractionEnabled = YES;
    [self.view addSubview:_imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSecond)];
    [_imgView addGestureRecognizer:tap];
}

- (void)pushSecond{
    
    LYModalKuGouInteractiveSecondVC *second = [[LYModalKuGouInteractiveSecondVC alloc] init];
    
    //1. 设置代理
    second.transitioningDelegate = self.animatedTransition;
    
    //2.跳转
    [self presentViewController:second animated:YES completion:nil];
}


- (LYModalKuGouInteractiveAnimatedTransition *)animatedTransition{
    if (!_animatedTransition) {
        _animatedTransition = [[LYModalKuGouInteractiveAnimatedTransition alloc] init];
    }
    return _animatedTransition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


