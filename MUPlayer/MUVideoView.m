//
//  MUVideoView.m
//  MUPlayer
//
//  Created by 潘元荣(外包) on 16/6/29.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "MUVideoView.h"


static CGFloat kMUVideoViewButtonWidth = 30;
static CGFloat kMUVideoViewButtonHeight = 30;
static CGFloat kMUVideoViewLeftMargin = 10;

@interface MUVideoView()<UIGestureRecognizerDelegate>{
   
}
@property (nonatomic,strong) UIView *topBar;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIButton *pauseButton;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *fullScreenButton;
@property (nonatomic,strong) UIButton *shrinkScreenButton;
@property (nonatomic,strong) UISlider *progressSlider;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,assign) BOOL isBarShowing;

@end
@implementation MUVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self.topBar addSubview:self.closeButton];
        [self addSubview:self.bottomBar];
        [self.bottomBar addSubview:self.playButton];
        [self.bottomBar addSubview:self.pauseButton];
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        [self addSubview:self.indicatorView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget:self action:@selector(clickShowToolBar:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(0, 20, CGRectGetWidth(self.bounds), kMUVideoViewTopBarHeight);
    self.closeButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kMUVideoViewButtonWidth-kMUVideoViewLeftMargin, 0, kMUVideoViewButtonWidth, kMUVideoViewButtonHeight);
    self.bottomBar.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kMUVideoViewBottomBarHeight, CGRectGetWidth(self.bounds), kMUVideoViewBottomBarHeight);
    self.playButton.frame = CGRectMake(kMUVideoViewLeftMargin,0, kMUVideoViewButtonWidth, kMUVideoViewButtonHeight);
    self.pauseButton.frame = self.playButton.frame;
    self.progressSlider.frame = CGRectMake(self.playButton.frame.origin.x + kMUVideoViewLeftMargin + kMUVideoViewButtonWidth, 5, CGRectGetWidth(self.bounds) - 2 * kMUVideoViewButtonWidth - 3 * kMUVideoViewLeftMargin, kMUVideoViewBottomBarHeight * 0.5);
    self.timeLabel.frame = CGRectMake(0, kMUVideoViewBottomBarHeight * 0.5, CGRectGetWidth(self.bounds) - kMUVideoViewButtonWidth - kMUVideoViewLeftMargin, kMUVideoViewBottomBarHeight * 0.5);
    self.indicatorView.frame = CGRectMake(self.bounds.size.width * 0.5 - kMUVideoViewButtonWidth * 0.5, self.bounds.size.height * 0.5 - kMUVideoViewButtonHeight*0.5, kMUVideoViewButtonWidth, kMUVideoViewButtonHeight);
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kMUVideoViewLeftMargin - kMUVideoViewButtonWidth, 0, kMUVideoViewButtonWidth, kMUVideoViewButtonHeight);
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.isBarShowing = YES;
}

