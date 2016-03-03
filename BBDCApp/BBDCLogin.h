//
//  BBDCLogin.h
//  BBDCLogin
//
//  Created by StudentR on 14/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum CurrentRequest : NSUInteger {
    Login,
    EnumlateHuman,
    GrabTopNav,
    GrabAccNo,
    GrabSideBar,
    GrabLessonData,
    GrabTestDate
} CurrentRequests;

typedef enum CurrentStage : NSUInteger{
    LoginPage,
    WelcomePage,
    BookingPage,
    TestDatePage,
    FindASlotPage
}CurrentStage;

/*
 nsarray - sdictonary -entries for each check
 Date+Time
 nsarray - nsdictionary
 date
 nsarray - nsdirectory
 StartTime
 EndTime
 int Session
 
 
 alot of tries
 try date+time
 for each tries, there is alot of dates
 date
 for each dates, there is alot of lessons
 for each lesson, contains start time end time session
 
 */

@interface BBDCLogin : NSObject
{
    NSDictionary* Entries;
    
    NSString* AccID;
    NSString* Username;
    NSString* Password;
    BOOL UseFakeAccount;
    NSMutableDictionary* UserData;
    NSMutableArray* SlotHistory;
    NSDictionary* TestDates;
    NSMutableArray* LatestSlots;
    
    CurrentRequests Request;
    CurrentStage Stage;
    
    BOOL IsLogin_ed;
    BOOL GrabbedAccID;
    NSString* Data;
    BOOL GetLessons;
    UIViewController* ViewControllerInst;
    SEL CallBackFunc;
}
@property (nonatomic) NSArray * mySharedArray;
+ (BBDCLogin*) sharedInstance;

-(void) UsageOfFakeAccount:(BOOL)State;

-(void) SetHandler:(UIViewController*)Inst AndFunc:(SEL)Func AndStage:(CurrentStage)CStage;

-(void) SetUsername:(NSString*)UserID Password:(NSString*)Pass;

-(void) SaveLoginInfo;

-(BOOL) CheckIfLoginInfoExist;

-(NSString*) GetUsername;

-(NSString*) GetPassword;

-(void) Logout;

-(void) SetFakeAccountData;

-(void) LoadFakeSlotHistory;

-(void) LoadFakeTestDates;

-(NSMutableArray*) GetSlotHistory;

-(NSMutableDictionary*) GetUserData;

-(NSDictionary*) GetTestDates;

-(NSMutableArray*) GetLatestSlot;

-(void) TryLogin;

-(void) TryGetUserInfo;

-(void) TryGetAvailableLessons;

-(void) TryGetTestDates;

@end