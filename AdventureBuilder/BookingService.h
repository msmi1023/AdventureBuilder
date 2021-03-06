//
//  BookingService.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/15/16.

#import <Foundation/Foundation.h>
#import "JabApiManager.h"
#import "Booking.h"

@interface BookingService : NSObject

@property (strong, nonatomic) Booking *booking;

typedef void (^completion_t)(id response);

-(instancetype)init;
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager;
-(void)getBookingsWithCompletionBlock:(completion_t)completionBlock;
-(void)createBookingWithCompletionBlock:(completion_t)completionBlock;

@end
