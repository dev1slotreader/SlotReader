//
//  PageContentWithMultipleTablesViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "PageContentWithMultipleTablesViewController.h"
#import "PrettyTableViewCell.h"

@interface PageContentWithMultipleTablesViewController ()

@end

@implementation PageContentWithMultipleTablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationController.navigationBar.opaque = NO;
	self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier;
	switch (aTableView.tag) {
		case 0:
			if ([self.partnerCellsRows containsObject:[NSNumber numberWithInt:indexPath.section]]) {
				reuseIdentifier = @"contentPartnerCell";
			} else if ([self.yourCellsRows containsObject:[NSNumber numberWithInt:indexPath.section]]) {
				reuseIdentifier = @"contentYourCell";
			}else {
				reuseIdentifier = @"contentCell";
			}
			break;
		case 1:
			if (indexPath.section == 0) {
				reuseIdentifier = @"importantContentCell";
			} else {
				reuseIdentifier = @"contentCell";
			}
			break;
		case 2:
			reuseIdentifier = @"cell";
			break;
		default:
			break;
	}
	
	
	
	PrettyTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	[cell setBackgroundColor:[UIColor clearColor]];
	if (aTableView.tag == 0) {
		//if (indexPath.section != 0) {
			cell.firstCellItem.text = [[self.dataArray objectAtIndex:(indexPath.section )] objectAtIndex:0];
			cell.secondCellItem.text = [[self.dataArray objectAtIndex:(indexPath.section )] objectAtIndex:1];
			cell.thirdCellItem.text = [[self.dataArray objectAtIndex:(indexPath.section )] objectAtIndex:2];
		//}
    } else {
        if ([reuseIdentifier isEqualToString: @"importantContentCell"]) {
            cell.firstCellItem.text = NSLocalizedString(@"simpleTable.firstCellItem", nil);
        } else if ([reuseIdentifier isEqualToString: @"contentCell"]) {
            cell.firstCellItem.text = NSLocalizedString(@"simpleTable.secondCellItem", nil);
        }
    }
	
	return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView.tag == 2) {
		return 11;
	}
	return 11;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = ((tableView.frame.size.height - 6) / 12);
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
