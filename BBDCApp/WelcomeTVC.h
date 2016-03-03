//
//  WelcomeTVC.h
//  BBDCApp
//
//  Created by StudentR on 26/1/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStoreHouseRefreshControl.h"

@interface WelcomeTVC : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *UserInfoTable;
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) IBOutlet UILabel *lNRIC;
@property (weak, nonatomic) IBOutlet UILabel *lCourseType;
@property (weak, nonatomic) IBOutlet UILabel *lGroup;
@property (weak, nonatomic) IBOutlet UILabel *lAccountBal;
@property (weak, nonatomic) IBOutlet UILabel *lMemExpDate;

- (void)finishRefreshControl;

@end
