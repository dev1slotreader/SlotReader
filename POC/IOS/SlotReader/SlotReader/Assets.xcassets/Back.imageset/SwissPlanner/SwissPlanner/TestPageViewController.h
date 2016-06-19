//
//  TestPageViewController.h
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 02.06.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageViewController.h"
#import "TestCheckerDelegate.h"

@interface TestPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, TestCheckerDelegate>

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *roundedCorners;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *answerLabels;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *questionBlockView;
@property (strong, nonatomic) NSNumber *viewControllerIsInSecondaryLine;

@property (weak, nonatomic) IBOutlet UILabel *questionNumberIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionBlockTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *question1Label;
@property (weak, nonatomic) IBOutlet UILabel *question2Label;
@property (weak, nonatomic) IBOutlet UILabel *question3Label;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkboxButtons;

@property (weak, nonatomic) IBOutlet UIButton *activeButton;

- (IBAction)activeButtonClicked:(id)sender;
@end
