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
  self = [super initWithFrame:NSMakeRect(0, 0, 325, 500)];
  
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
  NSRect fullBounds = [self bounds];
  fullBounds.size.height += 8;
  fullBounds.origin.y -= 4;

  CALayer *imageLayer = [self userImage].layer;
  [imageLayer setCornerRadius:25];
  [imageLayer setBorderWidth:1];
  [imageLayer setMasksToBounds:YES];
  
  
  [[NSBezierPath bezierPathWithRect:fullBounds] setClip];
  
  [[NSColor whiteColor] set];
  NSRectFill( fullBounds );
}


@end
