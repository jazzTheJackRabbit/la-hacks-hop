//
//  SettingsViewController.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "SettingsViewController.h"
@interface SettingsViewController()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end


@implementation SettingsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIImage *image =[UIImage imageNamed:@"settings_filled-32.png"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:image tag:1];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    NSLog(@"%@",result);
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"");
}
@end
