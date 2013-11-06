//
//  THAppDelegate.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THAppDelegate.h"

@implementation THAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
  RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

  [self setMainController:[THMainViewController new]];
}

@end
