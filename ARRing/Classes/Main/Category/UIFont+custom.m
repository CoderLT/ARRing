//
//  UIFont+custom.m
//  VRBOX
//
//  Created by CoderLT on 16/3/11.
//  Copyright © 2016年 VR. All rights reserved.
//

#import "UIFont+custom.h"
#import <CoreText/CoreText.h>

@implementation UIFont (custom)
- (instancetype)fixedWidth {
    UIFontDescriptor *const existingDescriptor = [self fontDescriptor];
    NSDictionary *const fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: @[
                                                    @{ UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                                                       UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
                                                       }]
                                            };
    UIFontDescriptor *const proportionalDescriptor = [existingDescriptor fontDescriptorByAddingAttributes: fontAttributes];
   return [UIFont fontWithDescriptor:proportionalDescriptor size:[self pointSize]];
}
@end
