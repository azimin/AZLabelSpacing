//
//  AZMethodSwizzle.m
//  LabelSpacing
//
//  Created by Alex Zimin on 18/11/15.
//  Copyright © 2015 Alex Zimin. All rights reserved.
//

#import "AZMethodSwizzle.h"
#import <objc/runtime.h>

void SwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
  Method originalMethod = class_getInstanceMethod(c, orig);
  Method newMethod = class_getInstanceMethod(c, new);
  
  BOOL methodAdded = class_addMethod([c class],
                                     orig,
                                     method_getImplementation(newMethod),
                                     method_getTypeEncoding(newMethod));
  
  if (methodAdded) {
    class_replaceMethod([c class], 
                        new, 
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, newMethod);
  }
}