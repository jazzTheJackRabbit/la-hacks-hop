//
//  RP_GroupModel.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "RP_GroupModel.h"

@implementation RP_GroupModel
@synthesize eventTitle;
@synthesize latitude;
@synthesize longitude;
@synthesize marker;

@synthesize groupId;
@synthesize groupOwner;
@synthesize numberOfPeopleInGroup;
@synthesize locationTitle;
@synthesize topicsBeingSpokenAbout;

-(instancetype)init{
    self.eventTitle = @"";
    self.latitude = @"";
    self.longitude = @"";
    self.marker = nil;
    self.groupId = @"";
    self.groupOwner = @"";
    self.numberOfPeopleInGroup = [NSNumber numberWithInt:0];
    self.locationTitle = @"";
    self.topicsBeingSpokenAbout = [[NSArray alloc] init];
    return self;
}

@end
