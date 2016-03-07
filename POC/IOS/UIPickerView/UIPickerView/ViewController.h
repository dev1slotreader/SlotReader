//
//  ViewController.h
//  UIPickerView
//
//  Created by User on 3/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *alphabet;
@property (strong, nonatomic) NSArray *colorsArray;

@end

