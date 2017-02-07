//
//  NewPlayViewController.m
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/22.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "NewPlayViewController.h"
#import "YFPMusicPlayer-Swift.h"
#import "constants.h"
#import "POP.h"
#import "MCSimpleAudioPlayer.h"
#import "CalcBrain.h"

@interface NewPlayViewController (){
    float value;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (assign, nonatomic) CGPoint touchBeginPos;
@property (strong, nonatomic) MCSimpleAudioPlayer *player;
@property (assign, nonatomic) BOOL isPlaying;

@property (assign, nonatomic) BOOL isFirstIn;

@end

@implementation NewPlayViewController

- (float)value {
    return value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _coverImgView.backgroundColor = [UIColor redColor];
    _coverImgView.layer.cornerRadius = 150.0/375.0*g_screenSize.width*0.5;
    _coverImgView.layer.masksToBounds = YES;
    
    [self.view addSubview:[[UIImageView alloc] initWithImage:_lastVCImg]];
    [self.view bringSubviewToFront:_bgView];
    
    _isFirstIn = YES;
    
    value = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isFirstIn) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"我终于失去了你 (Live)-李宗盛" ofType:@"mp3"];
        _player = [[MCSimpleAudioPlayer alloc]initWithFilePath:path fileType:kAudioFileMP3Type];
        [self startPlay];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_player stop];
}

- (IBAction)playOrPauseBtnClicked:(id)sender {
    if (_isPlaying) {
        [self pause];
    }else {
        [self continuePlay];
    }
}

- (void)startPlay {
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima3.toValue = [NSNumber numberWithFloat:M_PI*2];
    anima3.duration = 5;
    anima3.repeatCount = 999999;
    [_coverImgView.layer addAnimation:anima3 forKey:@""];
    
    [_player play];
    [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    _isPlaying = YES;
}

- (void) pause {
    CFTimeInterval pausedTime = [_coverImgView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    _coverImgView.layer.speed = 0.0;
    _coverImgView.layer.timeOffset = pausedTime;
    
    [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_player pause];
    _isPlaying = NO;
}

- (void) continuePlay {
    CFTimeInterval pausedTime = [_coverImgView.layer timeOffset];
    _coverImgView.layer.speed = 1.0;
    _coverImgView.layer.timeOffset = 0.0;
    _coverImgView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_coverImgView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _coverImgView.layer.beginTime = timeSincePause;
    
    [_player play];
    [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    _isPlaying = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _touchBeginPos = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    if ([CalcBrain ifMoveView:_touchBeginPos :pos]) {
        _bgView.frame = CGRectMake(pos.x, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    
    if ([CalcBrain calcDistance:_touchBeginPos :pos] > g_screenSize.width*0.5f) {
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.duration = 0.3;
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, g_screenSize.width, g_screenSize.height)];
        [_bgView.layer pop_addAnimation:animation forKey:@"reverseAnimation"];
    }
}
@end
