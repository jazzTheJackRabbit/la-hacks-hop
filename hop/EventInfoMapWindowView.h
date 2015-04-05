//
//  EventInfoMapWindowView.h
//  hop
//
//  Created by Amogh Param on 4/5/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInfoMapWindowView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *placeImage;
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@end
