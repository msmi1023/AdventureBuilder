//
//  JabUIStoryboardSegue.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JabUIStoryboardSegue : UIStoryboardSegue

-(instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination;

@end
