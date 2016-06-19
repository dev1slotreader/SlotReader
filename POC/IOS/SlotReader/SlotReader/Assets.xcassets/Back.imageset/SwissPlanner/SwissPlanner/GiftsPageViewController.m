//
//  GiftsPageViewController.m
//  SwissPlanner
//
//  Created by User on 4/21/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "GiftsPageViewController.h"
#import "GiftsPageContentViewController.h"
#import "SWRevealViewController.h"

#import "PlatformTypeChecker.h"

#define MAX_NUM 3

typedef enum {
	mainImage,
	labelText
}contentArrayElements;

@interface GiftsPageViewController () {
	NSArray *pageContent;
}

@end

@implementation GiftsPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	pageContent = [NSArray arrayWithObjects:
				   [NSArray arrayWithObjects:@"gift level 1", NSLocalizedString(@"rewards.1Level", nil), nil],
				   [NSArray arrayWithObjects:@"gift level 3", NSLocalizedString(@"rewards.3Level", nil), nil],
                   [NSArray arrayWithObjects:@"gift level 4", NSLocalizedString(@"rewards.4Level", nil), nil],
				   [NSArray arrayWithObjects:@"gift level 5", NSLocalizedString(@"rewards.5Level", nil), nil],
				   [NSArray arrayWithObjects:@"gift level 6", NSLocalizedString(@"rewards.6Level", nil), nil],
                   [NSArray arrayWithObjects:@"gift level 6_1", NSLocalizedString(@"rewards.6Level", nil), nil],
                   [NSArray arrayWithObjects:@"gift level 7-11", NSLocalizedString(@"rewards.7-11Levels", nil), nil],
				   [NSArray arrayWithObjects:@"gift no level", NSLocalizedString(@"rewards.cruise", nil), nil],
				   nil];
	/*
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background(gifts)"]];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];*/
    
    [self updateViewBackground];
    
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	// Create page view controller
	self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
	self.pageViewController.dataSource = self;
    //self.pageViewController.delegate = self;
	
	GiftsPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
	NSArray *viewControllers = @[startingViewController];
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	// Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 5);
	
	
	[self addChildViewController:_pageViewController];
	[self.view addSubview:_pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	
	// setting navigation bar
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:nil];
	self.navigationItem.leftBarButtonItem = menuButton;
	self.navigationController.navigationBar.translucent = NO;
	self.navigationItem.title = NSLocalizedString(@"rewards.title", nil);
	
	SWRevealViewController *revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		[self.navigationItem.leftBarButtonItem setTarget: self.revealViewController];
		[self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
 
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger index = ((GiftsPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger index = ((GiftsPageContentViewController*) viewController).pageIndex;
	
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (GiftsPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
	if (index >= [pageContent count]) {
		return nil;
	}
	// Create a new view controller and pass suitable data.
	GiftsPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftsPageContentController"];
	pageContentViewController.titleText = [[pageContent objectAtIndex:index] objectAtIndex:labelText];	
	pageContentViewController.imageFile = [[pageContent objectAtIndex:index] objectAtIndex:mainImage];
	
	pageContentViewController.pageIndex = index;
	
	return pageContentViewController;
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return [pageContent count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return 0;
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
