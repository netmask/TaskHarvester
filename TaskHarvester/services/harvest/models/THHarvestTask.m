//
//  THHarvestTask.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/6/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THHarvestTask.h"

@implementation THHarvestTask
-(void) createEntryWithPivotalStory:(THPivotalStory*) story
                            success:(void (^)(RKObjectRequestOperation *operation,
                                          RKMappingResult *mappingResult))success
{
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THHarvestEntry mappings]
                                                                                         method:RKRequestMethodPOST
                                                                                    pathPattern:@"/daily/add"
                                                                                        keyPath:nil
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
  
  [[[THHarvestService sharedinstance] objectManager] addResponseDescriptor:responseDescriptor];
  
  NSString *notes = NSStringWithFormat(@"[%li pts][ %@ ] %@",(long)[[story estimate] integerValue], [story id], [story name]);
  
  [[[THHarvestService sharedinstance] objectManager] postObject:nil
                                                           path:@"/daily/add"
                                                     parameters:@{
                                                                        @"notes" : notes,
                                                                        @"task_id" : _id,
                                                                        @"project_id" : [[[THStore instance] harvestProject] projectId],
                                                                        @"spent_at" : [NSDate date]
                                                                        }
                                                              success:success
                                                              failure:nil];
}
@end
