//
//  FacebookTest.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "FacebookTest.h"

@implementation FacebookTest
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"Will be moving to next part..");
//        SecondViewController *loginViewController = (SecondViewController *)segue.destinationViewController;
        
//        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationControllerForMap"];
        
//        [self presentViewController:navigationController animated:YES completion:^(void){}];
        
    }
    else{
        // In your viewDidLoad method:
        self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"Will be moving to next part..");
        //        SecondViewController *loginViewController = (SecondViewController *)segue.destinationViewController;
        
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationControllerForMap"];
        
        [self presentViewController:navigationController animated:YES completion:^(void){}];
        
    }
}
@end
