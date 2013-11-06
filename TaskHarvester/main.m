//
//  main.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THAppDelegate.h"

int main(int argc, const char * argv[])
{
  [NSApplication sharedApplication];
  THAppDelegate *appDelegate = [[THAppDelegate alloc] init];
  [NSApp setDelegate:appDelegate];
  [NSApp run];
}
