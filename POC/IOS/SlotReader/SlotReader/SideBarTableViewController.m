//
//  SideBarTableViewController.m
//  SlotReader
//
//  Created by User on 4/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "SideBarTableViewController.h"
#import "SWRevealViewController.h"
#import "LanguagesTableViewController.h"
#import "DictionaryTableViewController.h"
#import "InfoViewController.h"

#import "DataMiner.h"

typedef enum {
	categories,
	language,
	boardStyle
} sideBarModeTypes;

typedef enum {
	homeCategory,
	boardThemesCategory,
	languagesCategory,
	dictionaryCategory
} sideBarCategories;

#define NUMBER_OF_STYLES 3

@interface SideBarTableViewController () {
	int sideBarMode;
	NSDictionary *menuCategories;
	NSArray * menuCategoriesTitles;
	NSArray * menuCategoriesImages;
	NSArray * boardStylesNames;
}

@end

@implementation SideBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	sideBarMode = 0;
	menuCategoriesTitles = [NSArray arrayWithObjects:
									   @"Home",
									   @"Board themes",
									   @"Languages",
									   @"Dictonary",
									   nil];
	menuCategoriesImages = [NSArray arrayWithObjects:
									@"ic_home_white",
									@"ic_color_lens_white",
									@"ic_language_white",
									@"ic_book_white",
									nil];
	menuCategories = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"Home", @"ic_home_white",
						  @"Board themes", @"ic_color_lens_white",
						  @"Languages", @"ic_language_white",
						  @"Dictonary", @"ic_book_white",
						  nil];
	boardStylesNames = [NSArray arrayWithObjects:
							@"greenBoard",
							@"lightBoard",
							@"darkBoard",
							nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (sideBarMode) {
    case categories:
			return [menuCategories count];
			break;
    case language:
			return [[[DataMiner sharedDataMiner] getLanguages] count] + 1;
			break;
	case boardStyle:
			return NUMBER_OF_STYLES + 1;
			break;
    default:
			break;
	}
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *text;
	NSString *imageName;
	
	switch (sideBarMode) {
		case categories:
			text = [menuCategoriesTitles objectAtIndex:indexPath.row];
			imageName = [menuCategoriesImages objectAtIndex:indexPath.row];
			break;
		case language:
			if (indexPath.row == 0) {
				text = @"Back";
				imageName = @"ic_arrow_back_white";
			}
			else {
				text = [[[DataMiner sharedDataMiner] getLanguages] objectAtIndex:(indexPath.row - 1)];
				imageName = text;
			}
			break;
		case boardStyle:
			if (indexPath.row == 0) {
				text = @"Back";
				imageName = @"ic_arrow_back_white";
			}
			else {
				imageName = text = [boardStylesNames objectAtIndex:(indexPath.row - 1)];;
			}
			break;
		default:
			break;
	}
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = text;
	cell.imageView.image = [UIImage imageNamed:imageName];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
	
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Set the title of navigation bar by using the menu items
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;	
	
	if ([segue.identifier isEqualToString:@"segueDictionary"]) {
		UINavigationController *navController = segue.destinationViewController;
		DictionaryTableViewController *dictionaryController = [navController childViewControllers].firstObject;
	}
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (sideBarMode == categories) {
		switch (indexPath.row) {
			case homeCategory:
				[self performSegueWithIdentifier:@"segueMain" sender:self];
				break;
			case boardThemesCategory:
#warning show board themes 
				sideBarMode = boardStyle;
				[self.tableView reloadData];
				break;
			case languagesCategory:
#warning show languages
				sideBarMode = language;
				[self.tableView reloadData];
				break;
			case dictionaryCategory:
				[self performSegueWithIdentifier:@"segueDictionary" sender:self];
				break;
			default:
				break;
		}
	}
	else {
		if (indexPath.row == 0) {
#warning write a method to show categories again and set sidebarmode to 0
			sideBarMode = categories;
			[self.tableView reloadData];
		}
		switch (sideBarMode) {
			case categories:
				switch (indexPath.row) {
					case homeCategory:
						[self performSegueWithIdentifier:@"segueMain" sender:self];
						break;
					case boardThemesCategory:
			#warning show board themes
						sideBarMode = boardStyle;
						[self.tableView reloadData];
						break;
					case languagesCategory:
			#warning show languages
						sideBarMode = language;
						[self.tableView reloadData];
						break;
					case dictionaryCategory:
						[self performSegueWithIdentifier:@"segueDictionary" sender:self];
						break;
					default:
						break;
				}
				break;
			case language:
				[[NSUserDefaults standardUserDefaults] setObject:
				 [[[DataMiner sharedDataMiner] getLanguages] objectAtIndex:(indexPath.row - 1)] forKey:@"language"];
				[self.languageSelectorDelegate changeLanguage];
				break;
			case boardStyle:
				[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(indexPath.row - 1)] forKey:@"colorScheme"];
				[self.themeSelectorDelegate changeBoardTheme];
				break;
			default:
				break;
		}
		
	}
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
