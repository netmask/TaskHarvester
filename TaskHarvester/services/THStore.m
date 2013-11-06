//
//  THStore.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THStore.h"

@implementation THStore

+(THStore *)instance {
  static dispatch_once_t pred;
  static THStore *shared = nil;
  
  dispatch_once(&pred, ^{
    shared = [[THStore alloc] init];
  });
  
  return shared;
}
@end
