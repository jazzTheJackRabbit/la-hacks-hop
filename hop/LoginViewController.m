//
//  LoginViewController.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.delegate = self;
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        // User is logged in, do work such as go to next view controller.
        NSLog(@"Will be moving to next part..");
    }
    else{
        // In your viewDidLoad method:
        self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_likes"];
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"");
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    NSLog(@"%@",result);
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationControllerForMap"];
    
    [self presentViewController:navigationController animated:YES completion:^(void){}];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]) {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationControllerForMap"];
        
        [self presentViewController:navigationController animated:YES completion:^(void){}];
        
    }
}
@end
