//
//  AdventureService.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/27/16.

#import <Foundation/Foundation.h>
#import "JabApiManager.h"
#import "Adventure.h"

@interface AdventureService : NSObject

typedef void (^completion_t)(id response);

-(instancetype)init;
-(instancetype)initWithApiManager:(JabApiManager *)jabApiManager;
-(void)getAdventuresWithCompletionBlock:(completion_t)completionBlock;

@end