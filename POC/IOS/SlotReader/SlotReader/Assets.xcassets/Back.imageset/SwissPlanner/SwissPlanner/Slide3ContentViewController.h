//
//  Slide3ContentViewController.h
//  SwissPlanner
//
//  Created by User on 4/27/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageContentViewController.h"

@interface Slide3ContentViewController : PageContentViewController

@property (weak, nonatomic) IBOutlet UILabel *headerBlockLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerContentBlock1Label;
@property (weak, nonatomic) IBOutlet UILabel *contentBlock1Label;
@property (weak, nonatomic) IBOutlet UILabel *headerContentBlock2Label;
@property (weak, nonatomic) IBOutlet UILabel *contentBlock2Label;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
