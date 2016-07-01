//
//  MUPlayerViewController.h
//  MUPlayer
//
//  Created by 潘元荣(外包) on 16/6/29.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//


@import MediaPlayer;

//typedef void(^MUPlayerClose)(void);
@interface MUPlayerViewController : MPMoviePlayerController
- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
@property (nonatomic,copy) void(^MUPlayerClose)(void);
@end
