//
//  SettingsViewController.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIImage *image =[UIImage imageNamed:@"settings_filled-32.png"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:image tag:1];
}

@end
