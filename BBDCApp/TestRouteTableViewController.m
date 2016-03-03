//
//  TestRouteTableViewController.m
//  BBDCLogin
//
//  Created by StudentR on 22/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import "TestRouteTableViewController.h"
#import "SWRevealViewController.h"
#import "MapViewController.h"

@interface TestRouteTableViewController ()

@end

@implementation TestRouteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 0) {
        _RouteSelected = indexPath.row;
        [self performSegueWithIdentifier:@"ShowMap" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        TestRouteTableViewController* VC = [segue destinationViewController];
        //QuizTVC* Quiz = [segue destinationViewController];
        VC.RouteSelected = self.RouteSelected;
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
    
}

@end
