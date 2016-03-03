//
//  LoginViewController.h
//  BBDCLogin
//
//  Created by StudentR on 20/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>
{
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
    
}

@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;

@property (weak, nonatomic) IBOutlet UITextField *txtNRIC;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)OnLoginTouched:(id)sender;
-(void) UponLoginNotification:(NSNumber*)Success;
-(void)alertStatus:(NSString*)msg :(NSString*)title :(int)tag;

-(void)TryLoggingIn:(BOOL)UseUIValue;

@end
