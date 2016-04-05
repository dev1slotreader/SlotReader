//
//  ViewController.h
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
#import "SWRevealViewController.h"

@protocol CenterViewControllerDelegate <NSObject>
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;
@end

@interface CenterViewController : UIViewController

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIButton *boardButtonCollection;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *alphabet;
@property (weak, nonatomic) IBOutlet UIButton *dictionaryButton;
@property (weak, nonatomic) IBOutlet UILabel *fivepluslabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;

@property (weak, nonatomic) IBOutlet UIButton *dictionary;
@property (weak, nonatomic) IBOutlet UIImageView *board;
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;

@end

