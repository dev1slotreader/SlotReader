//
//  MainViewController.m
//  SwissPlanner
//
//  Created by User on 4/11/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "CalculatorViewController.h"

#import "CabinetContentTableViewCell.h"
#import "OrdersTableViewCell.h"

#import "PlatformTypeChecker.h"

@interface MainViewController () {
	NSArray *cellsReuseIdentifiers;
	
    NSString *userName;
    NSNumber *userLevel;
    NSNumber *userPoints;
    NSNumber *pointsLeft;
	BOOL isInLeadershipProgram;
	
	NSArray *levelsPointsArray;
}

@end

typedef enum {
	userNameCell,
	leadershipLevelCell,
	bonusUnitsCell,
	pointsLeftCell,
	deviderCell,
	ordersCell,
	footerCell
}cells;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViewBackground];
	
	// setting navigation bar
    
	UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:nil];
	self.navigationItem.leftBarButtonItem = menuButton;
	
	
	[self.navigationController.navigationBar
	 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	self.navigationItem.title = NSLocalizedString(@"cabinet.title", nil);
	
	// setting slide menu view controller
	SWRevealViewController *revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		[self.navigationItem.leftBarButtonItem setTarget: self.revealViewController];
		[self.navigationItem.leftBarButtonItem setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
	
	cellsReuseIdentifiers = [[NSArray alloc] initWithObjects:
							 @"userNameCell",
							 @"leadershipLevelCell",
							 @"bonusUnitsCell",
							 @"pointsLeftCell",
							 @"deviderCell",
							 @"ordersCell",
							 @"footerCell",
							 nil];
	
	levelsPointsArray = [NSArray arrayWithObjects:@0, @0, @100, @300, @1000, @2500, @5000, @10000, @25000, @50000, @100000, @20000, nil];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:@"userName"];
    userLevel = [defaults objectForKey:@"userLevel"];
    userPoints = [defaults objectForKey:@"userPoints"];
    pointsLeft = [defaults objectForKey:@"pointsLeft"];
	isInLeadershipProgram = [[defaults objectForKey:@"isInLeadershipProgram"] boolValue];
    
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
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_iphone6"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_iphone6"] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (NSInteger) getFontSize {
	NSString *platform = [PlatformTypeChecker platformType];
	if ([platform isEqualToString:@"iPhone 6"]||[platform isEqualToString:@"iPhone 6S"]||[platform isEqualToString:@"iPhone 6 Plus"]||[platform isEqualToString:@"iPhone 6S Plus"]) {
		return 16;
	} else if ([platform isEqualToString:@"iPhone 4"]||[platform isEqualToString:@"iPhone 4S"]||[platform isEqualToString:@"Simulator"]){
		return 10;
	} else {
		return 14;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (tableView.tag) {
  case 0:
			return 5;
			break;
			
  default:
			break;
	}
	return 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height;
	
	switch (tableView.tag) {
		case 0:
			switch (indexPath.row) {
				case ordersCell:
					height = tableView.frame.size.height * 0.20;
					break;
				case footerCell:
					height = tableView.frame.size.height * 0.35;
					break;
				default:
					height = tableView.frame.size.height * 0.18;
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					height = tableView.frame.size.height * 0.35;
					break;
				case 1:
					height = tableView.frame.size.height * 0.65;
					break;
			}
			break;
		default:
			break;
	}
	 return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger number = indexPath.row;
	if (tableView.tag == 1) {
		number += 5;
	}
	NSString *reuseIdentifier = [NSString stringWithString:[cellsReuseIdentifiers objectAtIndex:number]];
	
	
	if (tableView.tag == 0) {
        CabinetContentTableViewCell *cell = (CabinetContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        NSString *cellText;
		NSString *titleText;
		
        switch (indexPath.row) {
            case userNameCell:
				titleText = @"";
                cellText = ([userName length])?userName:NSLocalizedString(@"cabinet.cellcontent.1.placeholder", nil);
                break;
            case leadershipLevelCell:
				titleText = NSLocalizedString(@"cabinet.cellcontent.2.title", nil);
                cellText = (userLevel)?[userLevel stringValue]:@"0";
                break;
            case bonusUnitsCell:
				titleText = NSLocalizedString(@"cabinet.cellcontent.3.title", nil);
                cellText = (isInLeadershipProgram)?[userPoints stringValue]:NSLocalizedString(@"cabinet.cellcontent.2_3.none", nil);
                 break;
            case pointsLeftCell:
				titleText = NSLocalizedString(@"cabinet.cellcontent.4.title", nil);
				cellText = (([userLevel integerValue]<11) && isInLeadershipProgram)?[pointsLeft stringValue]:NSLocalizedString(@"cabinet.cellcontent.2_3.none", nil);
                 break;
            default:
                break;
        }
        if (cellText != nil) {
			NSInteger size = [self getFontSize];
            [cell contentLabel].text = cellText;
			[cell titleLabel].text = titleText;
			//cell.titleLabel.font = [UIFont systemFontOfSize:[self getFontSize]];
        }
		
        return cell;
    } else {
		if (indexPath.row == 0) {
			OrdersTableViewCell *cell = (OrdersTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
			cell.mainOrderLabel.text = NSLocalizedString(@"cabinet.order.mainOrder", nil);
			cell.vipOrderLabel.text = NSLocalizedString(@"cabinet.order.vipOrder", nil);
			cell.vipPlusOrderLabel.text = NSLocalizedString(@"cabinet.order.vipPlusOrder", nil);
			return cell;
		}
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        return cell;
    }
	return nil;
}



#pragma mark - UITextField delegate methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:YES];
	return NO;
}

- (IBAction)openOrderButtonCLicked:(id)sender {
	UITapGestureRecognizer *recogniser = sender;
	
	NSString *segueIdentifier;
	switch (recogniser.view.tag) {
		case 0:
			segueIdentifier = [NSString stringWithFormat:@"segueCabinet1"];
            
			break;
		case 1:
			segueIdentifier = [NSString stringWithFormat:@"segueCabinet2"];
			break;
		case 2:
			segueIdentifier = [NSString stringWithFormat:@"segueCabinet3"];
			break;
  default:
			break;
	}
	[self performSegueWithIdentifier:segueIdentifier sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     CalculatorViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"segueCabinet1"]) {
        vc.selectedPlanNumber = [NSNumber numberWithInt:1];
    } else if ([segue.identifier isEqualToString:@"segueCabinet2"]) {
        vc.selectedPlanNumber = [NSNumber numberWithInt:3];
    } else if ([segue.identifier isEqualToString:@"segueCabinet3"]) {
        vc.selectedPlanNumber = [NSNumber numberWithInt:5];
    }
    vc.viewControllerIsInSecondaryLine = [NSNumber numberWithBool:YES];
}


@end
