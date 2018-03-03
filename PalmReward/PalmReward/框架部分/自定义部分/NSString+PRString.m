//
//  NSString+PRString.m
//  PalmReward
//
//  Created by rimi on 16/12/17.
//  Copyright © 2016年 zjy. All rights reserved.
//

#import "NSString+PRString.h"

@implementation NSString (PRString)
-(NSString *)ReplaceSlash{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}
@end
