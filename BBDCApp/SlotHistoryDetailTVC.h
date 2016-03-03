//
//  SlotHistoryDetailTVC.h
//  BBDCApp
//
//  Created by StudentR on 5/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlotHistoryDetailTVC : UITableViewController

@property long SelectedCheckID;
@property NSMutableArray* DisplayedID;

-(void) OnTimeButtonTouched:(UIButton*)sender;

@end
