//
//  ReviewBookingDetailsViewController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingService.h"

@interface ReviewBookingDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@property (weak, nonatomic) IBOutlet UILabel *fullAddress;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *adventureType;
@property (weak, nonatomic) IBOutlet UILabel *adventure;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *departingFlight;
@property (weak, nonatomic) IBOutlet UILabel *returningFlight;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (strong, nonatomic) IBOutlet BookingService *bookingService;

@end