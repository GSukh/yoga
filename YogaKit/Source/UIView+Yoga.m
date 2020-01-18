/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "UIView+Yoga.h"
#import "YGLayout+Private.h"
#import <objc/runtime.h>

static const void *kYGYogaAssociatedKey = &kYGYogaAssociatedKey;

@interface UIView (YogaKit) <YGLayoutNode>
@end

@implementation UIView (YogaKit)

- (YGLayout *)yoga
{
  YGLayout *yoga = objc_getAssociatedObject(self, kYGYogaAssociatedKey);
  if (!yoga) {
    yoga = [[YGLayout alloc] initWithLayoutNode:self];
    objc_setAssociatedObject(self, kYGYogaAssociatedKey, yoga, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }

  return yoga;
}

- (BOOL)isYogaEnabled
{
  return objc_getAssociatedObject(self, kYGYogaAssociatedKey) != nil;
}

- (void)configureLayoutWithBlock:(YGLayoutConfigurationBlock)block
{
  if (block != nil) {
    block(self.yoga);
  }
}

- (void)safeSetFrame:(CGRect)frame
{
  NSCAssert([NSThread isMainThread], @"Framesetting should only be done on the main thread.");
  [self setFrame:frame];
}

- (NSArray<id<YGLayoutNode>> *)subnodes
{
  NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
  return self.subviews;
}

- (BOOL)isUIView
{
  return [self isMemberOfClass:[UIView class]];
}

@end
