//
//  ViewController.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "ViewController.h"
#import "RP_EventModel.h"
#import "CustomInfoMapWindowView.h"

@interface ViewController()
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *countryList;
@property (nonatomic, strong) NSString *queryString;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *eventArray;
@property (nonatomic, strong) NSMutableArray *markerArray;
@property (weak, nonatomic) IBOutlet UIView *activitiyIndicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;

@end

@implementation ViewController

@synthesize mapView;
@synthesize mySearchBar;
@synthesize myTableView;
@synthesize countryList;
@synthesize queryString;

//************************************************************
#pragma mark DEFAULT SETUP
//************************************************************

@synthesize eventArray;
@synthesize markerArray;

-(void)viewDidLayoutSubviews{
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 5, 0, self.bottomLayoutGuide.length + 5, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.activitiyIndicatorView.hidden = YES;
    UIImage *image =[UIImage imageNamed:@"map_marker-32.png"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:image tag:0];
    [self setMapDeaults];
    [self setLocationManagerDefaults];
    [self createSearchBar];
}

-(void)setMapDeaults{
    //set Map defaults
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.delegate = self;
}

-(void)setLocationManagerDefaults{
    //set location Manager defaults for iOS 8
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

-(void)createSearchBar{
//    create a search bar and add to the top of the screen
    CGRect myFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 72,
                                self.view.bounds.size.width, 44.0f);
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:myFrame];
    //set the delegate to self so we can listen for events
    self.mySearchBar.delegate = self;
    //display the cancel button next to the search bar
    self.mySearchBar.showsCancelButton = NO;
    //add the search bar to the view
    [self.view addSubview:self.mySearchBar];
}

-(GMSMarker *)createMapMarkerForLocation:(CLLocationCoordinate2D)location andTitle:(NSString *)title{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location;
    marker.title = title;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = self.mapView;
    [self.markerArray addObject:marker];
    return marker;
}

-(void)createMarkersForAllEvents{
    for (int i = 0 ; i < [self.eventArray count]; i++) {
        RP_EventModel *eventModel = self.eventArray[i];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([eventModel.latitude doubleValue], [eventModel.longitude doubleValue]);
        eventModel.marker = [self createMapMarkerForLocation:location andTitle:eventModel.eventTitle];
    }

    [self.mapView animateToZoom:11];
}

-(RP_EventModel *)findEventForMarker: (GMSMarker *) marker{
    //search in self.eventsArray
    for (int i = 0; i < [self.eventArray count]; i++) {
        RP_EventModel *eventModel = self.eventArray[i];
        if (marker == eventModel.marker) {
            return eventModel;
        }
    }
    return nil;
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    CustomInfoMapWindowView *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoWindow" owner:self options:nil] objectAtIndex:0];
    
    RP_EventModel *eventModel = [self findEventForMarker:marker];
    
    infoWindow.groupOwner.text = eventModel.groupOwner;
    infoWindow.numberOfPeopleInGroup.text = [NSString stringWithFormat: @"%d",[eventModel.numberOfPeopleInGroup intValue]];
    infoWindow.locationTitle.text = eventModel.locationTitle;
    
    return infoWindow;
}

-(void)other{
    
    //create a search bar and add to the top of the screen
    //    CGRect myFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 72,
    //                                self.view.bounds.size.width, 44.0f);
    //    self.mySearchBar = [[UISearchBar alloc] initWithFrame:myFrame];
    //    //set the delegate to self so we can listen for events
    //    self.mySearchBar.delegate = self;
    //    //display the cancel button next to the search bar
    //    self.mySearchBar.showsCancelButton = YES;
    //    //add the search bar to the view
    //    [self.view addSubview:self.mySearchBar];
    //
    //    //set the frame for the table view
    //    myFrame.origin.y += 44;
    //    myFrame.size.height = self.view.bounds.size.height - 44;
    //    self.myTableView = [[UITableView alloc] initWithFrame:myFrame
    //                                                    style:UITableViewStylePlain];
    //    //set the table view delegate and the data source
    //    self.myTableView.delegate = self;
    //    self.myTableView.dataSource = self;
    //    //set table view resize attribute
    //    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    //    UIViewAutoresizingFlexibleHeight;
    //    //set background view and color
    //    self.myTableView.backgroundColor = [UIColor whiteColor];
    //    self.myTableView.backgroundView = nil;
    //    //add table view to the main view
    ////    [self.view addSubview:self.myTableView];
    //
    //    //execute the search without any query to display all countries
    //    [self handleSearch:self.mySearchBar];
}

