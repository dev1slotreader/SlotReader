//
//  PageContentWithTablesViewController.h
//  SwissPlanner
//
//  Created by User on 4/27/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentWithTablesViewController : PageContentViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *prettyTable;

@property (nonatomic, strong) NSMutableArray *yourCellsRows;
@property (nonatomic, strong) NSMutableArray *partnerCellsRows;

@property (nonatomic, strong) NSArray *dataArray;

@end
