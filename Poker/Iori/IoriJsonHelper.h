//
//  IoriJsonHelper.h
//  Artemis
//
//  Created by Iori on 3/25/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IoriJsonHelper : NSObject

+(NSDictionary*)getDictForKey:(NSString*)key fromDict:(NSDictionary*)dict;
+(NSArray*)getArrayForKey:(NSString*)key fromDict:(NSDictionary*)dict;
+(NSString*)getStringForKey:(NSString*)key fromDict:(NSDictionary*)dict;
+(NSInteger)getIntegerForKey:(NSString*)key fromDict:(NSDictionary*)dict;
+(NSObject*)getObjectForKey:(NSString*)key fromDictOrArray:(NSObject*)obj;
+(NSObject*)getObjectForKey:(NSString*)key fromDict:(NSDictionary*)dict;
+(NSObject*)getObjectForKey:(NSString*)key fromArray:(NSArray*)array;

@end
