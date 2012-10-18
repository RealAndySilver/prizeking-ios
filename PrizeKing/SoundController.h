//
//  SoundController.h
//  PrizeKing
//
//  Created by Andres Abril on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundController : NSObject<AVAudioPlayerDelegate>{
    AVAudioPlayer *click;
    AVAudioPlayer *boom;
    AVAudioPlayer *air;
    AVAudioPlayer *cheer;
    AVAudioPlayer *achievementSound;
    
    
    AVAudioPlayer *mainBG;
    NSMutableArray *musicArray;
    
    float fxVolume;
    int past;
    
    
}
@property (nonatomic,retain)AVAudioPlayer *mainBG;
@property float fxVolume;
-(void)playClickSound;
-(void)AchievementUnlocked;
-(void)playBoomSound;
-(void)playAirSound;
-(void)playCheerSound;
-(void)playMainBGMusic;
@end