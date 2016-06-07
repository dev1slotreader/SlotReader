//
//  DictationViewController.m
//  SlotReader
//
//  Created by User on 4/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "DictationViewController.h"
#import "DataMiner.h"
#import "SWRevealViewController.h"
#import "EditableTableViewCell.h"
#import "UIView+Toast.h"

#define kOFFSET_FOR_KEYBOARD 80.0

typedef enum {
	base,
	adding,
	deleting,
	preChanging,
	changing
}EditingMode;

typedef enum {
	negative,
	positive
}ButtonTypes;

@interface DictationViewController () {
	DataMiner *dataMiner;
	NSInteger numberOfLetters;
	NSMutableArray *words;
	SWRevealViewController *revealViewController;
	AppDelegate *appDelegate;
	EditingMode editingMode;
	NSArray *numberPickerCellIds;
	NSIndexPath *lastSelectedCellIndexPath;
	NSString *wordBuffer;
}


@end

@implementation DictationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.cellSelectionCounter = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	editingMode = base;
	[self updateEditingInterface];
	
	[self addObserver:self forKeyPath:@"cellSelectionCounter" options:NSKeyValueObservingOptionNew context:nil];
	self.positiveButton.layer.cornerRadius = self.positiveButton.frame.size.width / 2;
	self.negativeButton.layer.cornerRadius = self.negativeButton.frame.size.width / 2;
	
	CALayer *border = [CALayer layer];
	CGFloat borderWidth = 2;
	border.borderColor = [UIColor whiteColor].CGColor;
	border.frame = CGRectMake(0, _textField.frame.size.height - borderWidth, _textField.frame.size.width, _textField.frame.size.height);
	border.borderWidth = borderWidth;
	[_textField.layer addSublayer:border];
	_textField.layer.masksToBounds = YES;
	
	numberOfLetters = 1;
	[self getDataFromSource];
	self.tableView.frame = self.view.bounds;
	
	self.textField.delegate = self;
	
	revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		
		[self.showMenuButton setTarget: self.revealViewController];
		[self.showMenuButton setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
	
	appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	appDelegate.languageSelectorDelegate = self;
	
	numberPickerCellIds = [[NSArray alloc] initWithObjects:@"cCell1", @"cCell3", @"cCell4", @"cCell5", @"cCell5+", nil];
	self.collectionView.backgroundColor = [UIColor clearColor];
	
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1]];
	[self.navigationItem setTitle:@"Dictionary"];
}

- (void) updateEditingInterface {
	switch (editingMode) {
		case base:
			[self.positiveButton setImage:[UIImage imageNamed:@"ic_add_white"] forState:UIControlStateNormal];
			[self.negativeButton setImage:[UIImage imageNamed:@"ic_delete_white"] forState:UIControlStateNormal];
			self.tableView.multipleTouchEnabled = NO;
			break;			
		case preChanging:
			[self.positiveButton setImage:[UIImage imageNamed:@"ic_edit_white"] forState:UIControlStateNormal];
			[self.negativeButton setImage:[UIImage imageNamed:@"ic_delete_white"] forState:UIControlStateNormal];
			self.tableView.multipleTouchEnabled = NO;
			break;
		case changing:
		case adding:
			[self.positiveButton setImage:[UIImage imageNamed:@"ic_done_white"] forState:UIControlStateNormal];
			[self.negativeButton setImage:[UIImage imageNamed:@"ic_clear_white"] forState:UIControlStateNormal];
			self.tableView.multipleTouchEnabled = NO;
			break;
		case deleting:
			[self.positiveButton setImage:[UIImage imageNamed:@"ic_done_white"] forState:UIControlStateNormal];
			[self.negativeButton setImage:[UIImage imageNamed:@"ic_clear_white"] forState:UIControlStateNormal];
			self.tableView.multipleTouchEnabled = YES;
			break;
		default:
			break;
	}
}


- (void) viewWillDisappear:(BOOL)animated {
	appDelegate.languageSelectorDelegate = nil;
	[self removeObserver:self forKeyPath:@"cellSelectionCounter"];
	[super viewWillDisappear:animated];
}

- (void) getDataFromSource {
	dataMiner = [DataMiner sharedDataMiner];
	words = [[NSMutableArray alloc] initWithArray:[dataMiner getWordsOfSize:(int)numberOfLetters]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [words count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	EditableTableViewCell *cell = (EditableTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	cell.textField.text = [words objectAtIndex:indexPath.row];
	[cell.textField setText:[words objectAtIndex:indexPath.row]];
	return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:YES];
	return NO;
}

- (IBAction)changeNumberOfLetters:(id)sender {
	[self setNumberOfLettersTo:(int)((UIBarButtonItem *)sender).tag];
}

- (void) setNumberOfLettersTo: (int) newNumberOfLetters {
    numberOfLetters = newNumberOfLetters;
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:
                                                      [NSNumber numberWithInt:newNumberOfLetters],
                                                      [NSNumber numberWithInt:0], nil]
                                              forKey:@"currentPositon"];
    [self getDataFromSource];
    [self.tableView reloadData];
}

- (IBAction)addNewWord:(id)sender {
	
	
}

- (IBAction)insertNewWordIntoBase:(id)sender {
	DataMiner *dataMiner = [DataMiner sharedDataMiner];
	[dataMiner addNewWord:self.textField.text toIndex:nil];
	self.fancyTextInputBlock.hidden = YES;
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Success"
										  message:@"New word was added"
										  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction
							   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction *action)
							   {
								   NSLog(@"OK action");
							   }];
	[alertController addAction:okAction];
	[self presentViewController:alertController animated:YES completion:nil];
	[self.tableView reloadData];
}

