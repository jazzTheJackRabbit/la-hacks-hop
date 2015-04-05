//
//  RP_EventModel.h
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface RP_EventModel : NSObject
@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) GMSMarker *marker;

@property (strong, nonatomic) NSString *groupOwner;
@property (strong, nonatomic) NSNumber *numberOfPeopleInGroup;
@property (strong, nonatomic) NSString *locationTitle;
@property (strong, nonatomic) NSArray *topicsBeingSpokenAbout;

@end
