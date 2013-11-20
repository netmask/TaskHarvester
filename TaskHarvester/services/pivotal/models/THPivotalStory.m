//
//  THPivotalStory.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/4/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THPivotalStory.h"

@implementation THPivotalStory
+(RKObjectMapping*) mappings
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
  [mapping addAttributeMappingsFromDictionary:@{@"id"  : @"id",
                                                @"story_type" : @"storyType",
                                                @"name" : @"name",
                                                @"url" : @"url",
                                                @"estimate": @"estimate",
                                                @"current_state" : @"currentState",
                                                @"created_at" : @"createdAt"
                                                }];
  
  return mapping;
}

-(NSString*) relativeUrl
{
  return NSStringWithFormat(@"%@%@/stories", [_project relativeUrl], [_project id]);
}


-(void) startTimer{
  
}

-(id) initWithProject:(THPivotalProject*) project{
  self = [super init];  
  [self setProject:project];
  return self;
}


-(void) getAll:(void (^)(RKObjectRequestOperation *operation,
                         RKMappingResult *mappingResult))success
{
  
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THPivotalStory mappings]
                                                                                          method:RKRequestMethodGET
                                                                                     pathPattern:[self relativeUrl]
                                                                                         keyPath:nil
                                                                                     statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  
  [[[THPivotalService sharedinstance] objectManager] addResponseDescriptor:responseDescriptor];
  
  [[[THPivotalService sharedinstance] objectManager] getObjectsAtPath:[self relativeUrl]
                                                           parameters:@{@"filter" : @"current_state:unscheduled,unstarted,started,rejected"}
                                                              success:success
                                                              failure:nil];
}


@end
