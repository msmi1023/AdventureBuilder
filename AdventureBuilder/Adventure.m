//
//  Adventure.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/18/16.

#import "Adventure.h"

@implementation Adventure

-(id)init {
	return [self initWithDictionary:nil];
}

-(id)initWithDictionary:(NSDictionary *)jsonAdventure {
	self = [super init];
	
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