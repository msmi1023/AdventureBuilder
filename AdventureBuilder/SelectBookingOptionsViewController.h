//
//  SelectBookingOptionsViewController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingService.h"

@interface SelectBookingOptionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *startDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDate;
@property (weak, nonatomic) IBOutlet UIPickerView *maxFlightPrice;
@property (weak, nonatomic) IBOutlet UITextView *notes;

@property (strong, nonatomic) IBOutlet BookingService *bookingService;

@end
