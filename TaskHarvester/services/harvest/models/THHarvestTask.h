//
//  THHarvestTask.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/6/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPivotalStory.h"

@interface THHarvestTask : NSObject
@property NSString *id;
@property NSString *name;

-(void) createEntryWithPivotalStory:(THPivotalStory*) story success:(void (^)(RKObjectRequestOperation *operation,
                                                                              RKMappingResult *mappingResult))success;

@end
