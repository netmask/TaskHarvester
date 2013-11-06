//
//  THHarvestProfile.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/1/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THHarvestProfile.h"

@implementation THHarvestProfile
+(RKObjectMapping*) mappings
{
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self.class];
  
  [mapping addAttributeMappingsFromDictionary:@{
                                                @"user.first_name":@"firstName",
                                                @"user.last_name": @"lastName",
                                                @"user.avatar_url":@"avatarUrl",
                                                @"company.name": @"companyName",
                                                @"company.color_scheme": @"colorScheme"
                                                }];
  return mapping;
}

-(NSString*) relativeUrl
{
  return @"/account/who_am_i.json";
}


-(void) get:(void (^)(RKObjectRequestOperation *operation,
                                     RKMappingResult *mappingResult))success
{
  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[THHarvestProfile mappings]
                                                                                          method:RKRequestMethodGET
                                                                                     pathPattern:[self relativeUrl]
                                                                                         keyPath:nil
                                                                                     statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  [[[THHarvestService sharedinstance] objectManager] addResponseDescriptor:responseDescriptor];
  
  [[[THHarvestService sharedinstance] objectManager] getObject:nil
                                                          path:[self relativeUrl]
                                                    parameters:nil
                                                       success:success
                                                       failure:nil];
}

-(NSString*) displayName
{
  return [NSString stringWithFormat:@"%@ %@", [_firstName split][0], [_lastName split][0]];
}
@end
