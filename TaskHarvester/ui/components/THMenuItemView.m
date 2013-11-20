//
//  THMenuItemView.m
//  TaskHarvester
//
//  Created by Jonathan Garay on 10/31/13.
//  Copyright (c) 2013 Crowdint. All rights reserved.
//

#import "THMenuItemView.h"
#import <QuartzCore/QuartzCore.h>

@implementation THMenuItemView

- (id) init {
  self = [super initWithFrame:NSMakeRect(0, 0, 320, 495)];
  
  NSArray *objects = @[];
  
  if([[NSBundle mainBundle] loadNibNamed:@"THMenuItemView" owner:self topLevelObjects:&objects])
  {
    [self addSubview:[objects detect:^BOOL(id object) {
      return [object isKindOfClass:NSView.class];
    }]];
  }
  
    
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];

  CALayer *imageLayer = [self userImage].layer;
  [imageLayer setCornerRadius:25];
  [imageLayer setBorderWidth:1];
  [imageLayer setMasksToBounds:YES];
  
  [self setLayer:[[self superview] layer]];
  [[[self superview] layer] setMasksToBounds:YES];

}


@end
