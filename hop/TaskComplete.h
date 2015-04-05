//
//  TaskComplete.h
//  hop
//
//  Created by Amogh Param on 4/5/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskComplete : UIView
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
