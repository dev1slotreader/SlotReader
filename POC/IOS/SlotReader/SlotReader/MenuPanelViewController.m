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

#define NUMBER_OF_LANGUAGES 10
#define NUMBER_OF_THEMES 3

#define LANGUAGES_START 2
#define THEMES_START 13

typedef enum {
	classicTheme,
	darkTheme,
	lightTheme
}boardThemes;

typedef enum {
	basic,
	languagesFocused,
	themesFocused
}boardStates;

@implementation MenuPanelViewController {
	NSInteger numberOfCellsHidden;
	NSInteger menuMode;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	numberOfCellsHidden = NUMBER_OF_THEMES + NUMBER_OF_LANGUAGES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Set the title of navigation bar by using the menu items
	//NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	//UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;

		if ([segue.identifier isEqualToString:@"segueDictionary"]) {
		//UINavigationController *navController = segue.destinationViewController;
		//DictionaryTableViewController *dictinaryController = [navController childViewControllers].firstObject;
	}
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [super tableView:tableView numberOfRowsInSection:section] - numberOfCellsHidden;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	indexPath = [self offsetIndexPath:indexPath];
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath*)offsetIndexPath:(NSIndexPath*)indexPath
{
	int numberOfCellsHiddenAbove = 0;
	if (menuMode == basic) {
		switch (indexPath.row) {
			case LANGUAGES_START:
				numberOfCellsHidden += NUMBER_OF_LANGUAGES;
				break;
			case THEMES_START:
				numberOfCellsHidden += NUMBER_OF_THEMES;
				break;
			default:
				break;
		}
	}
	int offsetRow = indexPath.row + numberOfCellsHiddenAbove;
	
	return [NSIndexPath indexPathForRow:offsetRow inSection:indexPath.section];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 1:
			[self performSegueWithIdentifier:@"segueDictionary" sender:self];
			break;
		case LANGUAGES_START:
			menuMode = languagesFocused;
			break;
		case THEMES_START:
			menuMode = themesFocused;
			break;
		default:
			menuMode = basic;
			break;
	}
}

- (void)changeState
{
	// Change state so cells are hidden/unhidden
	//...
	
	// Reload all sections
	NSIndexSet* reloadSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView])];
	
	[self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView reloadData];
}

@end
