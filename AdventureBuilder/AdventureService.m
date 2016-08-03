//
//  AdventureService.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/27/16.

#import "AdventureService.h"

@implementation AdventureService {
	JabApiManager *apiManager;
}

//DI constructor to bring in the api manager
//our api manager is a singleton, so we can hard-code the dependency in init
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager {
	self = [super init];
	apiManager = jabApiManager;
	return self;
}

//override normal init to use the shared api manager.
//makes it so our storyboard injected instance will already have the api manager
-(instancetype)init {
	return [self initWithApiManager:[JabApiManager sharedManager]];
}

-(void)getAdventuresWithCompletionBlock:(completion_t)completionBlock {
	[apiManager GET:@"adventures" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
		NSMutableArray *toReturn = [[NSMutableArray alloc] init];
		
		//create array of booking objects
		for(NSDictionary *jsonAdventure in responseObject) {
			[toReturn addObject:[[Adventure alloc] initWithDictionary:jsonAdventure]];
		}
		
		completionBlock([toReturn copy]);
	} failure:^(NSURLSessionTask *task, NSError *error) {
		completionBlock(error);
	}];
}

@end