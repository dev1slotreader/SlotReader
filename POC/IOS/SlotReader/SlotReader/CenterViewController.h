//
//  ViewController.h
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BoardViewController.h"
#import "SWRevealViewController.h"
#import "SlotPickerView.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>


@protocol CenterViewControllerDelegate <NSObject, UICollectionViewDataSource, UICollectionViewDelegate>
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;
@end

@interface CenterViewController : UIViewController <LanguageSelector, BoardThemeSelector>

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *alphabet;
@property (strong, nonatomic) NSString *currentWord;

@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet SlotPickerView *picker;


@property (weak, nonatomic) IBOutlet UIImageView *board;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong,nonatomic) AVSpeechSynthesizer *synthesizer;
//@property (strong,nonatomic) AVSpeechUtterance *speechUtterance;

- (IBAction)changeNumberOfLettersToShow:(id)sender;
- (IBAction)presentNextWord:(id)sender;
- (IBAction)speakButtonTapped:(id)sender;


@end

