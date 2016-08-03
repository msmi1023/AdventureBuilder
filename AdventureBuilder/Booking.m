//
//  Booking.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Booking.h"

@implementation Booking {
	NSDateFormatter *dateFormatter, *dateFormatterForCell, *timeFormatter;
	NSTimeZone *gmt;
}

-(id)init {
	return [self initWithDictionary:nil];
}

-(id)initWithDictionary:(NSDictionary *)jsonBooking {
	self = [super init];
	
	dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"MMM-dd-yyyy"];
	gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
	
	dateFormatterForCell = [[NSDateFormatter alloc] init];
	[dateFormatterForCell setDateFormat:@"MM/dd/yy"];
	[dateFormatterForCell setTimeZone:gmt];
	
	timeFormatter = [[NSDateFormatter alloc]init];
	[timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	[timeFormatter setTimeZone:gmt];
	
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
			_startDate = [dateFormatter dateFromString:jsonBooking[@"startDate"]];
		}
		
		if([jsonBooking[@"endDate"] isKindOfClass:[NSDate class]]) {
			_endDate = jsonBooking[@"endDate"];
		}
		else if([jsonBooking[@"endDate"] isKindOfClass:[NSString class]]) {
			_endDate = [dateFormatter dateFromString:jsonBooking[@"endDate"]];
		}
		
		if([jsonBooking[@"updateTime"] isKindOfClass:[NSDate class]]) {
			_updateTime = jsonBooking[@"updateTime"];
		}
		else if([jsonBooking[@"updateTime"] isKindOfClass:[NSString class]]) {
			_updateTime = [timeFormatter dateFromString:jsonBooking[@"updateTime"]];
		}
	}
	
	return self;
}

-(NSDictionary *)getDictionaryRepresentationForAction:(NSString *)action {
	if([action isEqualToString:@"create"]) {
		//don't include confirmationNumber, uuid or updateTime. they don't exist yet on a create.
		return @{@"note": _note,
				 @"customer": [_customer getDictionaryRepresentation],
				 @"adventure": [_adventure getDictionaryRepresentation],
				 @"departingFlight": [_departingFlight getDictionaryRepresentation],
				 @"returningFlight": [_returningFlight getDictionaryRepresentation],
				 @"startDate": [self startDateString],
				 @"endDate": [self endDateString]};
	}
	else {
		return @{@"uuid": _uuid,
				 @"confirmationNumber": _confirmationNumber,
				 @"note": _note,
				 @"customer": [_customer getDictionaryRepresentation],
				 @"adventure": [_adventure getDictionaryRepresentation],
				 @"departingFlight": [_departingFlight getDictionaryRepresentation],
				 @"returningFlight": [_returningFlight getDictionaryRepresentation],
				 @"startDate": [self startDateString],
				 @"endDate": [self endDateString],
				 @"updateTime": [timeFormatter stringFromDate:_updateTime]};
	}
}

-(NSData *)serializeToJSONDataForAction:(NSString *)action {
	NSDictionary *classDictionary = [self getDictionaryRepresentationForAction:action];

	NSError *error;
	return [NSJSONSerialization dataWithJSONObject:classDictionary options:0 error:&error];
}

-(NSString *)serializeToJSONStringForAction:(NSString *)action {
	return [[NSString alloc] initWithData:[self serializeToJSONDataForAction:action] encoding:NSUTF8StringEncoding];
}

-(NSString *)startDateString {
	return [dateFormatter stringFromDate:_startDate];
}

-(NSString *)endDateString {
	return [dateFormatter stringFromDate:_endDate];
}

-(NSString *)startDateStringForCell {
	return [dateFormatterForCell stringFromDate:_startDate];
}

-(NSString *)endDateStringForCell {
	return [dateFormatterForCell stringFromDate:_endDate];
}

-(NSNumber *)totalPrice {
	NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:_startDate toDate:_endDate options:0];
	
	return [NSNumber numberWithFloat:((dateComponent.day * [_adventure.dailyPrice floatValue]) + [_departingFlight.price floatValue] + [_returningFlight.price floatValue])];
}

@end