//
//  THHarvestProject.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THMappable.h"
#import "THHarvestService.h"
#import "THHarvestEntry.h"
#import "THHarvestTask.h"

@interface THHarvestProject : NSObject<THMappable>

@property NSNumber *projectId;

@property NSString *name;
@property NSString *code;
@property NSMutableArray *tasks;

-(void) getAll:(void (^)(RKObjectRequestOperation *operation,
                      RKMappingResult *mappingResult))success;

@end
