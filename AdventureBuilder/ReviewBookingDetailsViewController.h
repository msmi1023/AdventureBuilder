//
//  ReviewBookingDetailsViewController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface ReviewBookingDetailsViewController : JabUIViewController

@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *emailAddress;
@property (strong, nonatomic) IBOutlet UILabel *fullAddress;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UILabel *adventureType;
@property (strong, nonatomic) IBOutlet UILabel *adventure;
@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) IBOutlet UILabel *departingFlight;
@property (strong, nonatomic) IBOutlet UILabel *returningFlight;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;

@property (strong, nonatomic) BookingService *bookingService;

@end