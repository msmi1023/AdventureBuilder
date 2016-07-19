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

@end