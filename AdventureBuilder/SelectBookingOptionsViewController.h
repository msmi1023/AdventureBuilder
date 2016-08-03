//
//  SelectBookingOptionsViewController.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/20/16.

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface SelectBookingOptionsViewController : JabUIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIDatePicker *startDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDate;
@property (strong, nonatomic) IBOutlet UIPickerView *maxFlightPrice;
@property (strong, nonatomic) IBOutlet UITextView *notes;

@property (strong, nonatomic) BookingService *bookingService;
@property (strong, nonatomic) FlightService *flightService;

@end
