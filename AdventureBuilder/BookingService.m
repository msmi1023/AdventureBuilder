//
//  BookingService.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/15/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "BookingService.h"

@implementation BookingService

JabApiManager *apiManager;

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

//-(instancetype)init {
//	static dispatch_once_t pred;
//	static BookingService *_sharedInstance = nil;
//	
//	dispatch_once(&pred, ^{
//		_sharedInstance = [self initWithApiManager:[JabApiManager sharedManager]];
//	});
//	
//	return _sharedInstance;
//}

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

@end