//
//  NSString+HTML.h
//  bookReader
//
//  Created by Jobs on 2020/8/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HTML)
/**
 Extract the numbers from this string and return them as an NSUInteger.
 @returns An NSUInteger of the number characters in this string.
 */
- (NSUInteger)integerValueFromHex;


/**
 Test whether or not this string is numeric only.
 @returns If this string consists only of numeric characters 0-9.
 */
- (BOOL)isNumeric;

/**
 Test whether the entire receiver consists of only whitespace characters.
 @returns `YES` if the receiver only has whitespace and newline characters
 */
- (BOOL)isIgnorableWhitespace;

/**
 Read through this string and store the numbers included, then divide them by 100 giving a percentage.
 @returns The numbers contained in this string, as a percentage.
 */
- (float)percentValue;


/**
 Return a copy of this string with all whitespace characters replaced by space characters.
 @returns A copy of this string with only space characters for whitespace.
 */
- (NSString *)stringByNormalizingWhitespace;


/**
 Determines if the first character of this string is in the parameter characterSet.
 @param characterSet The character set to compare the first character of this string against.
 @returns If the first character of this string is in character set.
 */
- (BOOL)hasPrefixCharacterFromSet:(NSCharacterSet *)characterSet;


/**
 Determines if the last character of this string is in the parameter characterSet.
 @param characterSet The character set to compare the last character of this string against.
 @returns If the last character of this string is in the character set.
 */
- (BOOL)hasSuffixCharacterFromSet:(NSCharacterSet *)characterSet;


/**
 Convert a string into a proper HTML string by converting special characters into HTML entities. For example: an ellipsis `…` is represented by the entity `&hellip;` in order to display it correctly across text encodings.
 @returns A string containing HTML that now uses proper HTML entities.
 */
- (NSString *)stringByAddingHTMLEntities;


/**
 Convert a string from HTML entities into correct character representations using UTF8 encoding. For example: an ellipsis entity represented by `&hellip;` is converted into `…`.
 @returns A string without HTML entities, instead having the actual characters formerly represented by HTML entities.
 */
- (NSString *)stringByReplacingHTMLEntities;


/**
 Replaces occurrences of more two or more spaces with a range of alternating non-breaking space and regular space. It also encloses these parts with a span of class 'Apple-converted-space'
 */
- (NSString *)stringByAddingAppleConvertedSpace;
@end

NS_ASSUME_NONNULL_END
