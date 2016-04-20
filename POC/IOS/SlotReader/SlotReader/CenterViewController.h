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


@protocol CenterViewControllerDelegate <NSObject>
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;
@end

@interface CenterViewController : UIViewController <LanguageSelector, BoardThemeSelector>

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet SlotPickerView *picker;
@property (strong, nonatomic) NSArray *alphabet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@property (weak, nonatomic) IBOutlet UIImageView *board;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


- (IBAction)changeNumberOfLettersToShow:(id)sender;
- (IBAction)presentNextWord:(id)sender;


@end

