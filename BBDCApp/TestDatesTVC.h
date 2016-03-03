//
//  TestDatesTVC.h
//  BBDCApp
//
//  Created by StudentR on 22/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStoreHouseRefreshControl.h"

@interface TestDatesTVC : UITableViewController

@property (weak,nonatomic) IBOutlet UIBarButtonItem* barButton;
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

-(void) OnTestDatesResult;

@end
