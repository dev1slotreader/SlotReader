//
//  MenuPanelViewController.m
//  SlotReader
//
//  Created by User on 3/29/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "MenuPanelViewController.h"
#import "SWRevealViewController.h"
#import "LanguagesTableViewController.h"
#import "DictionaryTableViewController.h"
#import "InfoViewController.h"


@implementation MenuPanelViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Set the title of navigation bar by using the menu items
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
	//destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
	
	// Set the photo if it navigates to the PhotoView
	if ([segue.identifier isEqualToString:@"segueLanguages"]) {
		UINavigationController *navController = segue.destinationViewController;
		LanguagesTableViewController *languagesController = [navController childViewControllers].firstObject;
		//NSString *photoFilename = [NSString stringWithFormat:@"%@_photo", [menuItems objectAtIndex:indexPath.row]];
		//photoController.photoFilename = photoFilename;
	}
	else if ([segue.identifier isEqualToString:@"segueDictionary"]) {
		UINavigationController *navController = segue.destinationViewController;
		DictionaryTableViewController *dictinaryController = [navController childViewControllers].firstObject;
	}
}

@end
