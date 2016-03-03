//
//  SlotHistoryDetailTVC.m
//  BBDCApp
//
//  Created by StudentR on 5/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "SlotHistoryDetailTVC.h"
#import "BBDCLogin.h"
@import Social;

@interface SlotHistoryDetailTVC ()

@end

@implementation SlotHistoryDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _DisplayedID = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSMutableArray* Array = [[BBDCLogin sharedInstance]GetSlotHistory];
    Array = [[Array objectAtIndex:_SelectedCheckID] objectForKey:@"DailyEntries"];
    return [Array count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* Array = [[BBDCLogin sharedInstance]GetSlotHistory];
    Array = [[Array objectAtIndex:_SelectedCheckID] objectForKey:@"DailyEntries"];
    NSMutableDictionary* Item = [Array objectAtIndex:indexPath.row];
    NSMutableArray* Lessons = [Item objectForKey:@"Lessons"];
    
    if ([Lessons count] > 4){
        return 85;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* Array = [[BBDCLogin sharedInstance]GetSlotHistory];
    Array = [[Array objectAtIndex:_SelectedCheckID] objectForKey:@"DailyEntries"];
    NSMutableDictionary* Item = [Array objectAtIndex:indexPath.row];
    NSMutableArray* Lessons = [Item objectForKey:@"Lessons"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    for(UIView* View in cell.subviews){
        if ([View isKindOfClass:[UIButton class]] || [View isKindOfClass:[UILabel class]]){
            [View removeFromSuperview];
        }
    }
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    UILabel* primaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 25)];
    primaryLabel.textAlignment = NSTextAlignmentLeft;
    primaryLabel.font = [UIFont systemFontOfSize:17];
    primaryLabel.text = [NSString stringWithFormat:@"%@ %@",[Item objectForKey:@"Date"],[Item objectForKey:@"DayOfWeek"]];
    [cell addSubview:primaryLabel];
    
    // Configure the cell...
    for(int i = 0;i < [Lessons count];i++){
        NSMutableDictionary* Lesson = [Lessons objectAtIndex:i];
            
        UIButton* TimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + ((i < 4) ? (i * 55) : ((i-4) * 55)),(i < 4) ? 27 : (27+23),50,20.0)];
        TimeBtn.layer.cornerRadius = 10;
        [TimeBtn addTarget:self action:@selector(OnTimeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [TimeBtn setTitle:[Lesson objectForKey:@"StartTime"] forState:UIControlStateNormal];
        [TimeBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [TimeBtn setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:TimeBtn];

    }
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
