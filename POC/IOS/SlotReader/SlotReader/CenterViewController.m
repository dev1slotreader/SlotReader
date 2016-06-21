//
//  ViewController.m
//  SlotReader
//
//  Created by User on 3/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "CenterViewController.h"
#import "WordPickerHelperViewController.h"
#import "MenuPanelViewController.h"
#import "DataMiner.h"
#import "FancyTextInputBlock.h"

@import QuartzCore;

typedef enum {
	reverseDirection,
	nornalDirection
}buttonDirection;

typedef enum {
	green,
	light,
	dark
} BoardScheme;

@interface CenterViewController () <MenuPanelViewControllerDelegate, UIDynamicAnimatorDelegate, SlotPickerDelegate>{
	WordPickerHelperViewController *pickerHelper;
	SWRevealViewController *revealViewController;
	MenuPanelViewController *menuPanelViewController;
	NSDictionary *allWordsForCurrentLanguage;
	
	int currentNumberOfLetters;
	AppDelegate *appDelegate;
	NSArray *numberPickerCellIds;
}

@end

@implementation CenterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	appDelegate.languageSelectorDelegate = self;
	appDelegate.themeSelectorDelegate = self;
	
	pickerHelper = [[WordPickerHelperViewController alloc] init];
	menuPanelViewController = [[MenuPanelViewController alloc] init];
	self.picker.pickerDelegate = self;
	self.picker.delegate = pickerHelper;
	self.picker.dataSource = pickerHelper;
	
	
	[self setStyleFromSettings];

	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1]];
	self.navigationItem.title = @"ABC Reader";
	
	currentNumberOfLetters = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPositon"] objectAtIndex:0] intValue];	
		
	revealViewController = self.revealViewController;
	if ( revealViewController )
	{
		
		[self.showMenuButton setTarget: self.revealViewController];
		[self.showMenuButton setAction: @selector( revealToggle: )];
		[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	}
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self showTheFirstWord];
	});
	//[self addingNumberOfLettersBar];
	
	numberPickerCellIds = [[NSArray alloc] initWithObjects:@"cCell1", @"cCell3", @"cCell4", @"cCell5", @"cCell5+", nil];
	self.collectionView.backgroundColor = [UIColor clearColor];
}

/*
- (void) addingNumberOfLettersBar {
	UIImage *image1 = [UIImage imageNamed:@"1"];
	UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
	button1.backgroundColor = [UIColor redColor];
	[button1 setImage:image1 forState:UIControlStateNormal];
	UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
	barButtonItem1.tag = 1;
	
	UIImage *image3 = [UIImage imageNamed:@"3"];
	UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithImage:image3 style:UIBarButtonItemStylePlain target:nil action:@selector(changeNumberOfLettersToShow:)];
	barButtonItem3.tintColor = [UIColor redColor];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_add_white"] style:UIBarButtonItemStylePlain target:self action:@selector(changeNumberOfLettersToShow:)];
	
	barButtonItem3.tag = 3;
	
	UIImage *image4 = [UIImage imageNamed:@"4"];
	UIBarButtonItem *barButtonItem4 = [[UIBarButtonItem alloc] initWithImage:image4 style:UIBarButtonItemStylePlain target:nil action:@selector(changeNumberOfLettersToShow:)];
	barButtonItem4.tag = 4;
	
	UIImage *image5 = [UIImage imageNamed:@"5"];
	UIBarButtonItem *barButtonItem5 = [[UIBarButtonItem alloc] initWithImage:image5 style:UIBarButtonItemStylePlain target:nil action:@selector(changeNumberOfLettersToShow:)];
	barButtonItem5.tag = 5;
	
	UIImage *image5p = [UIImage imageNamed:@"5+"];
	UIBarButtonItem *barButtonItem5p = [[UIBarButtonItem alloc] initWithImage:image5p style:UIBarButtonItemStylePlain target:nil action:@selector(changeNumberOfLettersToShow:)];
	barButtonItem5p.tag = 0;
	
	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	NSArray *toolbarItems = [NSArray arrayWithObjects:item, flexibleItem, barButtonItem3, flexibleItem, barButtonItem4, flexibleItem, barButtonItem5, flexibleItem, barButtonItem5p, nil];
	

	self.toolbar.items = toolbarItems;
	[self.toolbar updateConstraints];
}*/

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	appDelegate.languageSelectorDelegate = self;
	appDelegate.themeSelectorDelegate = self;
}

