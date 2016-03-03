//
//  ProgressVC.m
//  BBDCApp
//
//  Created by StudentR on 12/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "ProgressVC.h"
#import "SWRevealViewController.h"
#import "StepperView.h"
#import "BBDCLogin.h"

@interface ProgressVC () {
    StepperView* Stepper;
}

@end

@implementation ProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    Stepper = [[StepperView alloc]initWithInfo:self.view MPR:3 CurrentValue:1 Max:9];
    [Stepper AddDescription:@"BTT" AndDesc:@"In the process of doing your BTT. Check this only when you passed."];
    [Stepper AddDescription:@"FTT" AndDesc:@"In the process of doing your FTT. Check this only when you passed."];
    [Stepper AddDescription:@"Practical1" AndDesc:@"Finally compleated your Theory and can't wait for your first practical lesson? Check this only when you finished your first lesson."];
    [Stepper AddDescription:@"Stage1" AndDesc:@"After a few lessons, you finally passed Stage 1? Great! You can then check this option."];
    [Stepper AddDescription:@"Stage2" AndDesc:@"One step closer to your license! Check this only when you compleated Stage 2."];
    [Stepper AddDescription:@"Stage3" AndDesc:@"Stage 3 done? Great, Half way there!"];
    [Stepper AddDescription:@"Stage4" AndDesc:@"WooHoo done with Stage 4? Check this option and onwards to Stage 5!"];
    [Stepper AddDescription:@"Stage5" AndDesc:@"Done with Stage 5? Awesome!! Time to test out your new skill!"];
    [Stepper AddDescription:@"TP" AndDesc:@"Passed your TP? Superb,you are now a qualified driver!!"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"ProgressSteps"];
    
    NSMutableDictionary *Doc = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    if (!Doc){
        NSDictionary *rootDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProgressSteps" ofType:@"plist"]];
        [rootDictionary writeToFile:docfilePath atomically:YES];
        Doc = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    }
    NSMutableArray* Users = [Doc objectForKey:@"Users"];
    
    for(int i = 0;i < [Users count];i++){
        NSDictionary* UserInfo = [Users objectAtIndex:i];
        if ([[[[BBDCLogin sharedInstance]GetUserData]objectForKey:@"NRIC"] isEqualToString:[UserInfo objectForKey:@"IC"]]){
            Stepper.numberCurrent = [[UserInfo objectForKey:@"Steps"] integerValue];
            [Stepper setStepWithNumber:(int)Stepper.numberCurrent];
            break;
        }
    }
    UITapGestureRecognizer* TapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HandleTap:)];
    TapGest.numberOfTouchesRequired = 1;
    TapGest.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:TapGest];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"ProgressSteps"];
    
    NSMutableDictionary *Doc = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    
    BOOL Stored = NO;
    NSMutableArray* Users = [Doc objectForKey:@"Users"];
    for(int i = 0;i < [Users count];i++){
        NSDictionary* UserInfo = [Users objectAtIndex:i];
        if ([[[[BBDCLogin sharedInstance]GetUserData]objectForKey:@"NRIC"] isEqualToString:[UserInfo objectForKey:@"IC"]]){
            [UserInfo setValue:[NSString stringWithFormat:@"%d",(int)Stepper.numberCurrent] forKey:@"Steps"];
            [Doc writeToFile:docfilePath atomically:YES];
            Stored = YES;
            break;
        }
        
    }
    if (!Stored){
        NSDictionary* NewUserInfo = @{
            @"IC" : [[[BBDCLogin sharedInstance]GetUserData]objectForKey:@"NRIC"],
            @"Steps" : [NSString stringWithFormat:@"%d",(int)Stepper.numberCurrent]
        };
        [Users addObject:NewUserInfo];
        [Doc writeToFile:docfilePath atomically:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)goPrevious:(id)sender {
    --Stepper.numberCurrent;
    if (Stepper.numberCurrent <= 0) {
        Stepper.numberCurrent = 1;
    }
    [Stepper setStepWithNumber:(int)Stepper.numberCurrent];
}

- (IBAction)goNext:(id)sender {
    ++Stepper.numberCurrent;
    if (Stepper.numberCurrent > Stepper.numberTotalStep) {
        Stepper.numberCurrent = Stepper.numberTotalStep + 1;
    }
    [Stepper setStepWithNumber:(int)Stepper.numberCurrent];
}

- (IBAction)HandleTap:(UITapGestureRecognizer*)sender {
    [Stepper OnTapped:sender];
}

@end
