//
//  CustomInfoMapWindowView.h
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInfoMapWindowView : UIView

@property (weak, nonatomic) IBOutlet UILabel *groupOwner;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleInGroup;
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicsBeingSpokenAbout;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
