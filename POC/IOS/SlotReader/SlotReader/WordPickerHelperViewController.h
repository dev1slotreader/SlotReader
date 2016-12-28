//
//  WordPickerHelperViewController.h
//  SlotReader
//
//  Created by User on 3/17/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordPickerHelperViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *alphabet;
@property (strong, nonatomic) NSArray *words;
@property (strong, nonatomic) NSNumber *numberOfLettersToShow;
@property BOOL pickerWorkingAutomatically;
@property BOOL lightTheme;

- (void) setNumberOfLettersToShow:(NSNumber *)numberOfLetters andLanguage: (NSString *) language;
- (void) reloadData;

- (void) addNewLetterToAlphabet: (NSString *)letter;
- (void) removeTheLetterFromAlphabet: (NSString *)letter;

@end
