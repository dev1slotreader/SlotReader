//
//  DictationViewController.h
//  SlotReader
//
//  Created by User on 4/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;

- (IBAction)changeNumberOfLetters:(id)sender;

@end
