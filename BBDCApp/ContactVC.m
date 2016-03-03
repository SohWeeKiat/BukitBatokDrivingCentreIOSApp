//
//  ContactVC.m
//  BBDCApp
//
//  Created by StudentR on 25/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import "ContactVC.h"
#import "SWRevealViewController.h"
@interface ContactVC ()

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    point = [[MKPointAnnotation alloc]init];
    point.coordinate = CLLocationCoordinate2DMake(1.3667296,103.750171);
    point.title = @"BBDC";
    point.subtitle = @"Bukit Batok Driving Center";
    [self.myMap addAnnotation:point];
    self.myMap.centerCoordinate = CLLocationCoordinate2DMake(1.3667296,103.750171);
    
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(1.3667296,103.750171);
    region.span.latitudeDelta  = 0.001;
    region.span.longitudeDelta = 0.005;
    
    [self.myMap setRegion:region];

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

@end
