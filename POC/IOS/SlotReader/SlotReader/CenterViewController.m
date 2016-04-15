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
	
	[self getDataFromStorage];
	[self setStyleFromSettings];

	self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(181/255.0) green:(252/255.0) blue:(251/255.0) alpha:1]];
	self.navigationItem.title = @"Slot Reader";
	
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
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	appDelegate.languageSelectorDelegate = self;
	appDelegate.themeSelectorDelegate = self;
}

- (void) viewDidAppear:(BOOL)animated{
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Getting data

- (void) getDataFromStorage {
	
#warning No need in it
	NSError *error = nil;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"slot_reader_source" ofType:@"txt"];
	NSURL *url = [NSURL fileURLWithPath:filePath];

	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
															 options:kNilOptions
															   error:&error];
	if (error != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Couldn't load the data"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	} else {
		NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"language"]);
		allWordsForCurrentLanguage = [jsonData objectForKey:@"words"];
		self.alphabet = [NSArray arrayWithArray:[[jsonData objectForKey:@"words"] objectForKey:[NSString stringWithFormat:@"%@1",[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]]]];
		NSLog(@"OK");
	}
}

- (void) setStyleFromSettings {
	NSNumber *colorScheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"colorScheme"];
	switch ([colorScheme integerValue]) {
		case green:
			self.board.image = [UIImage imageNamed:@"Blackboard"];
			pickerHelper.lightTheme = NO;
			break;
		case light:
			self.board.image = [UIImage imageNamed:@"Blackboard-light"];
			pickerHelper.lightTheme = YES;
			break;
		case dark:
			self.board.image = [UIImage imageNamed:@"Blackboard-dark"];
			pickerHelper.lightTheme = NO;
			break;
		default:
			break;
	}
}

#pragma mark - Displaying letters and words

- (void) setNumberOfLetters:(NSNumber *)numberOfLetters andLanguage: (NSString *) language {
	[pickerHelper setNumberOfLettersToShow:numberOfLetters andLanguage:nil];
	[self.picker reloadAllComponents];
	//[self showTheFirstWord];
}

- (void) displayWord:(NSString *)word animated:(BOOL)animated {
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
		row = selectedRow + ([self.alphabet count] - selectedRow % [self.alphabet count]) + [self.alphabet indexOfObject:letter];
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
		[self setNumberOfLetters:[NSNumber numberWithInt: 10] andLanguage:nil];
		currentNumberOfLetters = 10;
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
		currentWordPosition = (currentWordPosition - 1) % [words count] ;
		NSLog(@"previous");
	}
	
	[self displayWord:[[words objectAtIndex:currentWordPosition] uppercaseString] animated:YES];
	//[self displayWord:[words objectAtIndex:currentWordPosition] animated:YES];
#warning be careful here!
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:currentNumberOfLetters],
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
	[self displayWord:[[words objectAtIndex:0] uppercaseString] animated:YES];
	//[self displayWord:[words objectAtIndex:0] animated:YES];
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

@end
