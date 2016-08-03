//
//  EnterCustomerInformationViewController.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/20/16.

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface EnterCustomerInformationViewController : JabUIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailAddress;
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *phone;

@property (strong, nonatomic) BookingService *bookingService;

@end