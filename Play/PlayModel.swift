//
//  CalcBrain.swift
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/20.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

import Foundation

class CalcBrain {
    
    func calcDistance(a:CGPoint, b: CGPoint) -> Double {
        let deltaX = a.x - b.x
        let deltaY = a.y - b.y
        return sqrt(Double(deltaX*deltaX) + Double(deltaY*deltaY))
    }
    
    func ifMoveView(a: CGPoint, b: CGPoint) -> Bool {
        if (calcDistance(a: a, b: b) > 10) && (abs(a.x - b.x) > abs(a.y - b.y)){
            return true
        }
        return false
    }
}
