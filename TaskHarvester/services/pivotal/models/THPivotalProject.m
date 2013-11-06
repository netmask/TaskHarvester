//
//  THPivotalProject.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/3/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THPivotalProject.h"
#import "THPivotalService.h"
#import "THPivotalStory.h"

@implementation THPivotalProject
+(RKObjectMapping*) mappings
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
  [mapping addAttributeMappingsFromArray:@[@"id", @"name"]];

  return mapping;
}

-(NSString*) relativeUrl
{
  return @"/services/v5/projects/";
}


-(void) getAll:(void (^)(RKObjectRequestOperation *operation,
                         RKMappingResult *mappingResult))success
{
  
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THPivotalProject mappings]
                                                                                          method:RKRequestMethodGET
                                                                                     pathPattern:[self relativeUrl]
                                                                                         keyPath:nil
                                                                                     statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  
  [[[THPivotalService sharedinstance] objectManager] addResponseDescriptor:responseDescriptor];
  
  [[[THPivotalService sharedinstance] objectManager] getObjectsAtPath:[self relativeUrl]
                                                           parameters:nil
                                                              success:success
                                                              failure:nil];
  
  
}
@end
