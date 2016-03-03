//
//  ViewController.m
//  BBDCLogin
//
//  Created by StudentR on 14/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import "ViewController.h"
#import "BBDCLogin.h"
#import "SWRevealViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
