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

-(void) switchTimer:(void (^)(RKObjectRequestOperation *operation,
                              RKMappingResult *mappingResult))success
{
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THHarvestEntry mappings]
                                                                                          method:RKRequestMethodGET
                                                                                     pathPattern:@"/daily/timer/:day_entry_id"
                                                                                         keyPath:nil
                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  
  [[[THHarvestService sharedinstance] objectManager] addResponseDescriptor:responseDescriptor];
  
  
  [[[THHarvestService sharedinstance] objectManager] getObject:nil
                                                           path:NSStringWithFormat(@"/daily/timer/%@", _id)
                                                     parameters:nil
                                                        success:success
                                                        failure:nil];


}

@end
