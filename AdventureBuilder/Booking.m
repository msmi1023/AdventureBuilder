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
		_customer = [[Customer alloc] init];
		_adventure = [[Adventure alloc] init];
		_departingFlight = [[Flight alloc] init];
		_returningFlight = [[Flight alloc] init];
		_startDate = nil;
		_endDate = nil;
		_updateTime = nil;
	}
	else {
		_uuid = jsonBooking[@"uuid"];
		_confirmationNumber = jsonBooking[@"confirmationNumber"];
		_note = jsonBooking[@"note"];
		
		if([jsonBooking[@"customer"] isKindOfClass:[Customer class]]) {
			_customer = jsonBooking[@"customer"];
		}
		else if([jsonBooking[@"customer"] isKindOfClass:[NSDictionary class]]) {
			_customer = [[Customer alloc] initWithDictionary:jsonBooking[@"customer"]];
		}
		
		if([jsonBooking[@"adventure"] isKindOfClass:[Adventure class]]) {
			_adventure = jsonBooking[@"adventure"];
		}
		else if([jsonBooking[@"adventure"] isKindOfClass:[NSDictionary class]]) {
			_adventure = [[Adventure alloc] initWithDictionary:jsonBooking[@"adventure"]];
		}
		
		if([jsonBooking[@"departingFlight"] isKindOfClass:[Flight class]]) {
			_departingFlight = jsonBooking[@"departingFlight"];
		}
		else if([jsonBooking[@"departingFlight"] isKindOfClass:[NSDictionary class]]) {
			_departingFlight = [[Flight alloc] initWithDictionary:jsonBooking[@"departingFlight"]];
		}
		
		if([jsonBooking[@"returningFlight"] isKindOfClass:[Flight class]]) {
			_returningFlight = jsonBooking[@"returningFlight"];
		}
		else if([jsonBooking[@"returningFlight"] isKindOfClass:[NSDictionary class]]) {
			_returningFlight = [[Flight alloc] initWithDictionary:jsonBooking[@"returningFlight"]];
		}
		
		if([jsonBooking[@"startDate"] isKindOfClass:[NSDate class]]) {
			_startDate = jsonBooking[@"startDate"];
		}
		else if([jsonBooking[@"startDate"] isKindOfClass:[NSString class]]) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateFormat:@"MMM-dd-yyyy"];
			NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
			[dateFormatter setTimeZone:gmt];
			
			_startDate = [dateFormatter dateFromString:jsonBooking[@"startDate"]];
		}
		
		if([jsonBooking[@"endDate"] isKindOfClass:[NSDate class]]) {
			_endDate = jsonBooking[@"endDate"];
		}
		else if([jsonBooking[@"endDate"] isKindOfClass:[NSString class]]) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateFormat:@"MMM-dd-yyyy"];
			NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
			[dateFormatter setTimeZone:gmt];
			
			_endDate = [dateFormatter dateFromString:jsonBooking[@"endDate"]];
		}
		
		if([jsonBooking[@"updateTime"] isKindOfClass:[NSDate class]]) {
			_updateTime = jsonBooking[@"updateTime"];
		}
		else if([jsonBooking[@"updateTime"] isKindOfClass:[NSString class]]) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
			NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
			[dateFormatter setTimeZone:gmt];
			
			_updateTime = [dateFormatter dateFromString:jsonBooking[@"updateTime"]];
		}
	}
	
	return self;
}

-(NSDictionary *)getDictionaryRepresentation {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"MMM-dd-yyyy"];
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
	[timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[timeFormatter setTimeZone:gmt];
	
	
	return @{@"uuid": _uuid,
			@"confirmationNumber": _confirmationNumber,
			@"note": _note,
			@"customer": [_customer getDictionaryRepresentation],
			@"adventure": [_adventure getDictionaryRepresentation],
			@"departingFlight": [_departingFlight getDictionaryRepresentation],
			@"returningFlight": [_returningFlight getDictionaryRepresentation],
			@"startDate": [dateFormatter stringFromDate:_startDate],
			@"endDate": [dateFormatter stringFromDate:_endDate],
			@"updateTime": [timeFormatter stringFromDate:_updateTime]};
}

-(NSData *)serializeToJSONData {
	NSDictionary *classDictionary = [self getDictionaryRepresentation];

	NSError *error;
	return [NSJSONSerialization dataWithJSONObject:classDictionary options:0 error:&error];
}

-(NSString *)serializeToJSONString {
	return [[NSString alloc] initWithData:[self serializeToJSONData] encoding:NSUTF8StringEncoding];
}

@end