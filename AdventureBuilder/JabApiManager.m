//
//  JabApiManager.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//


//implementation example from http://stackoverflow.com/questions/12440059/using-afnetworking-and-http-basic-authentication

#import "JabApiManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation JabApiManager

-(void)setUsername:(NSString *)username andPassword:(NSString *)password {
	[self.requestSerializer clearAuthorizationHeader];
	[self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

-(id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if(!self) {
		return nil;
	}
	
	self.requestSerializer = [AFJSONRequestSerializer serializer];
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
	return self;
}

+(JabApiManager *)sharedManager {
	static dispatch_once_t pred;
	static JabApiManager *_sharedManager = nil;
	
	dispatch_once(&pred, ^{
		_sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:9500/api"]];
		[_sharedManager setUsername:@"wasadm01" andPassword:@"wasadm01"];
	});
	
	return _sharedManager;
}

@end