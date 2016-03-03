//
//  FindASlotTVC.m
//  BBDCApp
//
//  Created by StudentR on 24/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "FindASlotTVC.h"
#import "BBDCLogin.h"
#import "TYMActivityIndicatorView.h"
@import Social;

@interface FindASlotTVC ()

@end

@implementation FindASlotTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BBDCLogin sharedInstance]SetHandler:(UIViewController*)self AndFunc:@selector(OnLatestSlotResult:) AndStage:FindASlotPage];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor blackColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:1];

    _largeActivityIndicatorView = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleLarge];
    _largeActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_largeActivityIndicatorView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_largeActivityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_largeActivityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-100]];
    _largeActivityIndicatorView.center = self.view.center;
    _largeActivityIndicatorView.fullRotationDuration = 1;
    _largeActivityIndicatorView.clockwise = YES;
    [_largeActivityIndicatorView startAnimating];
    
    [[BBDCLogin sharedInstance]TryGetAvailableLessons];
    
    LatestSlot = [[NSMutableArray alloc]init];
    self.tableView.alwaysBounceVertical = NO;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[[BBDCLogin sharedInstance]GetLatestSlot]removeAllObjects];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

- (void)refreshTriggered:(id)sender
{
    [[BBDCLogin sharedInstance] TryGetAvailableLessons];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

-(void)RandomGenerateDates{
    [LatestSlot removeAllObjects];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy, (EEE)"];
    
    int NoOfDays = (int)[self daysBetweenDate:_StartDate andDate:_EndDate];
    int DaysToGenerate = arc4random_uniform(NoOfDays) + 1;
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    for(int i = 0;i < DaysToGenerate;i++){
        
        NSDate* Day = [NSDate date];
        
        BOOL FoundDate = NO;
        do{
            int DaysToBeAdded = arc4random_uniform(NoOfDays) + 1;
            dayComponent.day = DaysToBeAdded;
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            Day = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            FoundDate = NO;
            for(int i2 = 0;i2 < [LatestSlot count];i2++){
                if ([[[[LatestSlot objectAtIndex:i2]objectAtIndex:0] objectForKey:@"Date"] isEqualToString:[dateFormat stringFromDate:Day]]){
                    FoundDate = YES;
                    break;
                }
            }
        }while(FoundDate);
        
        int LessonsPerDay = arc4random_uniform(7) + 1;
        NSMutableArray* Lessons = [[NSMutableArray alloc]init];
        for(int i2 = 0;i2 < LessonsPerDay;i2++){
            static NSString* StartTimings[] = { @"07:30", @"09:20",@"11:30",@"13:20",@"15:20",@"17:10",@"19:20",@"21:10"};
            BOOL Found = NO;
            do{
                int TimeSlot = arc4random_uniform(7);
                Found = NO;
                for(int i3 = 0;i3 < [Lessons count];i3++){
                    if ([[[Lessons objectAtIndex:i3]objectForKey:@"StartTime"] isEqualToString:StartTimings[TimeSlot]]){
                        Found = YES;
                        break;
                    }
                }
                if (!Found){
                    NSDictionary* NewLesson = @{
                                                @"Date" : [dateFormat stringFromDate:Day],
                                                @"Session" : [NSString stringWithFormat:@"%d",TimeSlot+1],
                                                @"StartTime" : StartTimings[TimeSlot],
                                                };
                    [Lessons addObject:NewLesson];
                }
            }while(Found);
        }
        [LatestSlot addObject:Lessons];
    }
    [dateFormat setDateFormat:@"dd/MM/yyyy, (EEE)"];
    NSArray *sortedArray = [LatestSlot sortedArrayUsingComparator: ^(id obj1, id obj2) {
        NSDate* Date1 = [dateFormat dateFromString:[[obj1 objectAtIndex:0]objectForKey:@"Date"]];
        NSDate* Date2 = [dateFormat dateFromString:[[obj2 objectAtIndex:0]objectForKey:@"Date"]];
        return [Date1 compare:Date2];
    }];
    LatestSlot = [NSMutableArray arrayWithArray:sortedArray];
    [dateFormat setDateFormat:@"HH:mm"];
    for(int i = 0;i < [LatestSlot count];i++){
        NSArray *sortedArray2 = [[LatestSlot objectAtIndex:i] sortedArrayUsingComparator: ^(id obj1, id obj2) {
            NSDate* Time1 = [dateFormat dateFromString:[obj1 objectForKey:@"StartTime"]];
            NSDate* Time2 = [dateFormat dateFromString:[obj2 objectForKey:@"StartTime"]];
            return [Time1 compare:Time2];
        }];
        [LatestSlot replaceObjectAtIndex:i withObject:sortedArray2];
    }
    [self.tableView reloadData];
}

-(void)OnLatestSlotResult:(NSNumber*)Result
{
    self.tableView.alwaysBounceVertical = YES;
    [_largeActivityIndicatorView stopAnimating];
    _largeActivityIndicatorView.alpha = 0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
    [self.storeHouseRefreshControl finishingLoading];
    
    
    if ([Result intValue] == 0){
        /*UIAlertController* alert= [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, we can't get latest practical slot using guest account." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];*/
        [self RandomGenerateDates];
        return;
    }
    [LatestSlot removeAllObjects];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    for(int i = 0;i < [[[BBDCLogin sharedInstance]GetLatestSlot]count];i++){
        NSMutableArray* PerDay = [[[BBDCLogin sharedInstance]GetLatestSlot] objectAtIndex:i];
        NSString* DateAnddDay = [[PerDay objectAtIndex:0] objectForKey:@"Date"];
        NSArray* Items = [DateAnddDay componentsSeparatedByString:@" "];
        NSString* DateString = [Items[1] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        NSDate* Date = [dateFormat dateFromString:DateString];
        if (([Date compare:_StartDate] == NSOrderedDescending && [Date compare:_EndDate] == NSOrderedAscending) ||
            ([Date compare:_StartDate] == NSOrderedSame || [Date compare:_EndDate] == NSOrderedSame)){
            [LatestSlot addObject:PerDay];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LatestSlot count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* Slots = [LatestSlot objectAtIndex:indexPath.row];
    if ([Slots count] > 4){
        return 85;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableArray* PerDay = [LatestSlot objectAtIndex:indexPath.row];
    
    for(UIView* vista in cell.subviews){
        if ([vista isKindOfClass:[UIButton class]] || [vista isKindOfClass:[UILabel class]]){
            [vista removeFromSuperview];
        }
    }
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    UILabel* primaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 25)];
    primaryLabel.textAlignment = NSTextAlignmentLeft;
    primaryLabel.font = [UIFont systemFontOfSize:17];
    primaryLabel.text = [NSString stringWithFormat:@"%@",[[PerDay objectAtIndex:0] objectForKey:@"Date"]];
    [cell addSubview:primaryLabel];
    
    // Configure the cell...
    for(int i = 0;i < [PerDay count];i++){
        NSMutableDictionary* Lesson = [PerDay objectAtIndex:i];
        
        UIButton* TimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + ((i < 4) ? (i * 55) : ((i-4) * 55)),(i < 4) ? 27 : (27+23),50,20.0)];
        TimeBtn.layer.cornerRadius = 10;
        [TimeBtn addTarget:self action:@selector(OnTimeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [TimeBtn setTitle:[Lesson objectForKey:@"StartTime"] forState:UIControlStateNormal];
        [TimeBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [TimeBtn setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:TimeBtn];
        
    }
    
    // Configure the cell...
    
    return cell;
}

-(void) OnTimeButtonTouched:(UIButton*)sender{
    NSString* Date = @"";
    for(UIView* View in sender.superview.subviews){
        if ([View isKindOfClass:[UILabel class]]){
            Date = ((UILabel*)View).text;
            break;
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Share" message:[NSString stringWithFormat:@"%@, %@",Date,sender.titleLabel.text] preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* Facebook = [UIAlertAction actionWithTitle:@"Share to facebook" style:UIAlertActionStyleDefault handler:
                               ^(UIAlertAction *action){
                                   [self ShareToFacebookTwitter:YES AndText:[NSString stringWithFormat:@"%@, %@",Date,sender.titleLabel.text]];
                               }];
    [Facebook setValue:[[UIImage imageNamed:@"FacebookIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    UIAlertAction* Twitter = [UIAlertAction actionWithTitle:@"Share to Twitter" style:UIAlertActionStyleDefault handler:
                              ^(UIAlertAction *action){
                                  [self ShareToFacebookTwitter:NO AndText:[NSString stringWithFormat:@"%@, %@",Date,sender.titleLabel.text]];
                              }];
    [Twitter setValue:[[UIImage imageNamed:@"TwitterIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    UIAlertAction* BookNow = [UIAlertAction actionWithTitle:@"Book now" style:UIAlertActionStyleDefault handler:
                              ^(UIAlertAction *action){
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.bbdc.sg"]];
                              }];
    
    UIAlertAction* Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:
                             ^(UIAlertAction *action){
                                 
                             }];
    [alertController addAction:Facebook];
    [alertController addAction:Twitter];
    [alertController addAction:BookNow];
    [alertController addAction:Cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) ShareToFacebookTwitter:(BOOL)Facebook AndText:(NSString*)DateTime
{
    if ([SLComposeViewController isAvailableForServiceType:Facebook ? SLServiceTypeFacebook : SLServiceTypeTwitter]) {
        SLComposeViewController* fbSLComposeViewController = [SLComposeViewController composeViewControllerForServiceType:Facebook ? SLServiceTypeFacebook : SLServiceTypeTwitter];
        [fbSLComposeViewController setInitialText:[NSString stringWithFormat:@"I found a slot on %@",DateTime]];
        [self presentViewController:fbSLComposeViewController animated:YES completion:nil];
        fbSLComposeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"facebook: CANCELLED");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"facebook: SHARED");
                    break;
            }
        };
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:Facebook ? @"Facebook Unavailable" : @"Twitter Unavailable" message:[NSString stringWithFormat:@"Sorry, we're unable to find a %@ account on your device.\nPlease setup an account in your devices settings and try again.",Facebook ? @"Facebook" : @"Twitter"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* OkBtn = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:
                                ^(UIAlertAction *action){
                                }];
        [alertController addAction:OkBtn];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
