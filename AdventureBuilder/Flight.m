//
//  Flight.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Flight.h"

@implementation Flight

-(id)init {
	return [self initWithDictionary:nil];
}

-(id)initWithDictionary:(NSDictionary *)jsonFlight {
	self = [super init];
	
	if(jsonFlight == nil || [jsonFlight allKeys].count == 0) {
		_flightNumber = @"";
		_airline = @"";
		_arrivalTime = @"";
		_departureTime = @"";
		_price = @0;
	}
	else {
		_flightNumber = jsonFlight[@"flightNumber"];
		_airline = jsonFlight[@"airline"] ? jsonFlight[@"airline"] : @"";
		_arrivalTime = jsonFlight[@"arrivalTime"] ? jsonFlight[@"arrivalTime"] : @"";
		_departureTime = jsonFlight[@"departureTime"] ? jsonFlight[@"departureTime"] : @"";
		_price = jsonFlight[@"price"];
	}
	
	return self;
}

-(NSDictionary *)getDictionaryRepresentation {
	return @{@"flightNumber":_flightNumber,
			 @"airline":_airline,
			 @"arrivalTime":_arrivalTime,
			 @"departureTime":_departureTime,
			 @"price":_price};
}

-(NSString *)serializeToJSON {
	NSDictionary *classDictionary = [self getDictionaryRepresentation];
	
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:classDictionary options:0 error:&error];
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(BOOL)compareTo:(Flight *)anotherFlight {
	return ([self.flightNumber isEqualToString:anotherFlight.flightNumber]);
}

@end
