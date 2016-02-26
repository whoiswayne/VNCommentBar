//
//  SPDetailPageCommentBar.h
//  ShangPin
//
//  Created by wayne on 16/2/23.
//  Copyright © 2016年 feng lu. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kBarHeight = 45.0f;
static CGFloat kTextViewPaddingLeft = 12.0f;
static CGFloat kTextViewPaddingTop = 6.5f;
static CGFloat kTextViewPaddingRight = 16.0f;
static CGFloat kTextViewHeight = 32.0f;
static CGFloat kButtonWidth = 74.5f;
static CGFloat kButtonHeight = 30.0f;
static CGFloat kButtonPaddingRight = 12.0f;

@interface VNCommentBar : UIView

@property (nonatomic, copy) void (^sendBlock)(NSString *content);
@property (nonatomic, assign) NSInteger textLimit;

- (instancetype)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;

@end
