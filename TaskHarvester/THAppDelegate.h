//
//  THAppDelegate.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THMainViewController.h"

@interface THAppDelegate : NSObject <NSApplicationDelegate>
@property (strong) THMainViewController *mainController;
@end
