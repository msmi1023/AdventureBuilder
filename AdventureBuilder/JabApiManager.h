//
//  JabApiManager.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "AFNetworking.h"
#import <UIKit/UIKit.h>

@interface JabApiManager : AFHTTPSessionManager

-(void)setUsername:(NSString *)username andPassword:(NSString *)password;

+(JabApiManager *)sharedManager;

@end