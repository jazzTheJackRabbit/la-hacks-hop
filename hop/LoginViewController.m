//
//  LoginViewController.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginButton.delegate = self;
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        // User is logged in, do work such as go to next view controller.
        NSLog(@"Will be moving to next part..");
    }
    else{
        // In your viewDidLoad method:
        self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_likes"];
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"");
}

-(void)viewDidAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]) {
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationControllerForMap"];
        [self sendAccessToken];
        [navigationController.tabBarController setSelectedIndex:0];
        [self presentViewController:navigationController animated:YES completion:^(void){}];
        
    }
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    NSLog(@"%@",result);
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationControllerForMap"];
    [self sendAccessToken];
    [navigationController.tabBarController setSelectedIndex:0];
    [self presentViewController:navigationController animated:YES completion:^(void){}];
}

-(void)sendAccessToken{
    FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
    
    //setup the remote server URI
    NSString *hostServerString = @"http://ec2-52-11-181-150.us-west-2.compute.amazonaws.com:8080/Hop/newuser";
    NSString *userIDString = accessToken.userID;
    NSString *authCodeString = accessToken.tokenString;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?UserId=%@&AuthCode=%@&UserName=%@",hostServerString,userIDString,authCodeString,@"Mr-FuckItMan"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(urlString);
    //make the HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         //we got something in reponse to our request lets go ahead and process this
         if ([data length] >0 && error == nil){
             [self parseResponse:data];
         }
         else if ([data length] == 0 && error == nil){
             NSLog(@"Empty Response, not sure why?");
         }
         else if (error != nil){
             NSLog(@"Not again, what is the error = %@", error);
         }
     }];
}

//parse our JSON response from the server and load the NSMutableArray of countries
- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
//        [self createEventsArrayForJSONObject:jsonObject];
    }
}

//-(void)createMarkersForAllEvents{
//    for (int i = 0 ; i < [self.eventArray count]; i++) {
//        RP_EventModel *eventModel = self.eventArray[i];
//        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([eventModel.latitude doubleValue], [eventModel.longitude doubleValue]);
//        [self createMapMarkerForLocation:location andTitle:eventModel.eventTitle];
//    }
//    
//    [self.mapView animateToZoom:11];
//}
@end
