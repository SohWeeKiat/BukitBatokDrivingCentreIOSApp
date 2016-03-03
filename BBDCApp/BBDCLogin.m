//
//  BBDCLogin.m
//  BBDCLogin
//
//  Created by StudentR on 14/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import "BBDCLogin.h"
#import "HTMLParser.h"
#import "LoginViewController.h"
#import "WelcomeTVC.h"
#import "XMLDictionary.h"
#import "TestDatesTVC.h"
#import "FindASlotTVC.h"

@implementation BBDCLogin

@synthesize mySharedArray;

-(id)init
{
    self = [super init];
    if (self){
        self->UseFakeAccount = NO;
        self->UserData = [[NSMutableDictionary alloc]init];
        self->LatestSlots = [[NSMutableArray alloc]init];
        self->SlotHistory = NULL;
        [self SetFakeAccountData];
        [self LoadFakeTestDates];
        
    }
    return self;
}

+ (BBDCLogin*) sharedInstance {
    static BBDCLogin *myInstance = nil;
    if (myInstance == nil) {
        myInstance = [[[self class] alloc] init];
        myInstance.mySharedArray = [NSArray arrayWithObject:@"Test"];
    }
    return myInstance;
}

-(void) UsageOfFakeAccount:(BOOL)State
{
    self->UseFakeAccount = State;
}

-(void) SetHandler:(UIViewController *)Inst AndFunc:(SEL)Func AndStage:(CurrentStage)CStage
{
    CallBackFunc = Func;
    ViewControllerInst = Inst;
    self->Stage = CStage;
    
    switch (Stage) {
        case WelcomePage:
        {
            WelcomeTVC* VC = (WelcomeTVC*)ViewControllerInst;
            [VC performSelector:Func withObject:nil afterDelay:0];
        }
            break;
        default:
            break;
    }
}

-(void) SetUsername:(NSString *)UserID Password:(NSString *)Pass
{
    Username = UserID;
    Password = Pass;
    if ([Username isEqualToString:@"s1234567a"] && [Pass isEqualToString:@"123456"]){
        [self UsageOfFakeAccount:YES];
        [self SaveLoginInfo];
        [self SetFakeAccountData];
    }else{
        [self UsageOfFakeAccount:NO];
    }
}

-(void) SaveLoginInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:Username forKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] setObject:Password forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL) CheckIfLoginInfoExist
{
    NSString* SavedUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    NSString* SavedPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];
    if (SavedUsername.length > 0 && SavedPassword.length > 0){
        [self SetUsername:SavedUsername Password:SavedPassword];
        return YES;
    }
    return NO;
}

-(NSString*) GetUsername;
{
    return Username;
}

-(NSString*) GetPassword
{
    return Password;
}

-(void) Logout
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self UsageOfFakeAccount:NO];
    IsLogin_ed = NO;
}

-(void) SetFakeAccountData
{
    [UserData setObject:@"Sample" forKey:@"Name"];
    [UserData setObject:@"S1234567A" forKey:@"NRIC"];
    [UserData setObject:@"3A" forKey:@"CourseType"];
    [UserData setObject:@"G8011" forKey:@"Group"];
    [UserData setObject:@"$12.35" forKey:@"AccBal"];
    [UserData setObject:@"01 Apr 2016" forKey:@"ExpiryDate"];
}

