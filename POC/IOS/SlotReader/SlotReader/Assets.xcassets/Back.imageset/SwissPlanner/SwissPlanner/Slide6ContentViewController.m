//
//  Slide6ContentViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide6ContentViewController.h"

@interface Slide6ContentViewController ()

@end

@implementation Slide6ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.yourCellsRows = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:9], nil];
	self.partnerCellsRows = [NSMutableArray arrayWithCapacity:0];
}

- (void) setSpecificViews {
    
    self.headerBlockLabel.text = NSLocalizedString(@"education.slide6.header", nil);
    
    self.contentBlock1Label.text = NSLocalizedString(@"education.slide6.block1.header", nil);
    self.headerContentBlock2Label.text = NSLocalizedString(@"education.slide6.block2.header", nil);
    self.headerContentBlock3Label.text = NSLocalizedString(@"education.slide6.block3.header", nil);
    
    self.contentBlock2Label.text = NSLocalizedString(@"education.slide6.block2.content", nil);
    self.contentBlock3Label.text = NSLocalizedString(@"education.slide6.block3.content", nil);
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
