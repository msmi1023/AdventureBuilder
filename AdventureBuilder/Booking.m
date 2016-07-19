//
//  Booking.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Booking.h"

@implementation Booking

-(id)initWithDictionary:(NSDictionary *)jsonBooking {
	self = [super init];
	if(!self) {
		return nil;
	}
	
	if(jsonBooking == nil || [jsonBooking allKeys].count == 0) {
		_uuid = @"";
		_confirmationNumber = nil;
		_note = @"";
		_customer = nil;
		_adventure = nil;
		_departingFlight = nil;
		_returningFlight = nil;
		_startDate = nil;
		_endDate = nil;
		_updateTime = nil;
	}
	else {
		_uuid = jsonBooking[@"uuid"];
		_confirmationNumber = jsonBooking[@"confirmationNumber"];
		_note = jsonBooking[@"note"];
		_customer = jsonBooking[@"customer"];
		_adventure = jsonBooking[@"adventure"];
		_departingFlight = jsonBooking[@"departingFlight"];
		_returningFlight = jsonBooking[@"returningFlight"];
		_startDate = jsonBooking[@"startDate"];
		_endDate = jsonBooking[@"endDate"];
		_updateTime = jsonBooking[@"updateTime"];
	}
	
	return self;
}

@end