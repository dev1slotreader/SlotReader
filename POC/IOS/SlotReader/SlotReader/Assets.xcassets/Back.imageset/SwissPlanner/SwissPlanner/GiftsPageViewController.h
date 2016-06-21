//
//  GiftsPageViewController.h
//  SwissPlanner
//
//  Created by User on 4/21/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageViewController.h"

@interface GiftsPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
