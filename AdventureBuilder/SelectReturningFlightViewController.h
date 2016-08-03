//
//  SelectReturningFlightViewController.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/20/16.

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface SelectReturningFlightViewController : JabUIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BookingService *bookingService;
@property (strong, nonatomic) FlightService *flightService;

@end