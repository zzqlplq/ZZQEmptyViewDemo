//
//  ZZQEmptyView.m
//  ZZQEmptyViewDemo
//
//  Created by 郑志强 on 2018/3/5.
//  Copyright © 2018年 郑志强. All rights reserved.
//

#import "ZZQEmptyView.h"
#import <Masonry.h>

#define DefaultContentColor    [UIColor lightGrayColor]

static const CGFloat kDefaultLabelFontSize = 16.f;
static const CGFloat kDefaultDetailsLabelFontSize = 14.f;

static NSString *const kDefaultBtnTitle = @"点击重新加载";
static NSString *const kDefaultNoDateDesc = @"没有数据";
static NSString *const kDefaultNoNetDesc = @"没有网络";
static NSString *const kDefaultNoDataImageName = @"noData";
static NSString *const kDefaultNoNetImageName = @"noNet";

@interface ZZQEmptyView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *button;

@end


@implementation ZZQEmptyView

#pragma mark 类方法

+ (instancetype)showEmptyViewAddTo:(UIView *)view withEmptyMode:(ZZQEmptyViewMode)emptyMode {
    
    ZZQEmptyView *emptyView = [[ZZQEmptyView alloc] initWithView:view];
    emptyView.emptyMode = emptyMode;
    [view addSubview:emptyView];
    return emptyView;
}


+ (BOOL)hideEmptyViewForView:(UIView *)view {

    ZZQEmptyView *emptyView = [ZZQEmptyView emptyView:view];
    if (emptyView != nil) {
        [emptyView hide];
        return YES;
    }
    return NO;
}


+ (ZZQEmptyView *)emptyView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (ZZQEmptyView *)subview;
        }
    }
    return nil;
}


#pragma mark 初始化相关

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}


- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    _autoHide = YES;
    _verticalSpace = 14.f;
    _emptyMode = ZZQEmptyViewModeNoData;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyViewClick)]];
    [self addSubviews];
    [self updateModelUI];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeSubviewsLayout];
}


- (void)addSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.button];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.detailLabel];
}


- (void)updateModelUI {
    
    ZZQEmptyViewMode mode = self.emptyMode;

    if (mode == ZZQEmptyViewModeNoData) {
        self.imgView.image = [UIImage imageNamed:kDefaultNoDataImageName];
        self.label.text = kDefaultNoDateDesc;
        [self.button setTitle:kDefaultBtnTitle forState:UIControlStateNormal];
 
    } else if (mode == ZZQEmptyViewModeNONet) {
        self.imgView.image = [UIImage imageNamed:kDefaultNoNetImageName];
        self.label.text = kDefaultNoNetDesc;
        [self.button setTitle:kDefaultBtnTitle forState:UIControlStateNormal];
    
    } else {
        self.imgView.image = nil;
        self.label.text = nil;
        [self.button setTitle:nil forState:UIControlStateNormal];
    }
}


- (void)makeSubviewsLayout {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self).offset(self.verticalOffset);
    }];
    
    NSMutableArray *subviews = [NSMutableArray array];
    
    if ([self showImageView]) {
        CGSize imageSize = self.imgView.image.size;
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(imageSize);
        }];
        [subviews addObject:self.imgView];
    } else {
        [self.imgView removeFromSuperview];
        self.imgView = nil;
    }
    
    if ([self showLabel]) {
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(20);
        }];
        [subviews addObject:self.label];
    } else {
        [self.label removeFromSuperview];
        self.label = nil;
    }

    if ([self showDetailLabel]) {
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(20);
        }];
        [subviews addObject:self.detailLabel];
    } else {
        [self.detailLabel removeFromSuperview];
        self.detailLabel = nil;
    }
    
    if ([self showButton]) {
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        [subviews addObject:self.button];
    } else {
        [self.button removeFromSuperview];
        self.button = nil;
    }
    
    for (int i = 0; i < subviews.count; i ++) {
        UIView *view = subviews[i];
        if (i == 0) {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view.mas_top);
            }];
        } else {
            UIView *frontView = subviews[i - 1];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(frontView.mas_bottom).offset(self.verticalSpace);
            }];
        }
        
        if (i == subviews.count - 1) {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view.mas_bottom);
            }];
        }
    }
}


- (BOOL)showImageView {
    return (!self.imgView.superview || self.imgView.image == nil) ? NO : YES;
}


- (BOOL)showLabel {
    return (!self.label.superview || (self.label.text.length == 0 && self.label.attributedText.length == 0)) ? NO : YES;
}


- (BOOL)showDetailLabel {
    return (!self.detailLabel.superview || (self.detailLabel.text.length == 0 && self.detailLabel.attributedText.length == 0)) ? NO : YES;
}


- (BOOL)showButton {
    return (!self.button.superview || (self.button.titleLabel.text.length == 0 && self.button.titleLabel.text.length == 0)) ? NO : YES;
}


- (void)emptyViewClick{
    if ([self.delegate respondsToSelector:@selector(emptyViewHadClick:)]) {
        [self.delegate emptyViewHadClick:self];
    }
    if (self.autoHide) {
        [self hide];
    }
}


- (void)hide {
    self.imgView = nil;
    self.label = nil;
    self.detailLabel = nil;
    self.button = nil;
    [self removeFromSuperview];
}


- (void)dealloc {
    NSLog(@"被销毁");
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self showButton] ? NO : YES;
}


#pragma mark - setter
- (void)setEmptyMode:(ZZQEmptyViewMode)emptyMode {
    if (emptyMode != _emptyMode) {
        _emptyMode = emptyMode;
        [self updateModelUI];
    }
}



#pragma mark - getter

- (UIView *)contentView {
    if(!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}


- (UIImageView *)imgView {
    if(!_imgView) {
        _imgView = [UIImageView new];
        _imgView.translatesAutoresizingMaskIntoConstraints = NO;
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.userInteractionEnabled = NO;
    }
    return _imgView;
}


- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textColor = DefaultContentColor;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:kDefaultLabelFontSize];
    }
    return _label;
}


- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = DefaultContentColor;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:kDefaultDetailsLabelFontSize];
    }
    return _detailLabel;
}


- (UIButton *)button {
    if(!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:DefaultContentColor forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.titleLabel.font = [UIFont systemFontOfSize:kDefaultLabelFontSize];
        [_button addTarget:self action:@selector(emptyViewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}



@end
