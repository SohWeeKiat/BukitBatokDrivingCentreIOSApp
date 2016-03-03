//
//  FindASlotVC.h
//  BBDCApp
//
//  Created by StudentR on 24/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindASlotVC : UIViewController

@property (weak,nonatomic) IBOutlet UIBarButtonItem* barButton;
@property (weak, nonatomic) IBOutlet UIButton *FindASlotBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *StartDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *EndDatePicker;
- (IBAction)OnStartDateChanged:(id)sender;

@end
