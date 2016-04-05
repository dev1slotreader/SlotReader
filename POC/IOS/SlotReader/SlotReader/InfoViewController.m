//
//  InfoViewController.m
//  SlotReader
//
//  Created by User on 4/4/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "InfoViewController.h"
#import "SWRevealViewController.h"

@implementation InfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	SWRevealViewController *revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		[self.showMenuButton setTarget: self.revealViewController];
		[self.showMenuButton setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
}

@end
