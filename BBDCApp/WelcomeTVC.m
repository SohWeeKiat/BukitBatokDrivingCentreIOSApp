//
//  WelcomeTVC.m
//  BBDCApp
//
//  Created by StudentR on 26/1/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "WelcomeTVC.h"
#import "BBDCLogin.h"

@interface WelcomeTVC ()

@end

@implementation WelcomeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BBDCLogin sharedInstance]SetHandler:(UIViewController*) self AndFunc:@selector(finishRefreshControl) AndStage:WelcomePage];
    
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.UserInfoTable target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor blackColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:1];
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
    [[BBDCLogin sharedInstance] TryGetUserInfo];
    //[self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    NSMutableDictionary* UserData = [[BBDCLogin sharedInstance] GetUserData];
    _lName.text = [UserData objectForKey:@"Name"];
    _lNRIC.text = UserData[@"NRIC"];
    _lCourseType.text = UserData[@"CourseType"];
    _lGroup.text = UserData[@"Group"];
    _lAccountBal.text = UserData[@"AccBal"];
    _lMemExpDate.text = UserData[@"ExpiryDate"];
    [self.storeHouseRefreshControl finishingLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
