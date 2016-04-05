//
//  DictionaryTableViewController.h
//  SlotReader
//
//  Created by User on 3/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictionaryTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *cellData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;

@end
