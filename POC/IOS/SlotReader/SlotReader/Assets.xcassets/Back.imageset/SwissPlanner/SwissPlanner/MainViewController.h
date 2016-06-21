//
//  MainViewController.h
//  SwissPlanner
//
//  Created by User on 4/11/16.
//  Copyright © 2016 Elena Boychuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)openOrderButtonCLicked:(id)sender;
@end
