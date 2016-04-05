//
//  MenuPanelViewController.h
//  SlotReader
//
//  Created by User on 3/29/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuPanelViewControllerDelegate <NSObject>


@end

@interface MenuPanelViewController : UITableViewController

@property (nonatomic, assign) id <UIDocumentMenuDelegate> delegate;

@end
