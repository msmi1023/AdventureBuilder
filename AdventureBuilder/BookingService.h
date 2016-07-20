//
//  BookingService.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/15/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JabApiManager.h"
#import "Booking.h"

@interface BookingService : NSObject

typedef void (^completion_t)(id response);

-(instancetype)init;
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager;
-(void)getBookingsWithCompletionBlock:(completion_t)completionBlock;

@end
