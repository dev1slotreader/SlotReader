//
//  Slide13ContentViewController.h
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageContentViewController.h"
#import "PrettySimpleTableViewCell.h"

@interface Slide13ContentViewController : PageContentViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *firstTableView;
@property (weak, nonatomic) IBOutlet UILabel *headerBlockLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerContentBlockLabel;

@end
