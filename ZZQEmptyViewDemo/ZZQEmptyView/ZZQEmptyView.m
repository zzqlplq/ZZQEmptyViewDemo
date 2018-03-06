//
//  ZZQEmptyView.m
//  ZZQEmptyViewDemo
//
//  Created by 郑志强 on 2018/3/5.
//  Copyright © 2018年 郑志强. All rights reserved.
//

#import "ZZQEmptyView.h"
#import <Masonry.h>

static const CGFloat kDefaultLabelFontSize = 16.f;
static const CGFloat kDefaultDetailsLabelFontSize = 12.f;

static NSString *const kDefaultBtnTitle = @"点击重新加载";
static NSString *const kDefaultNoDateDesc = @"没有数据";
static NSString *const kDefaultNoNetDesc = @"没有网络";
static NSString *const kDefaultNoDataImageName = @"noData";
static NSString *const kDefaultNoNetImageName = @"noNet";

@interface ZZQEmptyView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

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
    _autoHide = YES;
    _emptyMode = ZZQEmptyViewModeNoData;
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyViewClick)];
    _tapGesture = tapGesture;
    [self setupViews];
}


- (void)setupViews {
    
    UIColor *defaultColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [UIImageView new];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = NO;
    _imgView = imageView;
    
    UILabel *label = [UILabel new];
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = defaultColor;
    label.font = [UIFont boldSystemFontOfSize:kDefaultLabelFontSize];
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    _label = label;
    
    UILabel *detailsLabel = [UILabel new];
    detailsLabel.adjustsFontSizeToFitWidth = NO;
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.textColor = defaultColor;
    detailsLabel.numberOfLines = 0;
    detailsLabel.font = [UIFont boldSystemFontOfSize:kDefaultDetailsLabelFontSize];
    detailsLabel.opaque = NO;
    detailsLabel.backgroundColor = [UIColor clearColor];
    _detailsLabel = detailsLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:kDefaultLabelFontSize];
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    [button setTitle:kDefaultBtnTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(emptyViewClick) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2.f;
    button.layer.borderColor = defaultColor.CGColor;
    button.layer.borderWidth = 1.f;
    _button = button;
}


- (void)layoutSubviews {
    [self addSubviews];
    [self makeSubviewsLayout];
    [super layoutSubviews];
}


- (void)addSubviews {
    
    [self addSubview:_label];
    [self addSubview:_detailsLabel];

    BOOL hasImage = _imgView.image;
    BOOL hasLabelText = (_label.text.length || _label.attributedText.length);
    
    ZZQEmptyViewMode mode = self.emptyMode;
    
    if (mode == ZZQEmptyViewModeNoData) {

        [self addSubview:_imgView];
        [self addSubview:_button];
        
        _imgView.image = hasImage ? _imgView.image : [UIImage imageNamed:kDefaultNoDataImageName];
        _label.text = hasLabelText ? _label.text : kDefaultNoDateDesc;
        
    } else if (mode == ZZQEmptyViewModeNONet) {

        [self addSubview:_imgView];
        [self addSubview:_button];
        _imgView.image = hasImage ? _imgView.image : [UIImage imageNamed:kDefaultNoNetImageName];
        _label.text = hasLabelText ? _label.text : kDefaultNoNetDesc;
        
    } else if (mode == ZZQEmptyViewModeNoImage) {

        [self addSubview:_button];
        _label.text = hasLabelText ? _label.text : kDefaultNoNetDesc;

    } else if (mode == ZZQEmptyViewModeNoButton) {

        [self addGestureRecognizer:_tapGesture];
        [self addSubview:_imgView];
        
        _imgView.image = hasImage ? _imgView.image : [UIImage imageNamed:kDefaultNoDataImageName];
        _label.text = hasLabelText ? _label.text : kDefaultNoDateDesc;

    } else if (mode == ZZQEmptyViewModeTextOnly) {
      
        [self addGestureRecognizer:_tapGesture];
        _label.text = hasLabelText ? _label.text : kDefaultNoDateDesc;
        
    }
}



- (void)makeSubviewsLayout {
    
    CGSize imageSize = _imgView.image.size;
    
    if ([self hasImageView]) {
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(-imageSize.height/3);
            make.size.mas_equalTo(imageSize);
        }];
    }
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        if ([self hasImageView]) {
            make.top.equalTo(_imgView.mas_bottom).offset(30);
        } else {
            make.centerY.equalTo(self);
        }
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(_label.mas_bottom).offset(20);
    }];
    
    if ([self hasButton]) {
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_detailsLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(120, 42));
        }];
    }
}


- (BOOL)hasImageView {
    return _imgView.superview && _imgView.image ? YES : NO;
}


- (BOOL)hasButton {
    return _button.superview == nil ? NO : YES;
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
    _imgView = nil;
    _label = nil;
    _detailsLabel = nil;
    _button = nil;
    [self removeFromSuperview];
}

- (void)dealloc {
    
    NSLog(@"被销毁");
    
}


@end
