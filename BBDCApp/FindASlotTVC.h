//
//  FindASlotTVC.h
//  BBDCApp
//
//  Created by StudentR on 24/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStoreHouseRefreshControl.h"
#import "TYMActivityIndicatorView.h"

@interface FindASlotTVC : UITableViewController
{
    NSMutableArray* LatestSlot;
}
@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@property NSDate* StartDate;
@property NSDate* EndDate;

@property TYMActivityIndicatorView* largeActivityIndicatorView;

@end
