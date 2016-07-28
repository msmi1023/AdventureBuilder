//
//  BookingService.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/15/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "BookingService.h"

@implementation BookingService {
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
	_booking = [[Booking alloc] initWithDictionary:nil];
	return self;
}

//override normal init to use the shared api manager.
//makes it so our storyboard injected instance will already have the api manager
-(instancetype)init {
	return [self initWithApiManager:[JabApiManager sharedManager]];
}

-(void)getBookingsWithCompletionBlock:(completion_t)completionBlock {
	[apiManager GET:@"bookings" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		NSMutableArray *toReturn = [[NSMutableArray alloc] init];
		
		//create array of booking objects
		for(NSDictionary *jsonBooking in responseObject) {
			[toReturn addObject:[[Booking alloc] initWithDictionary:jsonBooking]];
		}
		
		completionBlock([toReturn copy]);
	} failure:^(NSURLSessionTask *task, NSError *error) {
		completionBlock(error);
	}];
}

-(void)createBookingWithCompletionBlock:(completion_t)completionBlock {
	[apiManager POST:@"bookings" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
		[formData appendPartWithFormData:[_booking serializeToJSONData] name:@"booking"];
	} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		completionBlock(responseObject);
	} failure:^(NSURLSessionTask *task, NSError *error) {
		completionBlock(error);
	}];
}

@end