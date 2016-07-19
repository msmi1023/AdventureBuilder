//
//  Customer.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Customer.h"

@implementation Customer

-(id)initWithDictionary:(NSDictionary *)jsonCustomer {
	self = [super init];
	if(!self) {
		return nil;
	}
	
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

@end