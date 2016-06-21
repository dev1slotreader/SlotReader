//
//  SideMenuTableViewController.m
//  SwissPlanner
//
//  Created by User on 4/11/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "SWRevealViewController.h"

#import "PageViewController.h"
#import "MainViewController.h"
#import "CalculatorViewController.h"

@interface SideMenuTableViewController () {
	NSMutableArray *menuItemsContentCollection;
	NSIndexPath *lastSelectedIndexPath;
}

@end

typedef enum {
	logoMenuItem,
	cabinetMenuItem,
	calculatorMenuItem,
	educationMenuItem,
	testingMenuItem,
	settingsMenuItem,
	giftsMenuItem,
	footerMenuItem
}menuItems;

typedef enum {
	cabinet,
	calculator,
	education,
	gifts,
    testing,
	settings,
	swissgolden,
	elenaBoychuk,
	facebook,
	instagram,
	youtube
}allMenuItems;

typedef enum {
	SGSite,
	EBSite,
	FB,
	Skype,
	YouTube
} hyperlinks;


@implementation SideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.alwaysBounceVertical = NO;
	
	lastSelectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		self.edgesForExtendedLayout=UIRectEdgeNone;
		self.extendedLayoutIncludesOpaqueBars=NO;
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
	
	menuItemsContentCollection = [NSMutableArray arrayWithCapacity:0];
	[menuItemsContentCollection insertObject:NSLocalizedString(@"navigation.item.cabinet", nil) atIndex:cabinet];
	[menuItemsContentCollection insertObject:NSLocalizedString(@"navigation.item.calculator", nil) atIndex:calculator];
	[menuItemsContentCollection insertObject:NSLocalizedString(@"navigation.item.education", nil) atIndex:education];
	[menuItemsContentCollection insertObject:NSLocalizedString(@"navigation.item.rewards", nil) atIndex:gifts];
    [menuItemsContentCollection insertObject:NSLocalizedString(@"navigation.item.testing", nil) atIndex:testing];
	[menuItemsContentCollection insertObject:NSLocalizedString(@"navigation.item.settings", nil) atIndex:settings];
	[menuItemsContentCollection insertObject:@"Swissgolden" atIndex:swissgolden];
	[menuItemsContentCollection insertObject:@"Elena Boychuk" atIndex:elenaBoychuk];
	[menuItemsContentCollection insertObject:@"Facebook" atIndex:facebook];
	[menuItemsContentCollection insertObject:@"Instagram" atIndex:instagram];
	[menuItemsContentCollection insertObject:@"YouTube" atIndex:youtube];
	int i = 0;
	for (UILabel *cellLabel in self.titleLabel) {
		cellLabel.text = [menuItemsContentCollection objectAtIndex:i];
		i ++;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView == self.tableView) {
		if (scrollView.contentOffset.y < 0) {
			scrollView.contentOffset = CGPointZero;
		}
	}
}
/*
- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 7;
            //return 6;
			break;
		case 1:
			return 5;
			break;
		default:
			break;
	}
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return 20;
			break;
		default:
			break;
	}
	return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return nil;
			break;
		case 1:
			return [NSString stringWithFormat:@"\t%@", NSLocalizedString(@"navigation.item.section.2", nil)];
			break;
  default:
			break;
	}
	return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height;
	//if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
	switch (indexPath.section) {
			case 0:
			switch (indexPath.row) {
				case logoMenuItem:
					height = self.view.bounds.size.height * 0.45;
					break;
				case footerMenuItem:
					height = self.view.bounds.size.height * 0.15;
					break;
				default:
					height = self.view.bounds.size.height * 0.10;
					break;
			}
			break;
		default:
			height = self.view.bounds.size.height * 0.10;
			break;
	}
	
	//}
	return height;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	// Background color
	view.tintColor = self.tableView.backgroundColor;
	
	// Text Color
	UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
	[header.textLabel setTextColor:[UIColor whiteColor]];
	
	// Another way to set the background color
	// Note: does not preserve gradient effect of original header
	// header.contentView.backgroundColor = [UIColor blackColor];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		switch (indexPath.row) {
			case SGSite:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://swissgolden.com/"]];
				break;
				
			case EBSite:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://elenaboychuk.com/"]];
				break;
			case FB:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/Swissgolden.Inc/?pnref=lhc"]];
				break;
			case Skype:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://www.instagram.com/swissgolden_online_shop/?call"]]];
				break;
			case YouTube:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.youtube.com/user/infoswissgolden"]];
				break;
				
			default:
				break;
		}
	} else {
		if (indexPath.row != logoMenuItem) {
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastSelectedIndexPath];
			cell.backgroundColor = [UIColor colorWithRed:(135/255.0)
												   green:(98/255.0)
													blue:(80/255.0)
												   alpha:1];
			lastSelectedIndexPath = indexPath;
			cell = [self.tableView cellForRowAtIndexPath:indexPath];
			cell.backgroundColor = [UIColor colorWithRed:(215/255.0)
												   green:(148/255.0)
													blue:(92/255.0)
												   alpha:1];
		}
	}
}

- (IBAction)navigateToTheWebSource:(id)sender {
	switch ([(UIButton *)sender tag]) {
  case SGSite:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://swissgolden.com/"]];
			break;
			
  case EBSite:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://elenaboychuk.com/"]];
			break;
  case FB:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/olena.boychuk.1"]];
			break;
  case Skype:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"https://www.instagram.com/swissgolden_online_shop/"]]];
			break;
  case YouTube:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.youtube.com/channel/UCh-pDvDJX8knJQtDRFhiQ7g"]];
			break;

  default:
			break;
	}
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier;
	switch (indexPath.row) {
		case logoMenuItem:
			reuseIdentifier = @"logoMenuCell";
			break;
		case cabinetMenuItem:
			reuseIdentifier = @"cabinetMenuCell";
			break;
		case calculatorMenuItem:
			reuseIdentifier = @"calculatorMenuCell";
			break;
		case educationMenuItem:
			reuseIdentifier = @"educationMenuCell";
			break;
		case testingMenuItem:
			reuseIdentifier = @"testingMenuCell";
			break;
		case giftsMenuItem:
			reuseIdentifier = @"giftsMenuCell";
			break;
		case footerMenuItem:
			reuseIdentifier = @"footerMenuCell";
			break;
		default:
			break;
	}
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
	UIView *back = [UIView new];
	back.backgroundColor = [UIColor colorWithRed:(215/255.0)
										   green:(148/255.0)
											blue:(92/255.0)
										   alpha:1];
	cell.multipleSelectionBackgroundView = back;
    // Configure the cell...
    
    return cell;
}
*/

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
			
	UIView *back = [UIView new];
	back.backgroundColor = [UIColor colorWithRed:(215/255.0)
										   green:(148/255.0)
											blue:(92/255.0)
										   alpha:1];
	cell.selectedBackgroundView = back;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.tableView reloadData];
	[self.view setNeedsDisplay];
	[self.view updateConstraints];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // during rotation
        [self.tableView reloadData];
    } completion:^(id  _Nonnull context) {
        
        // after rotation
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
