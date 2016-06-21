//
//  GiftsViewController.m
//  SwissPlanner
//
//  Created by User on 4/13/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "GiftsViewController.h"
#import "SWRevealViewController.h"
#import "PlatformTypeChecker.h"

@interface GiftsViewController ()

@end

@implementation GiftsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)"]];
    [self updateViewBackground];
	
	// setting navigation bar
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:nil];
	self.navigationItem.leftBarButtonItem = menuButton;
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(186/255.0)
																			 green:(134/255.0)
																			  blue:(111/255.0)
																			 alpha:1]];
	
	// setting slide menu view controller
	SWRevealViewController *revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		[self.navigationItem.leftBarButtonItem setTarget: self.revealViewController];
		[self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // during rotation
        [self updateViewBackground];
    } completion:^(id  _Nonnull context) {
        
        // after rotation
    }];
}

- (void) updateViewBackground {
    NSString *platform = [PlatformTypeChecker platformType];
    if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]||[platform isEqualToString:@"Simulator"]) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)_iphone6"]];
        
        UIImage *back = [[UIImage imageNamed:@"nav_bar_iphone6"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [self.navigationController.navigationBar setBackgroundImage:back forBarMetrics:UIBarMetricsDefault];
        
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
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
