//
//  ConclusionTableViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Boychuk. All rights reserved.
//

#import "ConclusionTableViewController.h"
#import "PrettyExpandedTableViewCell.h"

typedef enum {
	mainTable,
	preVipTable,
	VipTable,
	preVipPlusTable,
	vipPlusTable
}TableType;

@interface ConclusionTableViewController () {
	TableType currentTableType;
	NSArray *cellNames;
}

@end

@implementation ConclusionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentTableType = mainTable;
	
    cellNames = [NSArray arrayWithObjects:
                 [NSString stringWithFormat:NSLocalizedString(@"calculator.order.mainOrder", nil)],
                 [NSString stringWithFormat:NSLocalizedString(@"calculator.order.preVipOrder", nil)],
                 [NSString stringWithFormat:NSLocalizedString(@"calculator.order.vipOrder", nil)],
                 [NSString stringWithFormat:NSLocalizedString(@"calculator.order.preVipPlusOrder", nil)],
                 [NSString stringWithFormat:NSLocalizedString(@"calculator.order.vipPlusOrder", nil)],
                 nil];
    /*cellNames = [NSArray arrayWithObjects:
                 @"1",
                 @"2",
                 @"3",
                 @"4",
                 @"5",
                 nil];*/
    
    self.headerBlockLabel.text = NSLocalizedString(@"education.slideConclusion.header", nil);
	
	self.baseDataArray = [NSArray arrayWithObjects:
						  [NSArray arrayWithObjects:@"1", @"-", @"€15", nil],
						  [NSArray arrayWithObjects:@"2", @"100", @"€20", nil],
						  [NSArray arrayWithObjects:@"3", @"300", @"€25", nil],
						  [NSArray arrayWithObjects:@"4", @"1 000", @"€30", nil],
						  [NSArray arrayWithObjects:@"5", @"2 500", @"€35", nil],
						  [NSArray arrayWithObjects:@"6", @"5 000", @"€40", nil],
						  [NSArray arrayWithObjects:@"7", @"10 000", @"€43", nil],
						  [NSArray arrayWithObjects:@"8", @"25 000", @"€45", nil],
						  [NSArray arrayWithObjects:@"9", @"50 000", @"€47", nil],
						  [NSArray arrayWithObjects:@"10", @"100 000", @"€49", nil],
						  [NSArray arrayWithObjects:@"11", @"200 000", @"€50", nil],
						  nil];
	self.extraDataArray = [NSArray arrayWithObjects:
						  [NSArray arrayWithObjects:@"56.70", @"32.40", @"222.75", @"112.05", @"793,80", nil],
						  [NSArray arrayWithObjects:@"75.60", @"43.20", @"297", @"149.40", @"1058.40", nil],
						  [NSArray arrayWithObjects:@"94.50", @"54", @"371.25", @"186.75", @"1323", nil],
						  [NSArray arrayWithObjects:@"113.40", @"64.80", @"445.50", @"224.10", @"1 058.40", nil],
						  [NSArray arrayWithObjects:@"132.30", @"75.60", @"519.75", @"261.45", @"1 852.20", nil],
						  [NSArray arrayWithObjects:@"151.20", @"86.40", @"594", @"298.80", @"2 116.80", nil],
						  [NSArray arrayWithObjects:@"162.54", @"92.88", @"638.55", @"321.21", @"2 275.56", nil],
						  [NSArray arrayWithObjects:@"170.10", @"97.20", @"668.25", @"336.15", @"2 381.40", nil],
						  [NSArray arrayWithObjects:@"177.66", @"101.52", @"697.95", @"351.09", @"2 487.24", nil],
						  [NSArray arrayWithObjects:@"185.22", @"105.84", @"727.65", @"366.03", @"2 593.08", nil],
						  [NSArray arrayWithObjects:@"189", @"108", @"742.50", @"373.50", @"2 646", nil],
						  nil];
	/*
    for (int i; i < [cellNames count]; i++) {
        [self.segmentedControl setTitle:cellNames[i] forSegmentAtIndex:i];
        NSLog(@"%@", cellNames[i]);
    } */
    
	for (id segment in [self.segmentedControl subviews]) {
        
		for (id label in [segment subviews]) {
			if ([label isKindOfClass:[UILabel class]]) {
				UILabel *titleLabel = (UILabel *) label;
				titleLabel.numberOfLines = 0;
                //titleLabel.text = cellNames[i];
			}
		}
        
	}
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tableTypeSelected:(UISegmentedControl *)sender {
	currentTableType = sender.selectedSegmentIndex;
	[self.tableView reloadData];
}

#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier;
	switch (indexPath.section) {
		case 0:
			reuseIdentifier = @"headerCell";
			break;
		default:
			reuseIdentifier = @"contentCell";
			break;
	}
	
	
	PrettyExpandedTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	[cell setBackgroundColor:[UIColor clearColor]];
	if (indexPath.section != 0) {
		cell.firstCellItem.text = [[self.baseDataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:0];
		cell.secondCellItem.text = [[self.baseDataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:1];
		cell.thirdCellItem.text = [[self.baseDataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:2];
		cell.fourthCellItem.text = [[self.extraDataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:currentTableType];
		
		UIColor *firstColor = [UIColor colorWithRed:(254.0/255.0) green:(231.0/255.0) blue:(189.0/255.0) alpha:1];
		UIColor *secondColor = [UIColor colorWithRed:(239.0/255.0) green:(189.0/255.0) blue:(102.0/255.0) alpha:1];
		UIColor *currentRowColor = (indexPath.section % 2) ? firstColor : secondColor;
		
		cell.firstCellItem.backgroundColor = currentRowColor;
		cell.secondCellItem.backgroundColor = currentRowColor;
		cell.thirdCellItem.backgroundColor = currentRowColor;
		cell.fourthCellItem.backgroundColor = currentRowColor;
	} else {
        cell.firstCellItem.text = NSLocalizedString(@"prettyTable.firstCellItem", nil);
        cell.secondCellItem.text = NSLocalizedString(@"prettyTable.secondCellItem", nil);
        cell.thirdCellItem.text = NSLocalizedString(@"prettyTable.thirdCellItem", nil);
		cell.fourthCellItem.text = [cellNames objectAtIndex:currentTableType];
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


@end
