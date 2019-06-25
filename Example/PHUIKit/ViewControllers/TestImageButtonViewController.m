//
//  TestImageButtonViewController.m
//  PHUIKit_Example
//
//  Created by LinXiaoBin on 2018/9/3.
//  Copyright © 2018年 linxiaobin. All rights reserved.
//

#import "TestImageButtonViewController.h"
#import <TMUIKit/TMUIKit.h>
#import <TMCategories/TMCategories.h>
#import <Masonry/Masonry.h>

@interface TestImageButtonViewController()

@end

@implementation TestImageButtonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn1 = [self createButton:CGRectMake(40, 100, 60, 60)];
    [btn1 tm_verticalCenterImageAndTitleWithSpacing:4];
    [btn1 addTarget:self action:@selector(onButtonTap) forControlEvents:UIControlEventTouchUpInside];

    btn1 = [self createButton:CGRectMake(140, 100, 80, 50)];
    [btn1 tm_horizontalCenterImageAndTitleWithSpacing:4];

    btn1 = [self createButton:CGRectMake(240, 100, 80, 50)];
    [btn1 tm_horizontalCenterTitleAndImageWithSpacing:4];

    btn1 = [self createButton:CGRectZero];
    btn1.tm_normalTitle(@"长长长长长长标");
    btn1.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [btn1 tm_horizontalCenterImageAndTitleWithSpacing:4];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(@(200));
    }];

    // ToDo: lxb fix vertical button long title show bug
    btn1 = [self createButton:CGRectMake(0, 0, 200, 200)];
    btn1.tm_normalTitle(@"长长长长长长标题");
    btn1.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [btn1 tm_verticalCenterImageAndTitleWithSpacing:4];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(@(300));
        make.size.mas_equalTo([btn1 tm_sizeThatFits]);
    }];
}

- (void)onButtonTap
{
    TMToast.toast().setMessage(@"HH").showTo(self.view);
}

- (UIButton *)createButton:(CGRect)frame
{
    UIImage *image = [[UIImage imageNamed:@"house_2"] tm_scaleImageToSize:CGSizeMake(30, 30)];
    UIButton *btn1 = UIButton.tm_button.tm_frame(frame).tm_normalImage(image).tm_normalTitle(@"首页");
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    btn1.titleLabel.backgroundColor = [UIColor blackColor];
    btn1.imageView.backgroundColor = [UIColor purpleColor];
    btn1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn1];
    return btn1;
}


@end
