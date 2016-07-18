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
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager {
	self = [super init];
	if(!self) {
		return nil;
	}
	apiManager = jabApiManager;
	return self;
}

-(void)getBookingsWithCompletionBlock:(completion_t)completionBlock {
	[apiManager GET:@"bookings" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		completionBlock(responseObject);
	} failure:^(NSURLSessionTask *task, NSError *error) {
		completionBlock(error);
	}];
}

@end