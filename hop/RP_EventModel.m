//
//  RP_EventModel.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "RP_EventModel.h"

@implementation RP_EventModel

@synthesize eventTitle;
@synthesize latitude;
@synthesize longitude;
@synthesize marker;

-(instancetype)init{
    self.eventTitle = @"";
    self.latitude = @"";
    self.longitude = @"";
    self.marker = nil;
    return self;
}

@end
