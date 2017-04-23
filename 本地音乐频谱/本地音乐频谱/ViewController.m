//
//  ViewController.m
//  本地音乐频谱
//
//  Created by WSL on 17/4/23.
//  Copyright © 2017年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "SpectrumView.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<AVAudioPlayerDelegate>

@property (strong,nonatomic) AVAudioPlayer *avAudioPlayer;
@property (strong,nonatomic) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.array = @[];
    
    [self setupUI];
}


- (void)setupUI {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"陈奕迅 - 陪你度过漫长岁月 (国语)" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.avAudioPlayer.meteringEnabled = YES;
    //音乐播放次数 负数为一直循环，直到stop，0为一次，1为2次，以此类推
    self.avAudioPlayer.numberOfLoops = 0;
    //准备播放
//    [self.avAudioPlayer prepareToPlay];
    [self.avAudioPlayer play];
    
    
    SpectrumView * spectrumView2 = [[SpectrumView alloc] initWithFrame:CGRectMake(0, 100, 120, 80)];
    spectrumView2.center = self.view.center;
    __weak SpectrumView * weakSpectrum2 = spectrumView2;
    spectrumView2.itemLevelCallback = ^() {
        
        [self.avAudioPlayer updateMeters];
        //取得第一个通道的音频，音频强度范围时-160到0
        float power= [self.avAudioPlayer averagePowerForChannel:0];
        weakSpectrum2.level = power;
    };
    
    [self.view addSubview:spectrumView2];
}


@end
