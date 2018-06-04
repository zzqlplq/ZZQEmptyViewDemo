//
//  DetailViewController.m
//  ZZQEmptyViewDemo
//
//  Created by 郑志强 on 2018/3/6.
//  Copyright © 2018年 郑志强. All rights reserved.
//

#import "DetailViewController.h"
#import "ZZQEmptyView.h"
#import "UIView+Toast.h"

@interface DetailViewController ()<ZZQEmptyViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    if ([self.navigationItem.title isEqualToString:@"normal"]) {
        [self showNormalEmptyView];
    } else if ([self.navigationItem.title isEqualToString:@"customImage"]) {
        [self showCustomImageEmptyView];
    } else if ([self.navigationItem.title isEqualToString:@"customText"]) {
        [self showCustomTextEmptyView];
    } else {
        [self showCustomBtnEmptyView];
    }
}

- (void)showNormalEmptyView {
    [ZZQEmptyView showEmptyViewAddTo:self.view withEmptyMode:ZZQEmptyViewModeNONet];
}


- (void)showCustomImageEmptyView {
    
    NSString *imageName = [NSString stringWithFormat:@"placeholder_%ld",random()%3];
    UIImage *image = [UIImage imageNamed:imageName];
    
    ZZQEmptyView *emptyView = [[ZZQEmptyView alloc] initWithView:self.view];
    emptyView.emptyMode = ZZQEmptyViewModeNormal;
    emptyView.imgView.image = image;
    emptyView.autoHide = NO;
    emptyView.delegate = self;
    emptyView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:emptyView];
}


- (void)showCustomTextEmptyView {
    
    ZZQEmptyView *emptyView = [[ZZQEmptyView alloc] initWithView:self.view];
    emptyView.emptyMode = ZZQEmptyViewModeNormal;
    emptyView.verticalSpace = 4.f;
    emptyView.label.attributedText = [[NSAttributedString alloc] initWithString:@"这是自定义的标题" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],
                             NSForegroundColorAttributeName:[UIColor darkGrayColor],
                             NSStrokeColorAttributeName:[UIColor redColor],
                             NSStrokeWidthAttributeName:@1}];

    emptyView.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:@"这是自定义详细说明，字数是没限制的,\n想写多少写多少" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                                                     NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                     NSStrokeColorAttributeName:[UIColor blackColor],
                                                                                                     NSStrokeWidthAttributeName:@1}];

    [self.view addSubview:emptyView];
}



- (void)showCustomBtnEmptyView {

    ZZQEmptyView *emptyView = [[ZZQEmptyView alloc] initWithView:self.view];
    emptyView.emptyMode = ZZQEmptyViewModeNormal;
    emptyView.label.text = @"没有数据展示";
    [emptyView.button setTitle:@"这是按钮" forState:UIControlStateNormal];
    [emptyView.button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:emptyView];
}



- (void)emptyViewHadClick:(ZZQEmptyView *)emptyView {
    [self.view makeToast:@"暂停一会儿，再删除"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [emptyView hide];
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {    
    NSLog(@"控制器被销毁");
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
