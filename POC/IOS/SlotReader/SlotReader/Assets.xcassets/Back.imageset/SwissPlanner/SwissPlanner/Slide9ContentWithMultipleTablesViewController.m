//
//  Slide8ContentWithMultipleTablesViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide9ContentWithMultipleTablesViewController.h"

@interface Slide9ContentWithMultipleTablesViewController ()

@end

@implementation Slide9ContentWithMultipleTablesViewController

- (void)viewDidLoad {	
    [super viewDidLoad];
		
}

- (void) setSpecificViews {
	self.headerBlockLabel.text = NSLocalizedString(@"education.slide9.header", nil);
	self.contentBlock1Label.text = @"3.78 x (50 - 49) = €3.78 \n3.78 x (49 - 47) = €7.56 \n3.78 x (47 - 45) = €7.56 \n3.78 x (45 - 43) = €7.56 \n3.78 x (43 - 40) = €11.34 \n3.78 x (40 - 35) = €18.90 \n3.78 x (35 - 30) = €18.90 \n3.78 x (30 - 25) = €18.90 \n3.78 x (25 - 20) = €18.90 \n3.78 x (20 - 15) = €18.90 \n3.78 x 15 = €56.70";
	self.contentBlock2Label.text = NSLocalizedString(@"education.slide9.block2.content", nil);
	self.contentBlock3Label.text = NSLocalizedString(@"education.slide9.block3.content", nil);
	self.contentBlock4Label.text = NSLocalizedString(@"education.slide9.block4.content", nil);
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
