//
//  PrettyTableViewCell.h
//  SwissPlanner
//
//  Created by User on 4/27/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrettyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstCellItem;
@property (weak, nonatomic) IBOutlet UILabel *secondCellItem;
@property (weak, nonatomic) IBOutlet UILabel *thirdCellItem;

@end
