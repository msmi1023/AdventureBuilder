//
//  Customer.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Customer.h"

@implementation Customer

-(id)init {
	return [self initWithDictionary:nil];
}

-(id)initWithDictionary:(NSDictionary *)jsonCustomer {
	self = [super init];
	
	if(jsonCustomer == nil || [jsonCustomer allKeys].count == 0) {
		_emailAddress = @"";
		_firstName = @"";
		_lastName = @"";
		_phone = @"";
	}
	else {
		_emailAddress = jsonCustomer[@"emailAddress"];
		_firstName = jsonCustomer[@"firstName"];
		_lastName = jsonCustomer[@"lastName"];
		_phone = jsonCustomer[@"phone"];
	}
	
	return self;
}

-(NSDictionary *)getDictionaryRepresentation {
	return @{@"emailAddress":_emailAddress,
			 @"firstName":_firstName,
			 @"lastName":_lastName,
			 @"phone":_phone};
}

-(NSString *)serializeToJSON {
	NSDictionary *classDictionary = [self getDictionaryRepresentation];
	
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:classDictionary options:0 error:&error];
	NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
	return str;
}

-(BOOL)compareTo:(Customer *)anotherCustomer {
	return ([self.emailAddress isEqualToString:anotherCustomer.emailAddress]);
}

@end