//
//  UILabel+AZCharacterSpacing.m
//  LabelSpacing
//
//  Created by Alex Zimin on 18/11/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

#import "UILabel+AZCharacterSpacing.h"
#import "AZMethodSwizzle.h"
#import <objc/runtime.h> 

@implementation UILabel (AZCharacterSpacing)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SwizzleInstanceMethod(self, @selector(setText:), @selector(_characterSpacingSetText:));
    SwizzleInstanceMethod(self, @selector(awakeFromNib), @selector(_characterSpacingAwakeFromNib));
  });
}

#pragma mark - Swizzled Methods

- (void)_characterSpacingAwakeFromNib {
  [self _characterSpacingAwakeFromNib];
  
  // For text loaded from IB
  [self setText:self.text];
}

- (void)_characterSpacingSetText:(NSString*)text {
  [self _characterSpacingSetText:text];
  
  if (self.characterSpacing != 0) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    // Inicialize AttributedString with NSKernAttributeName will break label aligment
    [attributedString addAttribute:NSKernAttributeName value:@(self.characterSpacing) range:NSMakeRange(0, [text length] - 1)];
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

@end
