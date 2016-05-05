//
//  EditableTableViewCell.h
//  SlotReader
//
//  Created by User on 4/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void) setEditable: (BOOL) isEditable;

@end
