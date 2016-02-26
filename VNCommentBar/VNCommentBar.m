//
//  SPDetailPageCommentBar.m
//  ShangPin
//
//  Created by wayne on 16/2/23.
//  Copyright © 2016年 feng lu. All rights reserved.
//

#import "VNCommentBar.h"

@interface VNCommentBar ()
<UITextViewDelegate>

@property (nonatomic, weak) UIView *tapView;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *placeholder;
@property (nonatomic, weak) UIButton *sendButton;
@property (nonatomic, assign) CGSize lastContentSize;

@end

@implementation VNCommentBar

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   [UIScreen mainScreen].bounds.size.width,
                                                                   [UIScreen mainScreen].bounds.size.height)];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.userInteractionEnabled = YES;
        [bgView addSubview:tapView];
        UITapGestureRecognizer *tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(disappear)];
        [tapView addGestureRecognizer:tapGer];
        self.tapView = tapView;
        [self addSubviews];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(keyboardWillChangeFrame:)
                                   name:UIKeyboardWillChangeFrameNotification
                                 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect endKeyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - kBarHeight - endKeyboardFrame.size.height;
        self.frame = frame;
    }];
}

- (void)textDidChange:(NSNotification *)notification {
    NSString *text = [[notification object] text];
    if (text.length) {
        self.placeholder.hidden = YES;
        if (text.length > self.textLimit) {
            self.textView.text = [text substringToIndex:self.textLimit];
        }
    } else {
        self.placeholder.hidden = NO;
    }
    if (!CGSizeEqualToSize(_lastContentSize, self.textView.contentSize)) {
        _lastContentSize = self.textView.contentSize;
        CGFloat height = _lastContentSize.height;
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.size.height = height;
        self.textView.frame = textViewFrame;
        
        CGRect frame = self.frame;
        frame.origin.y -= _lastContentSize.height + kBarHeight - kTextViewHeight - frame.size.height;
        frame.size.height = height + kBarHeight - kTextViewHeight;
        self.frame = frame;
    }
}

- (void)addSubviews {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kTextViewPaddingLeft,
                                                                        kTextViewPaddingTop,
                                                                        [UIScreen mainScreen].bounds.size.width - kTextViewPaddingLeft - kTextViewPaddingRight - kButtonWidth - kButtonPaddingRight, kTextViewHeight)];
    textView.backgroundColor = [UIColor colorWithRed:.85 green:.85 blue:.85 alpha:1.0f];
    textView.delegate = self;
    textView.layer.cornerRadius = 3;
    textView.font = [UIFont systemFontOfSize:13.0f];
    textView.textColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:1.0f];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.layoutManager.allowsNonContiguousLayout = NO;
    [self addSubview:textView];
    self.textView = textView;
    [self.textView becomeFirstResponder];
    
    UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(kTextViewPaddingLeft + 5.0f,
                                                                     kTextViewPaddingTop,
                                                                     textView.frame.size.width - 10.0f,
                                                                     kTextViewHeight)];
    placeholder.font = [UIFont systemFontOfSize:13.0f];
    placeholder.text = @"说点什么吧";
    placeholder.textColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1.0f];
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.numberOfLines = 1;
    [self addSubview:placeholder];
    self.placeholder = placeholder;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - kButtonPaddingRight - kButtonWidth,
                                  kTextViewPaddingTop,
                                  kButtonWidth,
                                  kButtonHeight);
    [sendButton setTitle:@"发表" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:1.0f]
                     forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    sendButton.layer.borderWidth = .5f;
    sendButton.layer.borderColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0f].CGColor;
    sendButton.layer.cornerRadius = 2;
    [sendButton addTarget:self action:@selector(sendButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
}

- (void)sendButtonPressed {
    if (self.textView.text.length == 0) {
        return;
    }
    if (self.sendBlock) {
        self.sendBlock(_textView.text);
    }
    [self disappear];
}

- (void)disappear {
    [self.textView resignFirstResponder];
    [self.tapView removeFromSuperview];
    self.tapView = nil;
    [self removeFromSuperview];
}

- (NSInteger)textLimit {
    if (_textLimit == 0) {
        _textLimit = 1000;
    }
    return _textLimit;
}

@end
