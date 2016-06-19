//
//  PrettyExpandedTableViewCell.h
//  SwissPlanner
//
//  Created by User on 4/28/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrettyExpandedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstCellItem;
@property (weak, nonatomic) IBOutlet UILabel *secondCellItem;
@property (weak, nonatomic) IBOutlet UILabel *thirdCellItem;
@property (weak, nonatomic) IBOutlet UILabel *fourthCellItem;

@end
