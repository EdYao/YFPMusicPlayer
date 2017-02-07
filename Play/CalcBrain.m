//
//  CalcBrain.m
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/22.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import "CalcBrain.h"

@implementation CalcBrain

+ (CGFloat)calcDistance:(CGPoint)a :(CGPoint)b {
    CGFloat deltaX = a.x - b.x;
    CGFloat deltaY = a.y - b.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY);
}

+ (BOOL)ifMoveView:(CGPoint)a :(CGPoint)b {
    if ([self calcDistance:a :b] > 10 && (fabs(a.x - b.x) > fabs(a.y - b.y))) {
        return true;
    }
    
    return NO;
}

@end
