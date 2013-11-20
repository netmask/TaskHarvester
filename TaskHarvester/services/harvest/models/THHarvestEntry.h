//
//  THHarvestEntry.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/5/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THMappable.h"
#import "THHarvestService.h"
#import "THPivotalStory.h"

@interface THHarvestEntry :  NSObject<THMappable>

@property NSDate *timeStartedAt;
@property NSNumber *id;
@property NSNumber *hours;
@property NSString *notes;

-(BOOL) asTimer;

-(void) switchTimer:(void (^)(RKObjectRequestOperation *operation,
                                       RKMappingResult *mappingResult))success;

@end
