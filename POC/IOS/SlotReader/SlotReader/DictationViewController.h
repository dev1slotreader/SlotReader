//
//  DictationViewController.h
//  SlotReader
//
//  Created by User on 4/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FancyTextInputBlock.h"
#import "AppDelegate.h"

@interface DictationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LanguageSelector>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
@property (weak, nonatomic) IBOutlet FancyTextInputBlock *fancyTextInputBlock;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)changeNumberOfLetters:(id)sender;
- (IBAction)addNewWord:(id)sender;
- (IBAction)insertNewWordIntoBase:(id)sender;


@end