- (IBAction)editingButtonClicked:(UIButton *)sender {
	switch (editingMode) {
		case base:
			switch (sender.tag) {
				case positive:
					editingMode = adding;
					self.fancyTextInputBlock.hidden = NO;
					break;
				case negative:
					editingMode = deleting;
					self.tableView.allowsMultipleSelection = YES;
					break;
				default:
					break;
			}
			break;
		case adding:
			switch (sender.tag) {
				case positive:
					editingMode = base;
					if (![self.textField.text isEqualToString: @""]) {
                        NSString *newWord = self.textField.text;
						if([dataMiner addNewWord:newWord toIndex:nil]) {
                            [self setNumberOfLettersTo:[newWord length]];
                            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[[dataMiner getWordsOfSize:[newWord length]] indexOfObject:newWord] inSection:0];
                            [self.tableView selectRowAtIndexPath: newIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                            
							[self.view makeToast:@"New word added"];
						} else {
							[self.view makeToast:@"Error while adding the word"];
						}
					}
					
					break;
				case negative:
					editingMode = base;
					break;
				default:
					break;
			}
			self.fancyTextInputBlock.hidden = YES;
			break;
		case deleting:
			switch (sender.tag) {
				case positive: {
					editingMode = base;
					NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
					for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
						[indexSet addIndex:indexPath.row];
					}
					if([dataMiner deleteWordsAtIndexes:indexSet]) {
                        [self getDataFromSource];
                        [self.tableView reloadData];
						[self.view makeToast:@"Selected words deleted"];
					} else {
						[self.view makeToast:@"Error while deleting"];
					}
				}
					break;
				case negative:
					editingMode = base;
					break;
				default:
					break;
			}
			self.tableView.allowsMultipleSelection = NO;
			_cellSelectionCounter = 0;
			break;
		case preChanging:
			switch (sender.tag) {
				case positive: {
					EditableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastSelectedCellIndexPath];
					wordBuffer = [NSString stringWithString:cell.textField.text];
					cell.textField.userInteractionEnabled = YES;
					[cell.textField becomeFirstResponder];
					}
					editingMode = changing;
					break;
				case negative:
					editingMode = base;
					break;
				default:
					break;
			}
			break;
		case changing: {
			EditableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:lastSelectedCellIndexPath];
			cell.textField.userInteractionEnabled = NO;
			
			switch (sender.tag) {
                case positive: {
                    NSString *newWord = cell.textField.text;
                    if([dataMiner deleteWordsAtIndexes:[NSIndexSet indexSetWithIndex:lastSelectedCellIndexPath.row]]) {
                        NSNumber *newIndex;
                        if ([wordBuffer length]!=[newWord length]) {
                            
                            [self setNumberOfLettersTo:[newWord length]];
                            newIndex = [NSNumber numberWithInteger:[[dataMiner getWords] count]];
                        } else {
                            newIndex = [NSNumber numberWithInteger:lastSelectedCellIndexPath.row];
                        }
                        [dataMiner addNewWord:newWord toIndex:newIndex];
                        [self getDataFromSource];
                        [self.tableView reloadData];
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:newIndex.integerValue inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                        [self.view makeToast:@"The word is updated"];
                    } else {
                        [self.view makeToast:@"Error while word updating"];
                }
                    editingMode = base;
                    }
					break;
				case negative:
					cell.textField.text = wordBuffer;
					editingMode = base;
					break;
				default:
					break;
			};
			
			wordBuffer = nil;
			break;
		}
	}
	[self updateEditingInterface];
	[self.view setNeedsDisplay];
}

- (void) changeLanguage {
	[self getDataFromSource];
	[self.tableView reloadData];
	
	NSLog(@"changeLanguage");
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	lastSelectedCellIndexPath = indexPath;
	UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	if (editingMode == deleting) {
		self.cellSelectionCounter ++;
	}
	else {
		self.cellSelectionCounter = 0;
		editingMode = preChanging;
		[self updateEditingInterface];
	}
	
	
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingMode == deleting) {
		self.cellSelectionCounter --;
	} else {
		editingMode = base;
		[self updateEditingInterface];
	}
	
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	if (editingMode == deleting) {
		switch (self.cellSelectionCounter) {
			case 0:
				break;
			case 1:
				break;
			default:
				break;
		}
	}
}


#pragma mark - Collection View Delegate Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [numberPickerCellIds count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellId = [numberPickerCellIds objectAtIndex:indexPath.row];
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
	
	return cell;
	
}

#pragma mark - Text Field Delegate Method

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.fancyTextInputBlock.frame = CGRectMake(_fancyTextInputBlock.frame.origin.x, (_fancyTextInputBlock.frame.origin.y + 100.0), _fancyTextInputBlock.frame.size.width, _fancyTextInputBlock.frame.size.height);
	self.fancyTextInputBlockYPosition.constant = 0.7;
	[UIView commitAnimations];
	
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	_fancyTextInputBlock.frame = CGRectMake(_fancyTextInputBlock.frame.origin.x, (_fancyTextInputBlock.frame.origin.y - 100.0), _fancyTextInputBlock.frame.size.width, _fancyTextInputBlock.frame.size.height);
	self.fancyTextInputBlockYPosition.constant = 1;
	[UIView commitAnimations];

}

@end
