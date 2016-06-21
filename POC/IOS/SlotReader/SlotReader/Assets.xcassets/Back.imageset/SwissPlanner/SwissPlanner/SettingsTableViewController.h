//
//  SettingsTableViewController.h
//  SwissPlanner
//
//  Created by User on 5/24/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableDictionary *userSettingsDictionary;

@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet TextFieldValidator *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsTitle;
@property (weak, nonatomic) IBOutlet TextFieldValidator *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *isInProgramTitle;
@property (weak, nonatomic) IBOutlet UILabel *languageTitle;

@property (weak, nonatomic) IBOutlet UIButton *checkbox;

@end