- (void) viewDidAppear:(BOOL)animated{
	[self getDataFromStorage];
	[self showTheFirstWord];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Getting data

- (void) getDataFromStorage {
	allWordsForCurrentLanguage = [[DataMiner sharedDataMiner] getWords];
	self.alphabet = [[DataMiner sharedDataMiner] getWordsOfSize:1];
}

- (void) setStyleFromSettings {
	NSNumber *colorScheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"colorScheme"];
	switch ([colorScheme integerValue]) {
		case green:
			pickerHelper.lightTheme = NO;
			break;
		case light:
			pickerHelper.lightTheme = YES;
			break;
		case dark:
			pickerHelper.lightTheme = NO;
			break;
		default:
			break;
	}
	[self.view setNeedsDisplay];
	[self.picker reloadAllComponents];
}

#pragma mark - Displaying letters and words

- (void) setNumberOfLetters:(NSNumber *)numberOfLetters andLanguage: (NSString *) language {
	[pickerHelper setNumberOfLettersToShow:numberOfLetters andLanguage:nil];
	[self.picker reloadAllComponents];
	//[self showTheFirstWord];
}

- (void) displayWord:(NSString *)word animated:(BOOL)animated {
	if (currentNumberOfLetters == 0) {
		[self setNumberOfLetters:[NSNumber numberWithInteger:[word length]] andLanguage:nil];
	}
	pickerHelper.pickerWorkingAutomatically = YES;
	for (NSUInteger i = 0; i < [word length]; i++) {
		NSString *letter = [NSString stringWithFormat:@"%@", [word substringWithRange:NSMakeRange(i, 1)]];		
		[self displayLetter:letter
				atComponent:i
				   animated:animated];
	}
	pickerHelper.pickerWorkingAutomatically = NO;
}

- (void) displayLetter:(NSString *)letter atComponent:(NSUInteger)component animated:(BOOL)animated {
	NSUInteger row;
	if (animated){
		NSUInteger selectedRow = [self.picker selectedRowInComponent:component];
		//row = selectedRow + ([self.alphabet count] - selectedRow % [self.alphabet count]) + [self.alphabet indexOfObject:letter];
		row = [self.alphabet count] + [self.alphabet indexOfObject:letter];
	}
	else
		row = ((UINT16_MAX) / (2 * [self.alphabet count]) * [self.alphabet count]) + [self.alphabet indexOfObject:letter];
	[self.picker selectRow:row
					 inComponent:component
						animated:animated];
}

- (IBAction)wordChanged:(id)sender {

}


- (IBAction)changeNumberOfLettersToShow:(id)sender {
	int numberOfLetters = (int)((UIBarButtonItem *)sender).tag;
	switch (numberOfLetters) {
    case 0:
		//[self setNumberOfLetters:[NSNumber numberWithInt: 10] andLanguage:nil];
		currentNumberOfLetters = 0;
		break;
    default:
		[self setNumberOfLetters:[NSNumber numberWithInt: numberOfLetters] andLanguage:nil];
			currentNumberOfLetters = numberOfLetters;
		break;
	}
	[self showTheFirstWord];
	
}

- (IBAction)presentNextWord:(id)sender {
	int currentWordPosition = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentPositon"] objectAtIndex:1] intValue];
	NSArray *words = [allWordsForCurrentLanguage objectForKey:[NSString stringWithFormat:@"%@%d",
															   [[NSUserDefaults standardUserDefaults] objectForKey:@"language"],
															   currentNumberOfLetters]];
	
	if ([(UIButton *)sender tag] == nornalDirection) {
		currentWordPosition = (currentWordPosition + 1) % [words count] ;
		NSLog(@"next");
	}
	else {
		currentWordPosition = (currentWordPosition - 1 + [words count]) % [words count] ;
		NSLog(@"previous");
	}
	
	[self displayWord:[[[words objectAtIndex:currentWordPosition] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString] animated:YES];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:
                                                      [NSNumber numberWithInt:currentNumberOfLetters],
													  [NSNumber numberWithInt:currentWordPosition], nil]
                                                      forKey:@"currentPositon"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) showTheFirstWordForNumberOfLetters: (int) numberOfLetters{
	}


- (void) showTheFirstWord {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:currentNumberOfLetters], [NSNumber numberWithInt:0], nil] forKey:@"currentPositon"];
	NSArray *words = [allWordsForCurrentLanguage objectForKey:[NSString stringWithFormat:@"%@%d",
															   [[NSUserDefaults standardUserDefaults] objectForKey:@"language"],
															   currentNumberOfLetters]];
	[self displayWord:[[[words objectAtIndex:0] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] animated:YES];
}

- (void) changeLanguage {
	[pickerHelper reloadData];
	[self.picker reloadAllComponents];
	[self.view setNeedsDisplay];
	NSLog(@"changeLanguage");
}

- (void) changeBoardTheme {
	[self setStyleFromSettings];
	[self.view setNeedsDisplay];
	NSLog(@"changeBoardTheme");
}

- (void) viewWillDisappear:(BOOL)animated {
	appDelegate.languageSelectorDelegate = nil;
	appDelegate.themeSelectorDelegate = nil;
	[super viewWillDisappear:animated];
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

@end
