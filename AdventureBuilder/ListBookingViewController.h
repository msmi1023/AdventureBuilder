//
//  ListBookingViewController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingService.h"

@interface ListBookingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet BookingService *bookingService;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *bookingList;

@end