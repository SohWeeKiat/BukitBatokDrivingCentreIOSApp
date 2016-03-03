//
//  TestDatesTVC.m
//  BBDCApp
//
//  Created by StudentR on 22/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "TestDatesTVC.h"
#import "SWRevealViewController.h"
#import "bbDCLogin.h"

@interface TestDatesTVC ()

@end

@implementation TestDatesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [[BBDCLogin sharedInstance]SetHandler:self AndFunc:@selector(OnTestDatesResult) AndStage:TestDatePage];
    
    [[BBDCLogin sharedInstance]TryGetTestDates];
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor blackColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:1];
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
    [[BBDCLogin sharedInstance] TryGetTestDates];
    //[self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

-(void)OnTestDatesResult
{
    [self.tableView reloadData];
    [self.storeHouseRefreshControl finishingLoading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    static NSString* SectionTitles[] = { @"Basic Theory",@"Final Theory",@"Riding Theory",@"Class 3 (Manual) Practical - School",
        @"Class 3 (Auto) Practical - School",@"Class 2B Practical - School",@"Class 2A Practical - School",@"Class 2 Practical - School",
        @"Class P3 (Manual) Practical - Private",@"Class P3A (Auto) Practical - Private",@"P41 Practical - Private",@"P51 Practical - Private"};
    return SectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* XMLKeys[] = { @"BTTS",@"BTTP",@"FTTS",@"FTTP",@"RTTS",@"RTTP",@"S3C1",@"S3C2",@"S3A1",@"S3A2",@"S2B1",@"S2B2",@"S2A1",
        @"S2A2",@"S21",@"S22",@"P31",@"P32",@"P3A1",@"P3A2",@"P41",@"P42",@"P51",@"P52" };
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //indexPath.se
    if (indexPath.row % 2 == 0){
        cell.textLabel.text = @"First Attempt";
    }else{
        cell.textLabel.text = @"Subsequent Attempt";
    }
    cell.detailTextLabel.text = [[[BBDCLogin sharedInstance]GetTestDates] objectForKey:XMLKeys[indexPath.section * 2 + indexPath.row]];
    // Configure the cell...
    
    return cell;
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
