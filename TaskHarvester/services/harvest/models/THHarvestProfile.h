//
//  THHarvestProfile.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/1/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THMappable.h"
#import "THHarvestService.h"

@interface THHarvestProfile : NSObject<THMappable>

@property NSString *firstName;
@property NSString *lastName;
@property NSString *avatarUrl;

@property NSString *companyName;
@property NSString *colorScheme;

-(void) get:(void (^)(RKObjectRequestOperation *operation,
                      RKMappingResult *mappingResult))success;

-(NSString*) displayName;

@end
