//
//  Flight.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Flight.h"

@implementation Flight

-(id)initWithDictionary:(NSDictionary *)jsonFlight {
	self = [super init];
	if(!self) {
		return nil;
	}
	
	if(jsonFlight == nil || [jsonFlight allKeys].count == 0) {
		_flightNumber = @"";
		_price = @0;
	}
	else {
		_flightNumber = jsonFlight[@"flightNumber"];
		_price = jsonFlight[@"price"];
	}
	
	return self;
}

@end
