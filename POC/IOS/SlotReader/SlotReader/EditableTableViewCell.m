//
//  EditableTableViewCell.m
//  SlotReader
//
//  Created by User on 4/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "EditableTableViewCell.h"

@implementation EditableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEditable: (BOOL) isEditable {
	self.textField.userInteractionEnabled = isEditable;
}

@end
