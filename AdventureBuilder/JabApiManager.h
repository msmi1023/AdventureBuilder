//
//  JabApiManager.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/18/16.

#import "AFNetworking.h"
#import <UIKit/UIKit.h>

@interface JabApiManager : AFHTTPSessionManager

+(JabApiManager *)sharedManager;

@end