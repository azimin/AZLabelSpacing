//
//  UILabel+AZSpacing.m
//  LabelSpacing
//
//  Created by Alex Zimin on 18/11/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

#import "UILabel+AZSpacing.h"
#import "AZMethodSwizzle.h"
#import <objc/runtime.h>

@implementation UILabel (AZSpacing)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SwizzleInstanceMethod(self, @selector(setText:), @selector(_spacingSetText:));
    SwizzleInstanceMethod(self, @selector(awakeFromNib), @selector(spacingAwakeFromNib));
  });
}

#pragma mark - Swizzled Methods

- (void)spacingAwakeFromNib {
  [self spacingAwakeFromNib];
  
  // For text loaded from IB
  if (self.characterSpacing != 0 || self.az_LineSpacing != 0) {
    [self setText:self.text];
  }
}

- (void)_spacingSetText:(NSString*)text {
  text = text ?: @"";
  [self _spacingSetText:text];
  
  if (self.characterSpacing != 0 || self.az_LineSpacing != 0) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    
    if (self.characterSpacing != 0) {
      // Inicialize AttributedString with NSKernAttributeName will break label aligment
      [attributedString addAttribute:NSKernAttributeName
                               value:@(self.characterSpacing)
                               range:NSMakeRange(0, attributedString.length)];
    }
    
    if (self.az_LineSpacing != 0) {
      NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      [style setLineSpacing:self.az_LineSpacing];
      [style setLineBreakMode:self.lineBreakMode];
      [style setAlignment:self.textAlignment];
      [attributedString addAttribute:NSParagraphStyleAttributeName
                               value:style
                               range:NSMakeRange(0, attributedString.length)];
    }
    
    self.attributedText = attributedString;
  }
}

#pragma mark - Properties

- (void)setCharacterSpacing:(CGFloat)characterSpacing
{
  objc_setAssociatedObject(self, @selector(characterSpacing), @(characterSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)characterSpacing
{
  NSNumber *number = (NSNumber*)objc_getAssociatedObject(self, @selector(characterSpacing));
#if CGFLOAT_IS_DOUBLE
  return [number doubleValue];
#else
  return [number floatValue];
#endif
}

- (void)setAz_LineSpacing:(CGFloat)az_LineSpacing
{
  objc_setAssociatedObject(self, @selector(az_LineSpacing), @(az_LineSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)az_LineSpacing
{
  NSNumber *number = (NSNumber*)objc_getAssociatedObject(self, @selector(az_LineSpacing));
#if CGFLOAT_IS_DOUBLE
  return [number doubleValue];
#else
  return [number floatValue];
#endif
}

@end
