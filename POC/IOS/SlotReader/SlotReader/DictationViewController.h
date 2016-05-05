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
#import "BoardViewController.h"

@interface DictationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LanguageSelector, BoardThemeSelector, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *board;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fancyTextInputBlockYPosition;
@property (weak, nonatomic) IBOutlet UIView *fancyTextInputBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (assign, nonatomic) NSInteger cellSelectionCounter;
- (IBAction)changeNumberOfLetters:(id)sender;
- (IBAction)addNewWord:(id)sender;
- (IBAction)insertNewWordIntoBase:(id)sender;

- (IBAction)editingButtonClicked:(UIButton *)sender;


@end
