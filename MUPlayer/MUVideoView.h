//
//  MUVideoView.h
//  MUPlayer
//
//  Created by 潘元荣(外包) on 16/6/29.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import <UIKit/UIKit.h>


static CGFloat kMUVideoViewTopBarHeight = 30.0;
static CGFloat kMUVideoViewBottomBarHeight = 40;
typedef NS_ENUM(NSInteger,VideoViewStatus){
    VideoClose,
    VideoFullScreen,
    VideoOringinalScreen,
    VideoProgressTap,
    VideoProgressTapEnd,
    VideoProgressTapEndValueChanged,
};


@protocol MUVideoViewDelegate <NSObject>
- (void)videoViewChangeToFullScreenWithStatus:(VideoViewStatus)status;
- (void)videoViewPlayStatusChangedWithPlay:(BOOL)isPlay;
- (void)videoViewSliderChangedWithValue:(CGFloat)value withStatus:(VideoViewStatus)status;
@end
@interface MUVideoView : UIView
@property (nonatomic,strong) id <MUVideoViewDelegate> MUVideoViewDelegate;
- (void)toolViewHide:(CGFloat)duration hidePlayBtn:(BOOL)hidden;
- (void)stopIndicatorAnimation:(BOOL)stop;
- (void)setTimeLableWithText:(NSString*)string;
- (void)setProgressSliderValue:(CGFloat)value;
- (void)setProgressSliderMaximumValue:(CGFloat)maxValue;
@end