//************************************************************
#pragma mark SEARCH BAR
//************************************************************

//search button was tapped
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
    [self.view endEditing:YES];
}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    [self handleSearch:searchBar];
}

//do our search on the remote server using HTTP request
- (void)handleSearch:(UISearchBar *)searchBar {
    
    //check what was passed as the query String and get rid of the keyboard
    NSLog(@"User searched for %@", searchBar.text);
    self.queryString = searchBar.text;
    
    //setup the remote server URI
    NSString *hostServerString = @"http://ec2-52-11-181-150.us-west-2.compute.amazonaws.com:8080/Hop/suggest";
    NSString *userQueryString = queryString;
    NSString *latitudeString = [NSString stringWithFormat:@"%f",self.mapView.myLocation.coordinate.latitude ];
    NSString *longitudeString = [NSString stringWithFormat:@"%f",self.mapView.myLocation.coordinate.longitude ];
    NSString *rangeString = @"100";
    
    //TODO: Change the API call here for groups v/s events
    NSString *urlString = [NSString stringWithFormat:@"%@?query=%@&lat=%@&lng=%@&range=%@",hostServerString,userQueryString,latitudeString,longitudeString,rangeString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //make the HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"POST"];
    self.activitiyIndicatorView.hidden = NO;
    [self.activityIndicator startAnimating];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         //we got something in reponse to our request lets go ahead and process this
         if ([data length] >0 && error == nil){
//             self.activitiyIndicatorView.hidden = YES;
//             [self.activityIndicator stopAnimating];
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

//user tapped on the cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
}


//************************************************************
#pragma mark TABLE VIEW
//************************************************************

//number of rows in a given section of a table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRows = 0;
    //get the count from the array
    if ([tableView isEqual:self.myTableView]){
        numberOfRows = self.countryList.count;
    }
    //if user searched for something and found nothing just add a row to display a message
    if(numberOfRows == 0 && [self.queryString length] > 0){
        numberOfRows = 1;
    }
    NSLog(@"Rows: %i", (int)numberOfRows);
    return numberOfRows;
}


//asks the data source for a cell to insert in a particular location of the table view
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCellView = nil;
    
    if ([tableView isEqual:self.myTableView]){
        
        static NSString *TableViewCellIdentifier = @"CountryCells";
        //create a reusable table-view cell object located by its identifier
        myCellView = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        if (myCellView == nil){
            myCellView = [[UITableViewCell alloc]
                          initWithStyle:UITableViewCellStyleValue1
                          reuseIdentifier:TableViewCellIdentifier];
        }
        
        //if there are countries to display
        if(self.countryList.count > 0){
            NSDictionary *countryInfo = [self.countryList objectAtIndex:indexPath.row];
            NSLog(@"Country Info = %@",countryInfo);
            
            NSString *countryCode = [countryInfo  valueForKey:@"code"];
            NSString *countryName = [countryInfo  valueForKey:@"name"];
            myCellView.textLabel.text = [NSString stringWithFormat:@"%@",countryName];
            myCellView.detailTextLabel.text = countryCode;
        }
        //display message to user
        else {
            myCellView.textLabel.text = @"No Results found, try again!";
            myCellView.detailTextLabel.text = @"";
        }
        
        //set the table view cell style
        [myCellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return myCellView;
}

//************************************************************
#pragma mark HELPERS
//************************************************************

-(void)createEventsArrayForJSONObject: (id)jsonObject{
    NSArray *events = [jsonObject valueForKey:@"events"];
    self.eventArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[events count]; i++) {
        RP_EventModel *eventModel = [[RP_EventModel alloc] init];
        eventModel.eventTitle = [events[i] valueForKey:@"name"];
        eventModel.latitude = [events[i] valueForKey:@"lat"];
        eventModel.longitude = [events[i] valueForKey:@"lng"];
        [self.eventArray addObject: eventModel];
    }
    [self createMarkersForAllEvents];
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
        [self createEventsArrayForJSONObject:jsonObject];
    }
}
@end
