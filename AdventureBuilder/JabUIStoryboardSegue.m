//
//  JabUIStoryboardSegue.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "JabUIStoryboardSegue.h"
#import "JabUIStoryboard.h"

@implementation JabUIStoryboardSegue

-(instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
	//call out to our storyboard to set up necessary dependencies
	JabUIStoryboard *jabSb = ((JabUIStoryboard *) source.storyboard);
	
	[jabSb setDependenciesForViewController:destination];
	
	return [super initWithIdentifier:identifier source:source destination:destination];
};

@end
