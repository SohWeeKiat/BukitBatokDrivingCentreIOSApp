//
//  NavigationViewController.m
//  BBDCLogin
//
//  Created by StudentR on 15/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import "BBDCLogin.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController
{
    NSArray* menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menu = @[@"First",@"Second",@"Third",@"Fourth",@"Fifth",@"Sixth",@"Seventh",@"LogoutBtn"];
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
    return [menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* CellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]){
        SWRevealViewControllerSegue* swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue,UIViewController* svc, UIViewController* dvc){
          
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [menu count] - 1) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Logout"
                                                                       message:@"Are you sure you want to logout of BBDC?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            UIStoryboard* loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [[BBDCLogin sharedInstance]Logout];
            UIViewController* LoginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            
            [[UIApplication sharedApplication].keyWindow setRootViewController:LoginVC];
            
        }];
        UIAlertAction* NoAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [alert addAction:NoAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
