//
//  ViewController.m
//  MUPlayer
//
//  Created by 潘元荣(外包) on 16/6/29.
//  Copyright © 2016年 潘元荣(外包). All rights reserved.
//

#import "ViewController.h"
#import "MUPlayerViewController.h"

@interface ViewController (){
    MUPlayerViewController *_vc;
    UIButton *_imagebtn;
}
@property (nonatomic,strong)MUPlayerViewController *myVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getThumbnailImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
  self.myVC = [[MUPlayerViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
    videoURL = [NSURL URLWithString:@"http://zyvideo1.oss-cn-qingdao.aliyuncs.com/zyvd/7c/de/04ec95f4fd42d9d01f63b9683ad0"];
    self.myVC.contentURL = videoURL;
  __weak  typeof(self)weakSelf = self;
    self.myVC.MUPlayerClose = ^(void){
        weakSelf.myVC = nil;
    };
    //[self.view addSubview:vc.view];
}

#pragma mark--buttonMethod
- (IBAction)playLocalVideo:(UIButton *)sender {
 __block   MUPlayerViewController *vc = [[MUPlayerViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
    //videoURL = [NSURL URLWithString:@"http://zyvideo1.oss-cn-qingdao.aliyuncs.com/zyvd/7c/de/04ec95f4fd42d9d01f63b9683ad0"];
    vc.contentURL = videoURL;
    
    vc.MUPlayerClose = ^(void){
        vc = nil;
    };
    //[self.view addSubview:vc.view];
    [vc showInWindow];
    
   
    
}
- (IBAction)playRemoteVideo:(UIButton *)sender {
   __block MUPlayerViewController *vc = [[MUPlayerViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
    videoURL = [NSURL URLWithString:@"http://zyvideo1.oss-cn-qingdao.aliyuncs.com/zyvd/7c/de/04ec95f4fd42d9d01f63b9683ad0"];
    vc.contentURL = videoURL;
    vc.MUPlayerClose = ^(void){
        vc = nil;
    };
    [vc showInWindow];
    
}
//@"http://krtv.qiniudn.com/150522nextapp"

- (IBAction)playRemoteVideo2:(id)sender {
    
   __block MUPlayerViewController *vc = [[MUPlayerViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
    videoURL = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
    vc.contentURL = videoURL;
    vc.MUPlayerClose = ^(void){
        vc = nil;
    };
   // [self.view addSubview:vc.view];
    [vc showInWindow];
}
#pragma mark--Notification
- (void)getThumbnailImage:(NSNotification*)notification{
    UIImage *image = [notification.userInfo objectForKey: MPMoviePlayerThumbnailImageKey];
    _imagebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imagebtn.frame = CGRectMake(0, self.view.bounds.size.height - 300, self.view.bounds.size.width, 300);
    [_imagebtn setBackgroundImage:image forState:UIControlStateNormal];
    [_imagebtn setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
    [_imagebtn setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateHighlighted];
    [_imagebtn addTarget:self action:@selector(openVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imagebtn];
    
}
- (void)openVC{
    _imagebtn.hidden = YES;
    [self.myVC showInWindow];
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
