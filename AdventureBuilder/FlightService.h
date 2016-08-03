//
//  FlightService.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/28/16.

#import <Foundation/Foundation.h>
#import "JabApiManager.h"
#import "Flight.h"

@interface FlightService : NSObject

@property NSString *maxFlightPrice;

typedef void (^completion_t)(id response);

-(instancetype)init;
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager;
-(void)getFlightsOfType:(NSString *)type withCompletionBlock:(completion_t)completionBlock;
-(void)getMaxFlightPricesWithCompletionBlock:(completion_t)completionBlock;

@end