-(void) LoadFakeSlotHistory
{
    if (SlotHistory){
        return;
    }
    SlotHistory = [[NSMutableArray alloc]init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Records" ofType:@"xml"];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLFile:filePath];
    
    NSInteger LogsRecorded = [[xmlDoc valueForKeyPath:@"Logs.Log.DateTime"] count];
    for(int i = 0;i < LogsRecorded;i++)
    {
        NSString* DateTime = [[xmlDoc valueForKeyPath:@"Logs.Log.DateTime"] objectAtIndex:i];
        
        NSMutableDictionary* PerCheck = [[NSMutableDictionary alloc] init];
        [PerCheck setObject:DateTime forKey:@"DateTime"];
        
        NSArray* Log = [[[xmlDoc valueForKeyPath:@"Logs.Log.Entrys"] objectAtIndex:i] valueForKeyPath:@"Entry"];
        
        NSMutableArray* DailyEntries = [[NSMutableArray alloc] init];
        
        for(int i2 = 0;i2 < [Log count];i2++){//each day
            
            NSArray* Day = [Log objectAtIndex:i2];
            NSMutableDictionary* DailyEntry = [[NSMutableDictionary alloc] init];
            [DailyEntry setObject:[Day valueForKeyPath:@"Date"] forKey:@"Date"];
            [DailyEntry setObject:[Day valueForKeyPath:@"DayOfWeek"] forKey:@"DayOfWeek"];
            
            //NSLog(@"%@ %@",[Day valueForKeyPath:@"Date"],[Day valueForKeyPath:@"DayOfWeek"]);
            
            NSMutableArray* NewLessonCollection = [[NSMutableArray alloc] init];
            
            if([[Day valueForKeyPath:@"Lessons.Lesson"] isKindOfClass:[NSArray class]]){
                NSArray* Lessons = [Day valueForKeyPath:@"Lessons.Lesson"];
                NSInteger LessonCount = [Lessons count];
                for(int i3 = 0;i3 < LessonCount;i3++){//for each day session
                    NSArray* Lesson = [Lessons objectAtIndex:i3];
                    
                    NSDictionary* NewLesson = @{
                                                @"StartTime" : [Lesson valueForKeyPath:@"StartTime"],
                                                @"EndTime" : [Lesson valueForKeyPath:@"EndTime"],
                                                @"Session" : [Lesson valueForKeyPath:@"Session"]
                                                };
                    [NewLessonCollection addObject:NewLesson];
                }
            }else{
                NSDictionary* Lesson = [Day valueForKeyPath:@"Lessons.Lesson"];
                
                NSDictionary* NewLesson = @{
                                            @"StartTime" : [Lesson valueForKeyPath:@"StartTime"],
                                            @"EndTime" : [Lesson valueForKeyPath:@"EndTime"],
                                            @"Session" : [Lesson valueForKeyPath:@"Session"]
                                            };
                [NewLessonCollection addObject:NewLesson];
            }
            [DailyEntry setObject:NewLessonCollection forKey:@"Lessons"];
            [DailyEntries addObject:DailyEntry];
        }
        [PerCheck setObject:DailyEntries forKey:@"DailyEntries"];
        [SlotHistory addObject:PerCheck];
    }
}

-(void) LoadFakeTestDates
{
    TestDates = @{
        @"BTTS" : @"09/03/16",
        @"BTTP" : @"09/03/16",
        @"FTTS" : @"08/03/16",
        @"FTTP" : @"08/03/16",
        @"RTTS" : @"09/03/16",
        @"RTTP" : @"Not Available",
        @"S3C1" : @"04/03/16",
        @"S3C2" : @"04/03/16",
        @"S3A1" : @"04/03/16",
        @"S3A2" : @"03/03/16",
        @"S2B1" : @"16/03/16",
        @"S2B2" : @"21/03/16",
        @"S2A1" : @"17/03/16",
        @"S2A2" : @"17/03/16",
        @"S21" : @"17/03/16",
        @"S22" : @"17/03/16",
        @"P31" : @"07/03/16",
        @"P32" : @"09/03/16",
        @"P3A1" : @"07/03/16",
        @"P3A2" : @"07/03/16",
        @"P41" : @"Not Available",
        @"P42" : @"Not Available",
        @"P51" : @"Not Available",
        @"P52" : @"Not Available",
        @"date" : @"24/02/16",
    };
}

-(NSMutableArray*) GetSlotHistory
{
    return SlotHistory;
}

-(NSMutableDictionary*) GetUserData
{
    return UserData;
}

-(NSDictionary*) GetTestDates
{
    return TestDates;
}

-(NSMutableArray*) GetLatestSlot
{
    return LatestSlots;
}

-(void)TryLogin
{
    if (UseFakeAccount){
        switch (Stage) {
            case LoginPage:
            {
                NSNumber* Value = [NSNumber numberWithBool:YES];
                LoginViewController* Inst = (LoginViewController*)ViewControllerInst;
                [Inst performSelector:CallBackFunc withObject:Value afterDelay:1.5];
            }
                return;
            default:
                break;
        }
    }
    IsLogin_ed = NO;
    NSString* post = [NSString stringWithFormat:@"txtNRIC=%@&txtPassword=%@&btnLogin=+",Username,Password];
    
    NSData* postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.bbdc.sg/bbdc/bbdc_web/header2.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    Request = Login;
    NSURLSession* sharedUrlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* TryLoginTask = [sharedUrlSession dataTaskWithRequest:request
        completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error){
            dispatch_async(dispatch_get_main_queue(),^{
                NSString* Url = [response.URL absoluteString];
                if ([Url rangeOfString:@"b-mainframe.asp"].location != NSNotFound){
                    IsLogin_ed = YES;
                }else{
                    IsLogin_ed = NO;
                }
                self->Data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self OnLogin:error ? YES : NO];
            });
        }];
    [TryLoginTask resume];
}

