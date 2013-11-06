//
//  THMappable.h
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/1/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@protocol THMappable <NSObject>
+ (RKObjectMapping*)mappings;
- (NSString*)relativeUrl;
@end
