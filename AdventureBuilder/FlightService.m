//
//  FlightService.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "FlightService.h"

@implementation FlightService {
	JabApiManager *apiManager;
}

//DI constructor to bring in the api manager
//our api manager is a singleton, so we can hard-code the dependency in init
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager {
	self = [super init];
	if(!self) {
		return nil;
	}
	apiManager = jabApiManager;
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
		
		//create array of booking objects
		for(NSDictionary *jsonFlight in responseObject) {
			[toReturn addObject:[[Flight alloc] initWithDictionary:jsonFlight]];
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