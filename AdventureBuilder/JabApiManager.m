//
//  JabApiManager.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/18/16.


//implementation example from http://stackoverflow.com/questions/12440059/using-afnetworking-and-http-basic-authentication

#import "JabApiManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation JabApiManager

-(id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	
	self.requestSerializer = [AFJSONRequestSerializer serializer];
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	
	return self;
}

+(JabApiManager *)sharedManager {
	//have these hang out here so we can utilize them in test context
	static dispatch_once_t pred;
	static JabApiManager *sharedManager = nil;
	dispatch_once(&pred, ^{
		sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:9500/api"]];
	});
	
	return sharedManager;
}

@end
