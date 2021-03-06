//
//  RP_GroupModel.h
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
@interface RP_GroupModel : NSObject

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) GMSMarker *marker;

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *groupOwner;
@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSNumber *numberOfPeopleInGroup;
@property (strong, nonatomic) NSString *locationTitle;
@property (strong, nonatomic) NSArray *topicsBeingSpokenAbout;

@end