- (UIView *)topBar {
    if(!_topBar){
        _topBar = [[UIView alloc]init];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIButton *)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_closeButton.backgroundColor = [UIColor orangeColor];
        [_closeButton setImage:[UIImage imageNamed:@"kr-video-player-close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(videoViewStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)bottomBar{
    if(!_bottomBar){
        _bottomBar = [[UIView alloc]init];
        _bottomBar.backgroundColor = [UIColor clearColor];
    }
    return _bottomBar;
}

- (UIButton *)playButton{
    if(!_playButton){
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(videoPlayStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UIButton *)pauseButton{
    if(!_pauseButton){
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
        _pauseButton.hidden = YES;
        [_pauseButton addTarget:self action:@selector(videoPlayStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}
- (UISlider *)progressSlider{
    if(!_progressSlider){
        _progressSlider = [[UISlider alloc]init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        _progressSlider.continuous = YES;
        _progressSlider.value = .0f;
        [_progressSlider addTarget:self action:@selector(videoProgressChanged) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(videoProgressTapOn) forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self action:@selector(videoProgressTapEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressSlider;

}
- (UIButton *)fullScreenButton{
    if(!_fullScreenButton){
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(videoViewStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}
- (UIButton *)shrinkScreenButton{
    if(!_shrinkScreenButton){
        _shrinkScreenButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"kr-video-player-shrinkscreen"] forState:UIControlStateNormal];
        _shrinkScreenButton.hidden = YES;
        [_shrinkScreenButton addTarget:self action:@selector(videoViewStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shrinkScreenButton;
}

- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.text = @"00:00/00:00";
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}
#pragma mark--privateMthod
- (void)clickShowToolBar:(UITapGestureRecognizer*)tap{
    if (self.isBarShowing == YES) {
        [self toolViewHide:1.5];
    }else{
       [UIView animateWithDuration:1.5 animations:^{
           self.topBar.alpha = 1.0;
           self.bottomBar.alpha = 1.0;
       } completion:^(BOOL finished) {
           self.isBarShowing = YES;
       }];
    }
    
}
-(void)toolViewHide:(CGFloat)duration{
    [UIView animateWithDuration:duration animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}
- (void)toolViewHide:(CGFloat)duration hidePlayBtn:(BOOL)hidden{
    if (hidden == YES) {
        self.playButton.hidden = YES;
        self.pauseButton.hidden = NO;
    }else{
        self.playButton.hidden = NO;
        self.pauseButton.hidden = YES;
    }
    if (duration > 0) {
         [self toolViewHide:duration];
    }
   
}
- (void)stopIndicatorAnimation:(BOOL)stop{
    if (stop) {
        [self.indicatorView stopAnimating];
    }else{
        [self.indicatorView startAnimating];
    }
    
}
- (void)setTimeLableWithText:(NSString *)string{
    self.timeLabel.text = string;
}
- (void)setProgressSliderValue:(CGFloat)value{
    self.progressSlider.value = value;
}
- (void)setProgressSliderMaximumValue:(CGFloat)maxValue{
    self.progressSlider.maximumValue = maxValue;
}
#pragma mark--clickButton
- (void)videoPlayStatusChanged:(UIButton*)button{
    [self toolViewHide:1];
    if (button == self.playButton) {
        [self.MUVideoViewDelegate videoViewPlayStatusChangedWithPlay:YES];
        button.hidden = YES;
        self.pauseButton.hidden = NO;
    }else{
        button.hidden = YES;
        self.playButton.hidden = NO;
        [self.MUVideoViewDelegate videoViewPlayStatusChangedWithPlay:NO];
    }

}

- (void)videoProgressChanged{
    [self.MUVideoViewDelegate videoViewSliderChangedWithValue:_progressSlider.value withStatus:VideoProgressTapEndValueChanged];
}
- (void)videoProgressTapOn{
    [self.MUVideoViewDelegate videoViewSliderChangedWithValue:_progressSlider.value withStatus:VideoProgressTap];
}
- (void)videoProgressTapEnd{
    [self.MUVideoViewDelegate videoViewSliderChangedWithValue:_progressSlider.value withStatus:VideoProgressTapEnd];
}
- (void)videoViewStatusChanged:(UIButton*)button{
    if (button == self.closeButton) {
    [self.MUVideoViewDelegate videoViewChangeToFullScreenWithStatus:VideoClose];

    }else if (button == self.fullScreenButton){
        [self.MUVideoViewDelegate videoViewChangeToFullScreenWithStatus:VideoFullScreen];
        button.hidden = YES;
        self.shrinkScreenButton.hidden = NO;
    }else if (button == self.shrinkScreenButton){
        [self.MUVideoViewDelegate videoViewChangeToFullScreenWithStatus:VideoOringinalScreen];
        button.hidden = YES;
        self.fullScreenButton.hidden = NO;
    }
    [self toolViewHide:1.5];
}

@end
