//
//  Adventure.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Adventure.h"

@implementation Adventure

-(id)initWithDictionary:(NSDictionary *)jsonAdventure {
	self = [super init];
	if(!self) {
		return nil;
	}
	
	if(jsonAdventure == nil || [jsonAdventure allKeys].count == 0) {
		_type = @"";
		_name = @"";
		_dailyPrice = @0;
		_activities = @[];
	}
	else {
		_type = jsonAdventure[@"type"];
		_name = jsonAdventure[@"name"];
		_dailyPrice = jsonAdventure[@"dailyPrice"];
		_activities = jsonAdventure[@"activities"];
	}
	
	return self;
}

-(NSDictionary *)getDictionaryRepresentation {
	return @{@"type":_type,
			 @"name":_name,
			 @"dailyPrice":_dailyPrice,
			 @"activities":_activities};
}

-(NSString *)serializeToJSON {
	NSDictionary *classDictionary = [self getDictionaryRepresentation];
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:classDictionary options:0 error:&error];
	return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(BOOL)compareTo:(Adventure *)anotherAdventure {
	return ([self.type isEqualToString:anotherAdventure.type] &&
			[self.name isEqualToString:anotherAdventure.name]);
}

@end