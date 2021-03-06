//
//  Booking.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/18/16.

#import <Foundation/Foundation.h>
#import "Customer.h"
#import "Adventure.h"
#import "Flight.h"

@interface Booking : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSNumber *confirmationNumber;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) Customer *customer;
@property (strong, nonatomic) Adventure *adventure;
@property (strong, nonatomic) Flight *departingFlight;
@property (strong, nonatomic) Flight *returningFlight;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *updateTime;

-(id)init;
-(id)initWithDictionary:(NSDictionary *)jsonBooking;
-(NSDictionary *)getDictionaryRepresentationForAction:(NSString *)action;
-(NSData *)serializeToJSONDataForAction:(NSString *)action;
-(NSString *)serializeToJSONStringForAction:(NSString *)action;
-(NSString *)startDateString;
-(NSString *)endDateString;
-(NSString *)startDateStringForCell;
-(NSString *)endDateStringForCell;
-(NSNumber *)totalPrice;

@end
