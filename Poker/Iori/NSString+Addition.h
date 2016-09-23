//
//  NSString+Addition.h
//  IoriLibrary
//
//  Created by Iori on 6/27/14.
//  Copyright (c) 2014 Iori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
+(NSString*)getFormatedInteger:(NSInteger)iValue byLength:(NSInteger)length;
+(NSString*)getFormatedNumberByInteger:(NSInteger)val;
-(NSString*)getFormatedNumber;
-(NSString*)getFormatedNumber:(NSNumberFormatterStyle)formateStyle;
@end
