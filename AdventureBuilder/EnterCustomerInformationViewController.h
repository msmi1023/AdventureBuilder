//
//  EnterCustomerInformationViewController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JabUIViewController.h"

@interface EnterCustomerInformationViewController : JabUIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (strong, nonatomic) BookingService *bookingService;

@end