//
//  CalcBrain.h
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/22.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CalcBrain : NSObject

+ (CGFloat)calcDistance:(CGPoint)a :(CGPoint)b;
+ (BOOL)ifMoveView:(CGPoint)a :(CGPoint)b;

@end
