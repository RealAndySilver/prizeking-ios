//
//  SoundController.m
//  PrizeKing
//
//  Created by Andres Abril on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundController.h"

@implementation SoundController
@synthesize mainBG,fxVolume;
-(void)playClickSound{
    NSLog(@"BG ON!!!!!!!!!!!");
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"click" withExtension: @"aiff"];
    NSError *error;
    click = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    //click.volume=fxVolume;
    [click play];
}
-(void)AchievementUnlocked{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"AchievementUnlocked" withExtension: @"mp3"];
    NSError *error;
    achievementSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    achievementSound.volume=10;
    [achievementSound play];
}
-(void)playBoomSound{
    NSMutableArray *soundArray=[[NSMutableArray alloc]init];
    [soundArray addObject:@"gameOver"];
    [soundArray addObject:@"whistle"];
    
    int i = (arc4random() % [soundArray count]); 
    NSURL *url = [[NSBundle mainBundle] URLForResource:[soundArray objectAtIndex:i] withExtension: @"mp3"];
    NSError *error;
    boom = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    boom.volume=fxVolume;
    [boom play];
}
-(void)playAirSound{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"air" withExtension: @"mp3"];
    NSError *error;
    air = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [air play];
}
-(void)playCheerSound{
    NSURL *url=[[NSBundle mainBundle] URLForResource:@"cheer" withExtension: @"mp3"];
    NSError *error;
    cheer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    cheer.volume=fxVolume;
    [cheer play];
}
-(void)playMainBGMusic{
    NSLog(@"Start Audio");
    if (!musicArray) {
        musicArray=[[NSMutableArray alloc]init];
        //[musicArray addObject:@"folkBgMusic"];
        [musicArray addObject:@"rNroll"];
        [musicArray addObject:@"lazyDay"];
        [musicArray addObject:@"roadTrip"];
        [musicArray addObject:@"sideman"];
        [musicArray addObject:@"bigBand"];
        [musicArray addObject:@"buddy"];
    }
    
    int i = (arc4random() % [musicArray count]); 
    while (i==past){
        i = (arc4random() % [musicArray count]);
    };
    past=i;
    NSString *song=[musicArray objectAtIndex:i];
    NSURL *url =[[NSBundle mainBundle] URLForResource:song withExtension: @"mp3"];
    NSLog(@"Now Playing %@ array count %i",[musicArray objectAtIndex:i], [musicArray count]);
    NSError *error;
    mainBG = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    mainBG.volume=0.01;
    mainBG.delegate=self;
    mainBG.numberOfLoops=0;
    [mainBG play];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"Finish Audio");
    [self playMainBGMusic];
}
@end

