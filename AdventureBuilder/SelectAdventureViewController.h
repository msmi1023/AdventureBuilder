//
//  SelectAdventureViewController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAdventureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *adventureType;
@property (weak, nonatomic) IBOutlet UIPickerView *adventure;
@property (weak, nonatomic) IBOutlet UITextView *details;

@end