-(void) TryGetUserAccNo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.bbdc.sg/bbdc/b-default.asp"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    Request = GrabAccNo;
    Data = @"";
    NSURLSession* sharedUrlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* TryGetUserAccNoTask = [sharedUrlSession dataTaskWithRequest:request
        completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error){
            dispatch_async(dispatch_get_main_queue(),^{
                if (!error){
                    self->Data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self OnSuccessfullyGrabbedAccNo];
                }else{
                    
                }
            });
        }];
    [TryGetUserAccNoTask resume];
}

-(void) TryGetLessonData
{
    NSString* post = [NSString stringWithFormat:@"accId=%@"
                      "&Month=Mar/2016"
                      "&Month=Apr/2016"
                      "&Month=May/2016"
                      "&Month=Jun/2016"
                      "&allMonth="
                      "&Session=1"
                      "&Session=2"
                      "&Session=3"
                      "&Session=4"
                      "&Session=5"
                      "&Session=6"
                      "&Session=7"
                      "&Session=8"
                      "&allSes=on"
                      "&Day=2"
                      "&Day=3"
                      "&Day=4"
                      "&Day=5"
                      "&Day=6"
                      "&Day=7"
                      "&Day=1"
                      "&allDay="
                      "&defPLVenue=1"
                      "&optVenue=1",AccID];
    
    NSData* postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.bbdc.sg/bbdc/b-3c-pLessonBooking1.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    Request = GrabLessonData;
    Data = @"";
    NSURLSession* sharedUrlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* TryGrabLessonTask = [sharedUrlSession dataTaskWithRequest:request
        completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error){
            dispatch_async(dispatch_get_main_queue(),^{
                    if (!error){
                        self->Data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        [self OnSuccessfullyGrabbedLessonInfo];
                    }
                });
            }];
    [TryGrabLessonTask resume];
}

-(void) TryGetUserInfo
{
    if (UseFakeAccount){
        if (Stage == WelcomePage){
            WelcomeTVC* VC = (WelcomeTVC*)ViewControllerInst;
            [VC performSelector:CallBackFunc withObject:nil afterDelay:1 inModes:@[NSRunLoopCommonModes]];
            return;
        }
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.bbdc.sg/bbdc/inc-webpage/b-topnav.asp"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    Request = GrabTopNav;

    Data = @"";
    NSURLSession* sharedUrlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* TryGrabUserInfoTask = [sharedUrlSession dataTaskWithRequest:request
        completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error){
            dispatch_async(dispatch_get_main_queue(),^{
                if (!error){
                    self->Data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self OnSuccessfullyGrabbedTopNav];
                }
            });
        }];
    [TryGrabUserInfoTask resume];
}

-(void) TryGetTestDates
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.bbdc.sg/bbdc/bbdc_web/testdate.xml"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    Request = GrabTestDate;
    Data = @"";
    
    NSURLSession* sharedUrlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* TryGrabUserInfoTask = [sharedUrlSession dataTaskWithRequest:request
        completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error){
            dispatch_async(dispatch_get_main_queue(),^{
                if (!error){
                    self->Data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self OnSuccessfullyGrabbedTestDates];
                }
            });
        }];
    [TryGrabUserInfoTask resume];
}

-(void)TryGetAvailableLessons
{
    if (UseFakeAccount){
        if (Stage == FindASlotPage){
            FindASlotTVC* VC = (FindASlotTVC*)ViewControllerInst;
            NSNumber* Value = [NSNumber numberWithInt:0];
            [VC performSelector:CallBackFunc withObject:Value afterDelay:0 inModes:@[NSRunLoopCommonModes]];
            return;
        }
    }
    [self TryLogin];
}

-(void) OnLogin:(BOOL)Failed
{
    switch (Stage) {
        case LoginPage:
        {
            NSNumber* Value = [NSNumber numberWithInt:Failed ? 2 : IsLogin_ed];
            LoginViewController* Inst = (LoginViewController*)ViewControllerInst;
            if (IsLogin_ed){
                [self SaveLoginInfo];
                [self TryGetUserInfo];
            }
            [Inst performSelector:CallBackFunc withObject:Value afterDelay:1.5];
            
        }
        break;
        case FindASlotPage:
            if (IsLogin_ed){
                [self TryGetUserAccNo];
            }
            break;
        default:
            break;
    }
}

