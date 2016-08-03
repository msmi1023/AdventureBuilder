//
//  FlightService.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/28/16.

#import "FlightService.h"

@implementation FlightService {
	JabApiManager *apiManager;
}

//DI constructor to bring in the api manager
//our api manager is a singleton, so we can hard-code the dependency in init
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager {
	self = [super init];
	apiManager = jabApiManager;
	_maxFlightPrice = @"";
	return self;
}

//override normal init to use the shared api manager.
//makes it so our storyboard injected instance will already have the api manager
-(instancetype)init {
	return [self initWithApiManager:[JabApiManager sharedManager]];
}

-(void)getFlightsOfType:(NSString *)type withCompletionBlock:(completion_t)completionBlock {
	NSString *endpoint = [NSString stringWithFormat:@"flights/%@", type];
	
	[apiManager GET:endpoint parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		NSMutableArray *toReturn = [[NSMutableArray alloc] init];
		
		if(![_maxFlightPrice isEqualToString:@""]) {
			float max = [_maxFlightPrice floatValue];
			
			//create array of flight objects
			for(NSDictionary *jsonFlight in responseObject) {
				if([((NSNumber *)jsonFlight[@"price"]) floatValue] <= max) {
					[toReturn addObject:[[Flight alloc] initWithDictionary:jsonFlight]];
				}
			}
		}
		else {
			//create array of flight objects
			for(NSDictionary *jsonFlight in responseObject) {
				[toReturn addObject:[[Flight alloc] initWithDictionary:jsonFlight]];
			}
		}
		
		completionBlock([toReturn copy]);
	} failure:^(NSURLSessionTask *task, NSError *error) {
		completionBlock(error);
	}];
}

-(void)getMaxFlightPricesWithCompletionBlock:(completion_t)completionBlock {
	[apiManager GET:@"flightpriceoptions/maxflightprice" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		NSMutableArray *toReturn = [[NSMutableArray alloc] init];
		
		//create array of booking objects
		for(NSString *jsonPrice in responseObject) {
			[toReturn addObject:jsonPrice];
		}
		
		completionBlock([toReturn copy]);
	} failure:^(NSURLSessionTask *task, NSError *error) {
		completionBlock(error);
	}];
}

@end