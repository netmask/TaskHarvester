//
//  THHarvestProject.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THHarvestProject.h"

@implementation THHarvestProject

+(RKObjectMapping*) mappings
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
  
  RKObjectMapping* taskMapping = [RKObjectMapping mappingForClass:[THHarvestTask class]];
  [taskMapping addAttributeMappingsFromArray:@[@"id", @"name"]];

  [mapping addAttributeMappingsFromDictionary:@{
                                                @"id":@"projectId",
                                                @"name": @"name",
                                                @"code":@"code"
                                                }];
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"tasks"
                                                                          toKeyPath:@"tasks"
                                                                        withMapping:taskMapping]];
  
  
  return mapping;
}

-(NSString*) relativeUrl
{
  return @"/daily.json";
}

-(void) getAll:(void (^)(RKObjectRequestOperation *operation,
                         RKMappingResult *mappingResult))success
{
  
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THHarvestProject mappings]
                                                                                          method:RKRequestMethodGET
                                                                                     pathPattern:[self relativeUrl]
                                                                                         keyPath:@"projects"
                                                                                     statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  RKResponseDescriptor *entriesDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THHarvestEntry mappings]
                                                                                          method:RKRequestMethodGET
                                                                                     pathPattern:[self relativeUrl]
                                                                                         keyPath:@"day_entries"
                                                                                     statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  
  [[[THHarvestService sharedinstance] objectManager] addResponseDescriptor:responseDescriptor];
  [[[THHarvestService sharedinstance] objectManager] addResponseDescriptor:entriesDescriptor];
  
  [[[THHarvestService sharedinstance] objectManager] getObjectsAtPath:[self relativeUrl]
                                                           parameters:nil
                                                              success:success
                                                              failure:nil];

}
@end
