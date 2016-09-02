//
//  IoriJsonHelper.m
//  Artemis
//
//  Created by Iori on 3/25/16.
//  Copyright © 2016 Hointe. All rights reserved.
//

#import "IoriJsonHelper.h"

@implementation IoriJsonHelper

+(NSDictionary*)getDictForKey:(NSString*)key fromDict:(NSDictionary*)dict
{
    return (NSDictionary*)[self getObjectForKey:key fromDict:dict];
}

+(NSArray*)getArrayForKey:(NSString*)key fromDict:(NSDictionary*)dict
{
    return (NSArray*)[self getObjectForKey:key fromDict:dict];
}

+(NSString*)getStringForKey:(NSString*)key fromDict:(NSDictionary*)dict
{
    return (NSString*)[self getObjectForKey:key fromDict:dict];
}

+(NSInteger)getIntegerForKey:(NSString*)key fromDict:(NSDictionary*)dict
{
    return [[self getStringForKey:key fromDict:dict] integerValue];
}

+(NSObject*)getObjectForKey:(NSString*)key fromDictOrArray:(NSObject*)obj
{
    if([obj isKindOfClass:[NSDictionary class]])
    {
        return [self getObjectForKey:key fromDict:(NSDictionary*)obj];
    }
    else if([obj isKindOfClass:[NSArray class]])
    {
        return [self getObjectForKey:key fromArray:(NSArray*)obj];
    }
    return nil;
}

+(NSObject*)getObjectForKey:(NSString*)key fromDict:(NSDictionary*)dict
{
    NSArray<NSString*> *arrayAllKeys = dict.allKeys;
    for (int i = 0; i<arrayAllKeys.count; i++)
    {
        NSString *__key = arrayAllKeys[i];
        if([__key isEqualToString:key])
        {
            return [dict objectForKey:key];
        }
        else
        {
            NSObject *result = [self getObjectForKey:key fromDictOrArray:[dict objectForKey:__key]];
            if(result != nil) return result;
        }
    }
    return nil;
}

+(NSObject*)getObjectForKey:(NSString*)key fromArray:(NSArray*)array
{
    for (int j=0; j<array.count; j++)
    {
        NSObject *result = [self getObjectForKey:key fromDictOrArray:array[j]];
        if(result != nil) return result;
    }
    return nil;
}

@end
