//
//  OrdersTableViewCell.h
//  SwissPlanner
//
//  Created by User on 6/10/16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipPlusOrderLabel;

@end
