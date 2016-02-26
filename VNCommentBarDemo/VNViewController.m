//
//  VNViewController.m
//  VNCommentBarDemo
//
//  Created by wayne on 16/2/26.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "VNViewController.h"
#import "VNCommentBar.h"

@interface VNViewController ()

@property (nonatomic, weak) VNCommentBar *commentBar;
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation VNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.790 green:1.000 blue:0.575 alpha:1.000];
    NSString *imgFile = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"jpg"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgFile]];
    imgView.frame = self.view.bounds;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgView];
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _commentBtn.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 60, 64, 40);
    _commentBtn.backgroundColor = [UIColor whiteColor];
    [_commentBtn addTarget:self
                    action:@selector(comment)
          forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn setTitle:@"评论"
                 forState:UIControlStateNormal];
    [self.view addSubview:_commentBtn];
}

- (void)comment {
    VNCommentBar *commentBar = [[VNCommentBar alloc] initWithFrame:CGRectMake(0,
                                                                              [UIScreen mainScreen].bounds.size.height - kBarHeight,
                                                                              [UIScreen mainScreen].bounds.size.width,
                                                                              kBarHeight)
                                                      andAboveView:self.view];
    commentBar.sendBlock = ^(NSString *content) {
        NSLog(@"comment = %@", content);
    };
    [self.view addSubview:commentBar];
    self.commentBar = commentBar;
}

@end
