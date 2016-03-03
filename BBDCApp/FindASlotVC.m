//
//  FindASlotVC.m
//  BBDCApp
//
//  Created by StudentR on 24/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "FindASlotVC.h"
#import "FindASlotTVC.h"
#import "SWRevealViewController.h"

@interface FindASlotVC ()

@end

@implementation FindASlotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.FindASlotBtn.layer.cornerRadius = 20;
    [_StartDatePicker setMinimumDate:[NSDate date]];
    [_EndDatePicker setMinimumDate:[NSDate date]];
    [_EndDatePicker setDate:[_EndDatePicker.date dateByAddingTimeInterval:(60 * 24 * 60 * 60)]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSlots"]){
        FindASlotTVC* TV = (FindASlotTVC*)segue.destinationViewController;
        TV.StartDate = _StartDatePicker.date;
        TV.EndDate = _EndDatePicker.date;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)OnStartDateChanged:(id)sender {
    [_EndDatePicker setMinimumDate:_StartDatePicker.date];
}
@end
