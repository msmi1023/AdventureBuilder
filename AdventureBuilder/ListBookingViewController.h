//
//  ListBookingViewController.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/14/16.

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface ListBookingViewController : JabUIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) BookingService *bookingService;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *bookingList;

@end