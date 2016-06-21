//
//  Slide3ContentViewController.m
//  SwissPlanner
//
//  Created by User on 4/27/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide3ContentViewController.h"

@interface Slide3ContentViewController ()

@end

@implementation Slide3ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void) setSpecificViews {
	self.headerBlockLabel.text = NSLocalizedString(@"education.slide3.header", nil);
	self.headerContentBlock1Label.text = NSLocalizedString(@"education.slide3.block1.header", nil);
	self.headerContentBlock2Label.text = NSLocalizedString(@"education.slide3.block2.header", nil);
	self.contentBlock1Label.text = NSLocalizedString(@"education.slide3.block1.content", nil);
	self.contentBlock2Label.text = NSLocalizedString(@"education.slide3.block2.content", nil);
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
