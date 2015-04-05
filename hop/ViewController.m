//
//  ViewController.m
//  hop
//
//  Created by Amogh Param on 4/4/15.
//  Copyright (c) 2015 Amogh Param. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *countryList;
@property (nonatomic, strong) NSString *queryString;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

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

-(void)viewDidLayoutSubviews{
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 5, 0, self.bottomLayoutGuide.length + 5, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image =[UIImage imageNamed:@"map_marker_filled-32.png"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:image tag:0];
    [self setMapDeaults];
    [self setLocationManagerDefaults];
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
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


-(void)other{
    //    GMSMarker *marker = [[GMSMarker alloc] init];
    //    marker.position = CLLocationCoordinate2DMake(41.887, -87.622);
    //    marker.appearAnimation = kGMSMarkerAnimationPop;
    //    marker.map = self.mapView;
    
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
}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

//do our search on the remote server using HTTP request
- (void)handleSearch:(UISearchBar *)searchBar {
    
    //check what was passed as the query String and get rid of the keyboard
    NSLog(@"User searched for %@", searchBar.text);
    self.queryString = searchBar.text;
    
    //setup the remote server URI
    
//    @"http://ec2-52-11-181-150.us-west-2.compute.amazonaws.com:8080/Hop/suggest?query=basketball&lat=34.068921&lng=-118.445181&range=100"
    
    NSString *hostServer = @"http://demo.mysamplecode.com/Servlets_JSP/";
    NSString *myUrlString = [NSString stringWithFormat:@"%@CountrySearch",hostServer];
    
    //pass the query String in the body of the HTTP post
    NSString *body;
    if(self.queryString){
        body =  [NSString stringWithFormat:@"queryString=%@", self.queryString];
    }
    NSURL *myUrl = [NSURL URLWithString:myUrlString];
    
    //make the HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
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

//parse our JSON response from the server and load the NSMutableArray of countries
- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:NSJSONReadingAllowFragments
                     error:&error];
    if (jsonObject != nil && error == nil){
        NSLog(@"Successfully deserialized...");
        
        NSNumber *success = [jsonObject objectForKey:@"success"];
        if([success boolValue] == YES){
            
            self.countryList = [jsonObject objectForKey:@"countryList"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}
@end
