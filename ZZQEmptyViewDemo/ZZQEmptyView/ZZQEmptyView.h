//
//  ZZQEmptyView.h
//  ZZQEmptyViewDemo
//
//  Created by 郑志强 on 2018/3/5.
//  Copyright © 2018年 郑志强. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZZQEmptyView;

@protocol ZZQEmptyViewDelegate <NSObject>

@optional

- (void)emptyViewHadClick:(ZZQEmptyView *)emptyView;

@end

typedef NS_ENUM(NSInteger, ZZQEmptyViewMode) {
    ZZQEmptyViewModeNoData,
    ZZQEmptyViewModeNONet,
    ZZQEmptyViewModeNormal
};


@interface ZZQEmptyView : UIView

// 图片  normal时不设置 不显示
@property (strong, nonatomic, readonly) UIImageView *imgView;

// 标题  normal时不设置 不显示
@property (nonatomic, strong, readonly) UILabel *label;

// 详细说明 normal时不设置 不显示
@property (nonatomic, strong, readonly) UILabel *detailLabel;

// 加载按钮  normal时不设置 不显示
@property (nonatomic, strong, readonly) UIButton *button;

// 点击自动消失，默认为 YES
@property (nonatomic, assign) BOOL autoHide;

// 默认为 ZZQEmptyViewModeNoDate
@property (nonatomic, assign) ZZQEmptyViewMode emptyMode;

@property (nonatomic, weak) id<ZZQEmptyViewDelegate> delegate;

+ (instancetype)showEmptyViewAddTo:(UIView *)view withEmptyMode:(ZZQEmptyViewMode)emptyMode;

- (instancetype)initWithView:(UIView *)view;

+ (BOOL)hideEmptyViewForView:(UIView *)view;

- (void)hide;

@end
