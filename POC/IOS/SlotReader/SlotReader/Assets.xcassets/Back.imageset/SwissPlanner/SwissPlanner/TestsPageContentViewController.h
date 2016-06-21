//
//  TestsPageContentViewController.h
//  SwissPlanner
//
//  Created by User on 6/2/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestCheckerDelegate.h"

@interface TestsPageContentViewController : UITableViewController

@property NSUInteger pageIndex;
@property NSString *question;
@property NSArray *answers;

@property (assign, nonatomic) id<TestCheckerDelegate> testCheckerDelegate;

@end
