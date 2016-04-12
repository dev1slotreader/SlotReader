//
//  SlotPickerView.h
//  SlotReader
//
//  Created by User on 4/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlotPickerDelegate <NSObject>

- (void) showTheFirstWord;

@end

@interface SlotPickerView : UIPickerView

@property (nonatomic, assign) id pickerDelegate;

@end
