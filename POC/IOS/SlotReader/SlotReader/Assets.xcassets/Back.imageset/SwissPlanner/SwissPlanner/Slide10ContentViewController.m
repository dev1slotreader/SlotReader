//
//  Slide10ContentViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide10ContentViewController.h"

@interface Slide10ContentViewController ()

@end

@implementation Slide10ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setSpecificViews {
    
    self.headerBlockLabel.text = NSLocalizedString(@"education.slide10.header", nil);
    self.contentBlock1Label.text = @"14.85 x (50 - 49) = €14.85 \n14.85 x (49 - 47) = €29.70 \n14.85 x (47 - 45) = €29.70 \n14.85 x (45 - 43) = €29.70 \n14.85 x (43 - 40) = €44.55 \n14.85 x (40 - 35) = €74.25 \n14.85 x (35 - 30) = €74.25 \n14.85 x (30 - 25) = €74.25 \n14.85 x (25 - 20) = €74.25 \n14.85 x (20 - 15) = €74.25 \n14.85 x 15 = €222.75";
    self.contentBlock2Label.text = NSLocalizedString(@"education.slide10.block2.content", nil);
    self.contentBlock3Label.text = NSLocalizedString(@"education.slide10.block3.content", nil);
    self.contentBlock4Label.text = NSLocalizedString(@"education.slide10.block4.content", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
