//
//  SelectAdventureViewController.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/20/16.

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface SelectAdventureViewController : JabUIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *adventureType;
@property (strong, nonatomic) IBOutlet UIPickerView *adventure;
@property (strong, nonatomic) IBOutlet UITextView *details;

@property (strong, nonatomic) BookingService *bookingService;
@property (strong, nonatomic) AdventureService *adventureService;

@end
