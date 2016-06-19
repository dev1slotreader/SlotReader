//
//  ConclusionTableViewController.h
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface ConclusionTableViewController : PageContentViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)tableTypeSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *headerBlockLabel;
@property (nonatomic, strong) NSArray * baseDataArray;
@property (nonatomic, strong) NSArray * extraDataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
