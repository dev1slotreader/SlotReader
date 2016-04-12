//
//  DictationViewController.m
//  SlotReader
//
//  Created by User on 4/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "DictationViewController.h"
#import "DataMiner.h"

@interface DictationViewController () {
	DataMiner *dataMiner;
	NSInteger numberOfLetters;
	NSMutableArray *words;
}

@end

@implementation DictationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	numberOfLetters = 1;
	dataMiner = [DataMiner sharedDataMiner];
	words = [[NSMutableArray alloc] initWithArray:[dataMiner getWordsOfSize:numberOfLetters]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [words count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	cell.textLabel.text = [words objectAtIndex:indexPath.row];
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeNumberOfLetters:(id)sender {
	numberOfLetters = (int)((UIBarButtonItem *)sender).tag;
	[self.view setNeedsDisplay];
}
@end
