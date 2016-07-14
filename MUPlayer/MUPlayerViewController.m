//
//  MUPlayerViewController.m
//  MUPlayer
//
//  Created by 潘元荣(外包) on 16/6/29.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "MUPlayerViewController.h"
#import "MUVideoView.h"
#import "AppDelegate.h"
#import <CoreFoundation/CoreFoundation.h>
@interface MUPlayerViewController()<MUVideoViewDelegate>{
    UIImageView *_thumbnailImageView;
    NSString *_isPlaying;
    CGRect _oringinalRect;
}

@property (nonatomic,strong)MUVideoView *videoView;
@property (nonatomic,strong)NSTimer *durationTimer;
@end
@implementation MUPlayerViewController
- (instancetype)initWithFrame:(CGRect)frame{
    if (self  = [super init]) {
        _oringinalRect = frame;
        self.view.frame = frame;
        _isPlaying = @"NO";
        //自定义控制回放条
        self.controlStyle = MPMovieControlStyleNone;
        self.view.backgroundColor = [UIColor blackColor];
        [self addObersver];
    }
    return self;
}
- (void)setContentURL:(NSURL *)contentURL{
    [self stop];
    [super setContentURL:contentURL];
    [self stop];
    [self requestThumbnailImagesAtTimes:@[@(4.0)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
- (void)showInWindow{
    
    self.videoView.frame = self.view.bounds;
    self.videoView.MUVideoViewDelegate = self;
    [self.view addSubview:self.videoView];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [app.window addSubview:self.view];
}
- (MUVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[MUVideoView alloc]init];
        _thumbnailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kMUVideoViewTopBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kMUVideoViewTopBarHeight - kMUVideoViewBottomBarHeight)];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _videoView;
}
- (void)addObersver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidChangedStatus:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playLoadDidChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playReadForPlayDidChanged:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(durationAviableDidChanged:) name:MPMovieDurationAvailableNotification object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishRequestThumbnialImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
   
}
- (void)playDidChangedStatus:(NSNotification*)noti{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        //[self.videoView toolViewHide:0.5 hidePlayBtn:YES];
        [self.videoView stopIndicatorAnimation:YES];
        [self startDurationTimer];
        if (_isPlaying.length == 2) {
            [self pause];
        }else{
            [self.videoView toolViewHide:0.5 hidePlayBtn:YES];
        }

    }else{
        [self.videoView stopIndicatorAnimation:NO];
        if (_isPlaying.length > 2) {
            [self.videoView toolViewHide:0.0 hidePlayBtn:NO];
            [self endDurationTimer];
        }
        
    }
}
- (void)playLoadDidChanged:(NSNotification*)noti{
    //NSLog(@"load%@",noti);
}
- (void)playReadForPlayDidChanged:(NSNotification*)noti{
    [self.videoView setProgressSliderMaximumValue:floor(self.duration)];
}
- (void)durationAviableDidChanged:(NSNotification*)noti{
    
}
- (void)finishRequestThumbnialImage:(NSNotification*)noti{
    UIImage *image = [noti.userInfo objectForKey: MPMoviePlayerThumbnailImageKey];
    _thumbnailImageView.image = image;
    _isPlaying = @"NO";
    [self.view addSubview:_thumbnailImageView];
}
- (void)requestSourceType:(NSNotification*)noti{
}
- (void)startDurationTimer{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
    
}
- (void)endDurationTimer{
    [self.durationTimer invalidate];
}
- (void)monitorVideoPlayback{
    double currentTime = floor(self.currentPlaybackTime);
    double totoalTime = floor(self.duration);
    [self setTimeLable:currentTime totoalTime:totoalTime];
    [self.videoView setProgressSliderValue:ceil(currentTime)];
}
- (void)setTimeLable:(CGFloat)currentTime totoalTime:(CGFloat)totalTime{
    double minutesElapsed = floor(currentTime / 60);
    // fmod 取余数
    double secondElapsed =  fmod(currentTime, 60);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsed,secondElapsed];
    double minutesRemaining = floor(totalTime / 60);
    double secondRemaining = fmod(totalTime, 60);
    NSString *timesRemainingString = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesRemaining,secondRemaining];
    [self.videoView setTimeLableWithText:[NSString stringWithFormat:@"%@/%@",timeElapsedString,timesRemainingString]];

}
#pragma mark--videoViewDelegate
- (void)videoViewChangeToFullScreenWithStatus:(VideoViewStatus)status{
    switch (status) {
        case VideoClose:{
            [self.videoView removeFromSuperview];
            self.videoView = nil;
            [self.view removeFromSuperview];
            [self stop];
            self.videoView.MUVideoViewDelegate = nil;
            self.MUPlayerClose();
        }
            break;
        case VideoFullScreen:{
            CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            rect.origin.x = (rect.size.height - rect.size.width) * 0.5;
            rect.origin.y = (rect.size.width - rect.size.height) * 0.5;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = rect;
                if (_isPlaying.length == 2) {
                    _thumbnailImageView.frame = CGRectMake(0, kMUVideoViewTopBarHeight,rect.size.width, rect.size.height - kMUVideoViewTopBarHeight - kMUVideoViewBottomBarHeight);
                }
                self.videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
                [self.view setTransform: CGAffineTransformMakeRotation(M_PI_2)];
            }];
        
            
        }
            break;
        case VideoOringinalScreen:{
            [UIView animateWithDuration:0.3 animations:^{
                [self.view setTransform:CGAffineTransformIdentity];
                self.view.frame = _oringinalRect;
                self.videoView.frame = CGRectMake(0, 0, _oringinalRect.size.width, _oringinalRect.size.height);
                if (_isPlaying.length == 2) {
                    _thumbnailImageView.frame = CGRectMake(0, kMUVideoViewTopBarHeight,_oringinalRect.size.width, _oringinalRect.size.height - kMUVideoViewTopBarHeight - kMUVideoViewBottomBarHeight);
                }
            }];
        }
            break;
        default:
            break;
    }
    
}
- (void)videoViewPlayStatusChangedWithPlay:(BOOL)isPlay{
    if (isPlay) {
        if (_isPlaying.length == 2) {
            self.currentPlaybackTime = 0.0;
            _isPlaying = @"YES";
            [_thumbnailImageView removeFromSuperview];
            [self play];
        }else{
            [self play];
        }
    }else{
       [self pause];
    }
}
- (void)videoViewSliderChangedWithValue:(CGFloat)value withStatus:(VideoViewStatus)status{
    switch (status) {
        case VideoProgressTap:
            [self pause];
            break;
        case VideoProgressTapEndValueChanged:{
            self.currentPlaybackTime = value;
            
        }
        case VideoProgressTapEnd:{
            [self play];
        }
        default:
            break;
    }
   
}
@end
