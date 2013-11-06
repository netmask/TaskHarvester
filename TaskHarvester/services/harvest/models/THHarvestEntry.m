//
//  THHarvestEntry.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THHarvestEntry.h"

//TODO this class is the same one that project, need refactorize
@implementation THHarvestEntry
+(RKObjectMapping*) mappings
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
  
  [mapping addAttributeMappingsFromDictionary:@{
                                                @"id":@"id",
                                                @"timer_started_at": @"timeStartedAt",
                                                @"hours":@"hours",
                                                @"notes" : @"notes"                                                
                                                }];

  return mapping;
}

-(NSString*) relativeUrl
{
  return @"/daily.json";
}


-(BOOL) asTimer
{
  return _timeStartedAt != nil;
}

-(void) startTimerWithStory:(THPivotalStory*) story
{
  NSLog(@"astarstars");
}

@end
