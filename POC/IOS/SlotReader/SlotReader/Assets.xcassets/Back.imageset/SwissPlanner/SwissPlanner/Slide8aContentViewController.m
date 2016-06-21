//
//  Slide71ContentViewController.m
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 23.05.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide8aContentViewController.h"

@interface Slide8aContentViewController ()

@end

@implementation Slide8aContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yourCellsRows = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:11], nil];
    self.partnerCellsRows = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:6], nil];
}

- (void) setSpecificViews {
    self.headerBlockLabel.text = NSLocalizedString(@"education.slide8a.header", nil);
    
    self.contentBlock1Label.text = NSLocalizedString(@"education.slide8a.block1.header", nil);
    self.headerContentBlock2Label.text = NSLocalizedString(@"education.slide8a.block2.header", nil);
    self.headerContentBlock3Label.text = NSLocalizedString(@"education.slide8a.block3.header", nil);
    
    self.contentBlock2Label.text = NSLocalizedString(@"education.slide8a.block2.content", nil);
    self.contentBlock3Label.text = NSLocalizedString(@"education.slide8a.block3.content", nil);
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
