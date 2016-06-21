//
//  TestingViewController.h
//  SwissPlanner
//
//  Created by User on 4/13/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestingViewController : UIViewController

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *roundedCorners;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end
