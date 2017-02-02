//
//  CenterViewController+TextToSpeach.m
//  SlotReader
//
//  Created by Anastasiya Yarovenko on 22.01.17.
//  Copyright © 2017 User. All rights reserved.
//

#import "CenterViewController+TextToSpeach.h"
#import "DataMiner.h"

#define SPEACH_RATE 0.3f
#define SPEACH_VOLUME 0.2

@implementation CenterViewController (TextToSpeach)


- (void) speakCurrentWord{
    NSString *locale = [[DataMiner sharedDataMiner] getCurrentLocale];
    NSString *string = self.currentWord.lowercaseString;
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:locale];
    [utterance setRate:SPEACH_RATE];
    [utterance setVolume:SPEACH_VOLUME];
    
    AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [speechSynthesizer speakUtterance:utterance];
}

@end
