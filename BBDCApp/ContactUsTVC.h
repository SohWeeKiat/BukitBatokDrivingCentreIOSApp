//
//  ContactUsTVC.h
//  BBDCApp
//
//  Created by StudentR on 22/2/16.
//  Copyright © 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactUsTVC : UITableViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lOpenHours;

@end
