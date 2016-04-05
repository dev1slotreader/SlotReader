//
//  WordPickerHelperViewController.h
//  SlotReader
//
//  Created by User on 3/17/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordPickerHelperViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *alphabet;
@property (strong, nonatomic) NSNumber *numberOfLetters;
@property BOOL pickerWorkingAutomatically;
@property BOOL lightTheme;

- (void) setNumberOfLetters:(NSNumber *)numberOfLetters andLanguage: (NSString *) language;

@end
