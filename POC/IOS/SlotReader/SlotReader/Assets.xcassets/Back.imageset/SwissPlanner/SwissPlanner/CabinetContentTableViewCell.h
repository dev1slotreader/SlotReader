//
//  CabinetContentTableViewCell.h
//  SwissPlanner
//
//  Created by Anastasiya Yarovenko on 25.05.16.
//  Copyright © 2016 Elena Baoychuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CabinetContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentLabel;

@end
