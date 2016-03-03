//
//  LoginViewController.m
//  BBDCLogin
//
//  Created by StudentR on 20/1/16.
//  Copyright (c) 2016 StudentR. All rights reserved.
//

#import "LoginViewController.h"
#import "BBDCLogin.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize activityView,loadingView,loadingLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BBDCLogin sharedInstance] SetHandler:(UIViewController*)self AndFunc:@selector(UponLoginNotification:) AndStage:LoginPage];
    
    self.btnLogin.layer.cornerRadius = 20;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tumblr-road" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    if (gif){
        UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
        [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:nil];
        webViewBG.userInteractionEnabled = NO;
    
        [webViewBG setDelegate:self];
        [self.view addSubview:webViewBG];
    }
    [_txtNRIC setDelegate:self];
    [_txtPassword setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect Rect = aWebView.frame;
    //aWebView.scrollView.contentOffset = CGPointMake((Rect.size.width / 2) - 80, (Rect.size.height / 2) - 125);
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    aWebView.scrollView.contentOffset = CGPointMake((Rect.size.width / 2) - (width / 4), (Rect.size.height / 2) - (height / 3));
}

-(void) viewDidAppear:(BOOL)animated
{
    if ([[BBDCLogin sharedInstance] CheckIfLoginInfoExist]){
        _txtNRIC.text = [[BBDCLogin sharedInstance]GetUsername];
        _txtPassword.text = [[BBDCLogin sharedInstance]GetPassword];
        [self TryLoggingIn:NO];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtNRIC resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [[self.view window]endEditing:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)TryLoggingIn:(BOOL)UseUIValue
{
    [self.txtNRIC resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    _btnLogin.enabled = NO;
    _btnLogin.backgroundColor = [UIColor grayColor];
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    loadingView.center = self.view.center;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Logining in...";
    [loadingView addSubview:loadingLabel];
    
    [self.view addSubview:loadingView];
    [activityView startAnimating];
    
    if (UseUIValue){
        [[BBDCLogin sharedInstance] SetUsername:_txtNRIC.text Password:_txtPassword.text];
    }
    [[BBDCLogin sharedInstance] TryLogin];

}

- (IBAction)OnLoginTouched:(id)sender {
    if (_txtNRIC.text.length < 6 || _txtPassword.text.length <= 5){
        [self alertStatus:@"Please enter a valid NRIC & password" :@"Error" :0];
        return;
    }
    [self TryLoggingIn:YES];
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)alertStatus:(NSString*)msg :(NSString*)title :(int)tag
{
    UIAlertController* alert= [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) UponLoginNotification:(NSNumber*)Success
{
    if ([Success intValue] == 1){
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }else if ([Success intValue] == 0){
        [activityView stopAnimating];
        [loadingView removeFromSuperview];
        [self alertStatus:@"Wrong NRIC or password" :@"Error" :0];
        _btnLogin.enabled = YES;
        _btnLogin.backgroundColor = [UIColor colorWithRed:74.0/255.0 green:126.0/255.0 blue:206.0/255.0 alpha:1];
    }if ([Success intValue] == 2){
        [activityView stopAnimating];
        [loadingView removeFromSuperview];
        [self alertStatus:@"Encounted error, please check your connection" :@"Error" :0];
        _btnLogin.enabled = YES;
        _btnLogin.backgroundColor = [UIColor colorWithRed:74.0/255.0 green:126.0/255.0 blue:206.0/255.0 alpha:1];
    }
}
@end
