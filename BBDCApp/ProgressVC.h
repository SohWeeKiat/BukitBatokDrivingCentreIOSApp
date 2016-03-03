//
//  ProgressVC.h
//  BBDCApp
//
//  Created by StudentR on 12/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressVC : UIViewController

@property (weak,nonatomic) IBOutlet UIBarButtonItem* barButton;

- (IBAction)goPrevious:(id)sender;
- (IBAction)goNext:(id)sender;
- (IBAction)HandleTap:(UITapGestureRecognizer*)sender;

@end
