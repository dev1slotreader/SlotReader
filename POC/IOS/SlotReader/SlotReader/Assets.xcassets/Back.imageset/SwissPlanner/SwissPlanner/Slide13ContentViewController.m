//
//  Slide13ContentViewController.m
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import "Slide13ContentViewController.h"

@interface Slide13ContentViewController () {
	NSArray *dataArray;
}

@end

@implementation Slide13ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerBlockLabel.text = NSLocalizedString(@"education.slide13.header", nil);
    self.headerContentBlockLabel.text = NSLocalizedString(@"education.slide13.headerContent", nil);
    
	dataArray = [NSArray arrayWithObjects:
				 [NSArray arrayWithObjects:@"11", @"€1 x 100 000e = €100 000", nil],
				 [NSArray arrayWithObjects:@"10", @"€2 x 50 000e = €100 000", nil],
				 [NSArray arrayWithObjects:@"9", @"€2 x 25 000e = €50 000", nil],
				 [NSArray arrayWithObjects:@"8", @"€2 x 15 000e = €30 000", nil],
				 [NSArray arrayWithObjects:@"7", @"€3 x 5 000e = €15 000", nil],
				 [NSArray arrayWithObjects:@"6", @"€5 x 2 500e = €12 500", nil],
				 [NSArray arrayWithObjects:@"5", @"€5 x 1 500e = €7 500", nil],
				 [NSArray arrayWithObjects:@"4", @"€5 x 700e = €3 500", nil],
				 [NSArray arrayWithObjects:@"3", @"€5 x 200e = €1 000", nil],
				 [NSArray arrayWithObjects:@"2", @"€5 x 100e = €500", nil],
				 [NSArray arrayWithObjects:@"1", nil],
				  nil];
}

- (void)setSpecificViews {
	//self.secondTableHeight.constant = self.firstTableView.frame.size.height - (self.firstTableView.frame.size.height - 6)/11;
	//self.topAligment.constant = (self.firstTableView.frame.size.height - 6)/22;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = @"contentCell";
	
	PrettySimpleTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	[cell setBackgroundColor:[UIColor clearColor]];
	if (aTableView.tag == 0) {
		cell.contentLabel.text = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:0];
	} else {
		cell.contentLabel.text = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:1];
	}
	
	return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView.tag == 0) {
		return 11;
	}
	return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.tag == 0) {
		return ((tableView.frame.size.height - 6) / 11);
	}
	return ((tableView.frame.size.height - 6) / 10);
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
