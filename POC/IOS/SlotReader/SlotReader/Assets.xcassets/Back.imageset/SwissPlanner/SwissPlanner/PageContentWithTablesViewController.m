//
//  PageContentWithTablesViewController.m
//  SwissPlanner
//
//  Created by User on 4/27/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageContentWithTablesViewController.h"
#import "PrettyTableViewCell.h"

@interface PageContentWithTablesViewController ()

@end

@implementation PageContentWithTablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.dataArray = [NSArray arrayWithObjects:
					  [NSArray arrayWithObjects:@"11", @"200 000", @"50€", nil],
					  [NSArray arrayWithObjects:@"10", @"100 000", @"49€", nil],
					  [NSArray arrayWithObjects:@"9", @"50 000", @"47€", nil],
					  [NSArray arrayWithObjects:@"8", @"25 000", @"45€", nil],
					  [NSArray arrayWithObjects:@"7", @"10 000", @"43€", nil],
					  [NSArray arrayWithObjects:@"6", @"5 000", @"40€", nil],
					  [NSArray arrayWithObjects:@"5", @"2 500", @"35€", nil],
					  [NSArray arrayWithObjects:@"4", @"1 000", @"30€", nil],
					  [NSArray arrayWithObjects:@"3", @"300", @"25€", nil],
					  [NSArray arrayWithObjects:@"2", @"100", @"20€", nil],
					  [NSArray arrayWithObjects:@"1", @"0", @"15€", nil],
					   nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier;
	switch (indexPath.section) {
		case 0:
			reuseIdentifier = @"headerCell";
			break;
		default:
			if ([self.partnerCellsRows containsObject:[NSNumber numberWithInt:indexPath.section]]) {
				reuseIdentifier = @"contentPartnerCell";
			} else if ([self.yourCellsRows containsObject:[NSNumber numberWithInt:indexPath.section]]) {
				reuseIdentifier = @"contentYourCell";
			}else {
				reuseIdentifier = @"contentCell";
			}
			break;
	}
	
	
	PrettyTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	[cell setBackgroundColor:[UIColor clearColor]];
	if (indexPath.section != 0) {
		cell.firstCellItem.text = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:0];
		cell.secondCellItem.text = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:1];
		cell.thirdCellItem.text = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:2];
    } else {
        cell.firstCellItem.text = NSLocalizedString(@"prettyTable.firstCellItem", nil);
        cell.secondCellItem.text = NSLocalizedString(@"prettyTable.secondCellItem", nil);
        cell.thirdCellItem.text = NSLocalizedString(@"prettyTable.thirdCellItem", nil);
    }
	
	return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 12;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height;
	switch (indexPath.section) {
		case 0:
			height = ((tableView.frame.size.height - 6) / 13) * 2;
			break;
		default:
			height = ((tableView.frame.size.height - 6) / 13);
			break;
	}
	return height;
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
