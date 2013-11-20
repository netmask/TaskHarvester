//
//  THSettingsView.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 11/6/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THSettingsView.h"

@implementation THSettingsView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

      NSArray *objects = @[];

      if([[NSBundle mainBundle] loadNibNamed:@"THSettingsView"
                                       owner:self
                             topLevelObjects:&objects])
      {
        [self addSubview:[objects detect:^BOOL(id object) {
          return [object isKindOfClass:NSView.class];
        }]];
      }
    }
    return self;
}

@end
