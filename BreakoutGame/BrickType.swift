//
//  PaddleType.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class BrickType {
    let maxHits: Int
        
    private init(_ maxHit:Int) {
        self.maxHits = maxHit
    }
        
    func onHit(brick: Brick, level: Level) ->(Bool) {return true}
    
    class var NORMAL: BrickType {
        class Normal: BrickType {
            override func onHit(brick: Brick, level: Level) ->(Bool) {
                println("Attack with shuriken.")
                return true;
            }
        }
        return Normal(1)
    }
    
    class var DOUBLE: BrickType {
        class DoublePoints: BrickType {
            override func onHit(brick: Brick, level: Level) -> (Bool) {
                println("Attack with sword.")
                return true;
            }
        }
        return DoublePoints(2)
    }
    
    class func CUSTOM(maxHit: Int) -> BrickType {
        return BrickType(maxHit)
    }
}

func == (lhs: BrickType, rhs: BrickType) -> Bool {
    return lhs.maxHits == rhs.maxHits
}