-(void)OnSuccessfullyGrabbedAccNo
{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:Data error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildTags:@"td"];
    GrabbedAccID = NO;
    for (HTMLNode *inputNode in inputNodes) {
        if (GrabbedAccID){
            AccID = inputNode.contents;
            break;
        }
        if ([inputNode.contents isEqualToString:@"Account Id:"]) {
            GrabbedAccID  = YES;
        }
    }
    if (!GrabbedAccID){
        return;
    }
    [self TryGetLessonData];
}

-(void) OnSuccessfullyGrabbedLessonInfo
{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:Data error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildTags:@"td"];
    NSString* PrevDate = @"";
    NSMutableArray* PerDay = [[NSMutableArray alloc]init];
    [LatestSlots removeAllObjects];
    for (HTMLNode *inputNode in inputNodes) {
        
        if ([inputNode getAttributeNamed:@"onmouseover"].length > 0){
            //NSLog(@"%@",);
            NSString* RawEntry = [inputNode getAttributeNamed:@"onmouseover"];
            NSArray* Items = [RawEntry componentsSeparatedByString:@","];
            NSString* StartTime = [Items[4] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString* EndTime = [Items[5] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString* Session = [Items[3] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString* Date = [Items[2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSDictionary* NewLesson = @{
                @"Date" : Date,
                @"Session" : Session,
                @"StartTime" : StartTime,
                @"EndTime" : EndTime,
            };
            if ([PrevDate length] <= 0){
                PrevDate = Date;
                [PerDay addObject:NewLesson];
            }else if ([PrevDate isEqualToString:Date]){
                [PerDay addObject:NewLesson];
            }else{
                [LatestSlots addObject:PerDay];
                PrevDate = Date;
                PerDay = [[NSMutableArray alloc]init];
                [PerDay addObject:NewLesson];
            }
            NSLog(@"Start Time : %@ , End Time : %@ , Session: %d",StartTime,EndTime,[Session intValue]);
        }
    }
    if ([PerDay count] > 0){
        [LatestSlots addObject:PerDay];
    }
    if (Stage == FindASlotPage){
        FindASlotTVC* VC = (FindASlotTVC*)ViewControllerInst;
        NSNumber* Value = [NSNumber numberWithInt:1];
        [VC performSelector:CallBackFunc withObject:Value afterDelay:0 inModes:@[NSRunLoopCommonModes]];
    }
}

-(void) OnSuccessfullyGrabbedTopNav
{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:Data error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildTags:@"td"];
    for(int i = 0;i < inputNodes.count;i++){
        HTMLNode *inputNode = [inputNodes objectAtIndex:i];
        if ([inputNode.contents isEqualToString:@"Member Name:"]){
            i++;
            inputNode = [inputNodes objectAtIndex:i];
            NSString* Temp = inputNode.contents;
            if (inputNode.contents.length <= 0){
                Temp = @"Nil";
            }
            [UserData setObject:Temp forKey:@"Name"];
        }else if ([inputNode.contents isEqualToString:@"NRIC:"]){
            inputNode = [inputNodes objectAtIndex:++i];
            [UserData setObject:inputNode.contents forKey:@"NRIC"];
        }else if ([inputNode.contents isEqualToString:@"Course Type:"]){
            inputNode = [inputNodes objectAtIndex:++i];
            [UserData setObject:inputNode.contents forKey:@"CourseType"];
        }else if ([inputNode.contents isEqualToString:@"Group & Surcharge:"]){
            inputNode = [inputNodes objectAtIndex:++i];
            NSString* Temp = inputNode.contents;
            Temp = [Temp stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            [UserData setObject:Temp forKey:@"Group"];
        }else if ([inputNode.contents isEqualToString:@"Account Balance:"]){
            inputNode = [inputNodes objectAtIndex:++i];
            [UserData setObject:inputNode.contents forKey:@"AccBal"];
        }else if ([inputNode.contents isEqualToString:@"Membership Expiry Date:"]){
            inputNode = [inputNodes objectAtIndex:++i];
            [UserData setObject:inputNode.contents forKey:@"ExpiryDate"];
        }
    }
    if (Stage == WelcomePage){
        WelcomeTVC* VC = (WelcomeTVC*)ViewControllerInst;
        [VC performSelector:CallBackFunc withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
    }
}

-(void) OnSuccessfullyGrabbedTestDates
{
    TestDates = [NSDictionary dictionaryWithXMLString:Data];
    if (Stage == TestDatePage){
        TestDatesTVC* VC = (TestDatesTVC*)ViewControllerInst;
        [VC performSelector:CallBackFunc withObject:nil afterDelay:0];
    }
}

@end
